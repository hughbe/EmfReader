//
//  EMR_HEADER.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.4.2 EMR_HEADER Record Types
/// The EMR_HEADER record is the starting point of an EMF metafile. It specifies properties of the device on which the image in the
/// metafile was recorded; this information in the header record makes it possible for EMF metafiles to be independent of any specific
/// output device.
/// The following are the EMR_HEADER record types.
/// Name Section Description
/// EmfMetafileHeader 2.3.4.2.1 The original EMF header record.
/// EmfMetafileHeaderExtension1 2.3.4.2.2 The header record defined in the first extension to EMF, which added support for OpenGL
/// records and an optional internal pixel format descriptor.<62>
/// EmfMetafileHeaderExtension2 2.3.4.2.3 The header record defined in the second extension to EMF, which added the capability of
/// measuring display dimensions in micrometers.<63>
/// EMF metafiles SHOULD be created with an EmfMetafileHeaderExtension2 header record.
/// The generic structure of EMR_HEADER records is specified as follows.
/// Fields not specified in this section are specified in section 2.3.4.
/// The value of the Size field can be used to distinguish between the different EMR_HEADER record types listed earlier in this section.
/// There are three possible headers:
///  The EmfMetafileHeader record. The fixed-size part of this header is 88 bytes, and it contains a Header object (section 2.2.9).
///  The EmfMetafileHeaderExtension1 record. The fixed-size part of this header is 100 bytes, and it contains a Header object and a
/// HeaderExtension1 object (section 2.2.10).
///  The EmfMetafileHeaderExtension2 record. The fixed-size part of this header is 108 bytes, and it contains a Header object, a
/// HeaderExtension1 object, and a HeaderExtension2 object (section 2.2.11).
/// There are one or two optional, variable-length fields that are possible in each header: a description string and a pixel format field.
/// In all three types of headers, the fixed-size part comes first, followed by the variable-length fields.
/// The algorithm shown in the following figure computes a non-negative integer variable called HeaderSize from the offsets and lengths
/// of the variable-length data. The type of header is determined from that value.
/// After applying the algorithm, consider the value of HeaderSize field:
///  If HeaderSize >= 108, the record type is EmfMetafileHeaderExtension2.
///  If HeaderSize >= 100, the record type is EmfMetafileHeaderExtension1.
///  Otherwise, the record type is EmfMetafileHeader.
/// See section 2.3.4 for more control record types.
public struct EMR_HEADER {
    public let type: UInt32
    public let size: UInt32
    public let emfHeader: Header
    public let emfHeaderExtension1: HeaderExtension1?
    public let emfHeaderExtension2: HeaderExtension2?
    public let description: String?
    public let pixelFormat: PixelFormatDescriptor?
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_HEADER. This value is 0x00000001.
        self.type = try dataStream.read(endianess: .littleEndian)
        guard self.type == RecordType.EMR_HEADER.rawValue else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes) The value of the Size field can be used to distinguish between the different EMR_HEADER record types.
        /// See the flowchart in section 2.3.4.2 for details.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.size = size
        
        /// EmfHeader (80 bytes): A Header object (section 2.2.9), which contains information about the content and structure of the
        /// metafile.
        let emfHeader = try Header(dataStream: &dataStream)
        self.emfHeader = emfHeader
        
        let emfHeaderExtension1: HeaderExtension1? = nil
        var headerSize: UInt32 = 88
        if self.size >= 88 {
            headerSize = self.size
            if emfHeader.offDescription >= 88 &&
                emfHeader.offDescription + emfHeader.nDescription * 2 <= size {
                headerSize = self.emfHeader.offDescription
            }
            
            if headerSize >= 100 {
                /// EmfHeaderExtension1 (12 bytes): A HeaderExtension1 object (section 2.2.10), which specifies additional
                /// information about the image in the metafile.
                let emfHeaderExtension1  = try HeaderExtension1(dataStream: &dataStream)
                if emfHeaderExtension1.offPixelFormat >= 88 &&
                    emfHeaderExtension1.offPixelFormat + emfHeaderExtension1.cbPixelFormat <= size {
                    if emfHeaderExtension1.offPixelFormat < headerSize {
                        headerSize = emfHeaderExtension1.offPixelFormat
                    }
                }    
            }
        }
        
        if headerSize >= 108 {
            /// EmfHeaderExtension1 (12 bytes): A HeaderExtension1 object (section 2.2.10), which specifies additional
            /// information about the image in the metafile.
            self.emfHeaderExtension1 = emfHeaderExtension1
            
            /// EmfHeaderExtension2 (8 bytes): A HeaderExtension2 object (section 2.2.11), which specifies additional information
            /// about the image in the metafile.
            self.emfHeaderExtension2 = try HeaderExtension2(dataStream: &dataStream)
        } else if headerSize >= 100 {
            /// EmfHeaderExtension1 (12 bytes): A HeaderExtension1 object (section 2.2.10), which specifies additional
            /// information about the image in the metafile.
            self.emfHeaderExtension1 = emfHeaderExtension1
            self.emfHeaderExtension2 = nil
        } else {
            self.emfHeaderExtension1 = nil
            self.emfHeaderExtension2 = nil
        }
        
        /// EmfDescriptionBuffer (variable, optional): An array of bytes that contains the EMF description string, which is not required
        /// to be contiguous with the fixed-length part of this record. Thus, the undefined space field in this buffer is optional and
        /// MUST be ignored.
        /// EmfDescription (variable): A null-terminated Unicode UTF16-LE string of arbitrary length and content. Its location in the
        /// record and number of characters are specified by the offDescription and nDescription fields, respectively, in EmfHeader.
        /// If the value of either field is zero, no description string is present.
        if emfHeader.offDescription != 0 && emfHeader.nDescription != 0 {
            guard emfHeader.offDescription >= dataStream.position &&
                    emfHeader.offDescription + emfHeader.nDescription <= size else {
                throw EmfReadError.corrupted
            }

            dataStream.position = startPosition + Int(emfHeader.offDescription)
            self.description = try dataStream.readString(count: (Int(emfHeader.nDescription) - 1) * 2, encoding: .utf16LittleEndian) ?? ""
            
            // Read null terminator.
            let _: UInt16 = try dataStream.read(endianess: .littleEndian)
        } else {
            self.description = nil
        }
        
        /// EmfPixelFormatBuffer (variable, optional): An array of bytes that contains the EMF pixel format descriptor, which is not
        /// required to be contiguous with the fixed portion of the EmfMetafileHeaderExtension2 record or with the EMF description
        /// string. Thus, the field in this buffer that is labeled "UndefinedSpace" is optional and MUST be ignored.
        /// mfPixelFormat (40 bytes): A PixelFormatDescriptor object (section 2.2.22) that specifies the last pixel format that was
        /// defined when the metafile was recorded. Its size and location in the record are specified by the cbPixelFormat and
        /// offPixelFormat fields, respectively, in EmfHeaderExtension1. If the value of either field is zero, no pixel format descriptor is
        /// present.
        if let emfHeaderExtension1 = emfHeaderExtension1, emfHeaderExtension1.offPixelFormat != 0 && emfHeaderExtension1.cbPixelFormat != 0 {
            guard emfHeaderExtension1.offPixelFormat >= dataStream.position &&
                    emfHeaderExtension1.offPixelFormat + emfHeaderExtension1.cbPixelFormat <= size else {
                throw EmfReadError.corrupted
            }

            dataStream.position = startPosition + Int(emfHeaderExtension1.offPixelFormat)
            self.pixelFormat = try PixelFormatDescriptor(dataStream: &dataStream)
        } else {
            self.pixelFormat = nil
        }
        
        /// AlignmentPadding (variable, optional): An array of up to 3 bytes that pads the record so that its total size is a multiple of
        /// 4 bytes. This field MUST be ignored.
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
