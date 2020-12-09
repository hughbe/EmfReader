//
//  EMR_EXTCREATEFONTINDIRECTW.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.7.8 EMR_EXTCREATEFONTINDIRECTW Record
/// The EMR_EXTCREATEFONTINDIRECTW record defines a logical font for graphics operations.
/// Fields not specified in this section are specified in section 2.3.7.
/// See section 2.3.7 for more object creation record types.
public struct EMR_EXTCREATEFONTINDIRECTW {
    public let type: RecordType
    public let size: UInt32
    public let ihFonts: UInt32
    public let elw: Elw
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_EXTCREATEFONTINDIRECTW. This value is 0x00000052.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_EXTCREATEFONTINDIRECTW else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes, of this record. This value is 0x0000001C.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 104 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// ihFonts (4 bytes): An unsigned integer that specifies the index of the logical font object in the EMF object table
        /// (section 3.1.1.1). This index MUST be saved so that this object can be reused or modified.
        self.ihFonts = try dataStream.read(endianess: .littleEndian)
        
        /// elw (variable): A LogFontExDv object (section 2.2.15), which specifies the logical font. A LogFont object (section 2.2.13)
        /// MAY<74> be present instead. The process for determining the type of object in this field is described below.
        /// The logical font object defined by this record can be selected into the playback device context by an EMR_SELECTOBJECT
        /// record (section 2.3.8.5), which specifies the logical font to use in subsequent graphics operations.
        /// The type of logical font object in the elw field of this record is determined by the following algorithm (all size and length
        /// values are in bytes):
        ///  First, note that the size in bytes of the static part of this record—that is, the sum of the sizes of its Type, Size, and
        /// ihFonts fields—is 12.
        ///  Next, note that because the size in bytes of the entire record is present in its Size field, the size in bytes of the
        /// variable-length elw field can be computed as follows. Size - 12
        ///  If the size of the elw field is equal to or less than the size of a LogFontPanose object (section 2.2.16), elw MUST be
        /// treated as a fixed-length LogFont object. Bytes beyond the extent of the LogFont object, up to the end of the elw field,
        /// MUST be ignored.
        ///  If the size of the elw field is greater than the size of a LogFontPanose object, then elw MUST be treated as a
        /// variable-length LogFontExDv object.
        /// The size of a LogFontPanose object is 0x0140 (320 decimal). It is determined by adding up the sizes of its fields, as follows:
        ///  LogFont: The size of a LogFont object is 0x005C (92 decimal). It is determined by adding up the sizes of its fields, as
        /// follows:
        ///  Fields from Height through PitchAndFamily: 0x001C (28 decimal).
        ///  Facename: The length is 32 16-bit characters: 0x0040 (64 decimal).
        ///  Fullname: The length is 64 16-bit characters: 0x0080 (128 decimal).
        ///  Style: The length is 32 16-bit characters: 0x0040 (64 decimal).
        ///  Fields from Version through Culture: 0x0018 (24 decimal).
        ///  Panose: The exact length of this field is 0x000A, but it MUST be padded by two additional bytes for 32-bit alignment,
        /// so for the purposes of this computation the length is 0x000C (12 decimal).
        if self.size - 12 <= 0x0140 {
            self.elw = .logFont(try LogFont(dataStream: &dataStream))
        } else {
            self.elw = .logFontExDv(try LogFontExDv(dataStream: &dataStream))
        }
        
        /// Seen extra padding
        let excessCount = Int(self.size) - (dataStream.position - startPosition)
        if excessCount > 0 {
            guard dataStream.position + excessCount <= dataStream.count else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position += excessCount
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
    
    public enum Elw {
        case logFontExDv(_: LogFontExDv)
        case logFont(_: LogFont)
    }
}
