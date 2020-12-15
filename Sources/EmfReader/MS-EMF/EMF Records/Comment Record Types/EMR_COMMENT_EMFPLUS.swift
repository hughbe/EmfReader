//
//  EMR_COMMENT_EMFPLUS.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.3.2 EMR_COMMENT_EMFPLUS Record
/// The EMR_COMMENT_EMFPLUS record contains embedded EMF+ records ([MS-EMFPLUS] section 2.3).
/// Fields not specified in this section are specified in section 2.3.3.
/// See section 2.3.3 for more comment record types.
public struct EMR_COMMENT_EMFPLUS {
    public let type: RecordType
    public let size: UInt32
    public let dataSize: UInt32
    public let commentIdentifier: UInt32
    public let emfPlusRecords: [UInt8]
    
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
        guard size >= 0x00000010 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the size in bytes, of the CommentIdentifier and CommentRecordParm
        /// fields in the RecordBuffer field that follows. It MUST NOT include the size of itself or the size of the AlignmentPadding field,
        /// if present.
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize < 0xFFFFFFF0 &&
                dataSize >= 4 &&
                0x0000000C + dataSize <= size else {
            throw EmfReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        /// CommentIdentifier (4 bytes): An unsigned integer that identifies this comment record as containing EMF+ records.
        /// The value 0x2B464D45, which is the ASCII string "+FME", identifies this as an EMR_COMMENT_EMFPLUS record.
        self.commentIdentifier = try dataStream.read(endianess: .littleEndian)
        guard self.commentIdentifier == 0x2B464D45 else {
            throw EmfReadError.corrupted
        }
        
        /// EMFPlusRecords (variable): An array of bytes that contains one or more EMF+ records.
        self.emfPlusRecords = try dataStream.readBytes(count: Int(self.dataSize) - 4)
        
        /// AlignmentPadding (variable, optional): An array of up to 3 bytes that pads the record so that its total size is a multiple of
        /// 4 bytes. This field MUST be ignored.
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
