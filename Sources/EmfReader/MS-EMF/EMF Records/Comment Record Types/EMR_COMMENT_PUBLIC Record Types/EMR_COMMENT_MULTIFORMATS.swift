//
//  EMR_COMMENT_MULTIFORMATS.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.3.4.3 EMR_COMMENT_MULTIFORMATS Record
/// The EMR_COMMENT_MULTIFORMATS record specifies an image in multiple graphics formats.
/// Fields not specified in this section are specified in section 2.3.3 or 2.3.3.4.
/// The size of the data for each image is specified by the DataSize field in the corresponding EmrFormat object. Thus, the total size of
/// this field is the sum of DataSize values in all EmrFormat objects.
/// The graphics format of the data for each image is specified by the Signature field in the corresponding EmrFormat object.
/// For example, an application can use this record type to specify an image in EPS format using EpsData objects (section 2.2.6).
/// Subsequently, the PostScript version of the image can be rendered if that graphics format is supported by the printer driver on the
/// playback system.<61>
/// See section 2.3.3.4 for more public comment record types.
public struct EMR_COMMENT_MULTIFORMATS {
    public let type: RecordType
    public let size: UInt32
    public let dataSize: UInt32
    public let commentIdentifier: UInt32
    public let publicCommentIdentifier: EmrComment
    public let outputRect: RectL
    public let countFormats: UInt32
    public let aFormats: [EmrFormat]
    public let formatData: [[UInt8]]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer from the RecordType enumeration (section 2.1.1) that identifies this record as a
        /// comment record. This value is 0x00000046.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_COMMENT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes) The value of the Size field can be used to distinguish between the different EMR_HEADER record types.
        /// See the flowchart in section 2.3.4.2 for details.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 40 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the size in bytes, of the CommentIdentifier and CommentRecordParm
        /// fields in the RecordBuffer field that follows. It MUST NOT include the size of itself or the size of the AlignmentPadding field,
        /// if present.
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 32 && dataSize <= size - 8 else {
            throw EmfReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        /// CommentIdentifier (4 bytes): An unsigned integer that identifies this comment record as specifying public data.
        /// The value 0x43494447, which is the ASCII string "CIDG", identifies this as an EMR_COMMENT_PUBLIC record.
        self.commentIdentifier = try dataStream.read(endianess: .littleEndian)
        guard self.commentIdentifier == 0x43494447 else {
            throw EmfReadError.corrupted
        }
                
        /// PublicCommentIdentifier (4 bytes): An unsigned integer that identifies the type of public comment record as
        /// EMR_COMMENT_MULTIFORMATS from the EmrComment enumeration (section 2.1.10). This value is 0x40000004.
        self.publicCommentIdentifier = try EmrComment(dataStream: &dataStream)
        guard self.publicCommentIdentifier == EmrComment.EMR_COMMENT_MULTIFORMATS else {
            throw EmfReadError.corrupted
        }
        
        /// OutputRect (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the output rectangle, in logical
        /// coordinates.
        self.outputRect = try RectL(dataStream: &dataStream)
        
        /// CountFormats (4 bytes): An unsigned integer that specifies the number of graphics formats contained in this record.
        self.countFormats = try dataStream.read(endianess: .littleEndian)
        guard 40 + self.countFormats * 16 <= self.size else {
            throw EmfReadError.corrupted
        }
        
        /// aFormats (variable): A CountFormats length array of graphics formats, specified by EmrFormat objects (section 2.2.4) in order of preference.
        var aFormats: [EmrFormat] = []
        aFormats.reserveCapacity(Int(self.countFormats))
        for _ in 0..<self.countFormats {
            aFormats.append(try EmrFormat(dataStream: &dataStream))
        }
        
        self.aFormats = aFormats
        
        /// FormatData (variable): The image data for all graphics formats contained in this record.
        var formatData: [[UInt8]] = []
        formatData.reserveCapacity(Int(self.countFormats))
        for format in self.aFormats {
            guard 12 + format.offData >= 40 + self.countFormats * 16 &&
                    format.offData + format.sizeData <= size else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position = startPosition + 12 + Int(format.offData)
            formatData.append(try dataStream.readBytes(count: Int(format.sizeData)))
        }
        
        self.formatData = formatData
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
