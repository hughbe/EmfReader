//
//  EMR_COMMENT_EMFSPOOL.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.3.3 EMR_COMMENT_EMFSPOOL Record
/// The EMR_COMMENT_EMFSPOOL record contains embedded EMFSPOOL records ([MS-EMFSPOOL] section 2.2).
/// Fields not specified in this section are specified in section 2.3.3.
/// See section 2.3.3 for more comment record types.
public struct EMR_COMMENT_EMFSPOOL {
    public let type: RecordType
    public let size: UInt32
    public let dataSize: UInt32
    public let commentIdentifier: UInt32
    public let emfSpoolRecordIdentifier: UInt32
    public let emfSpoolRecords: [UInt8]
    
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
        guard size >= 12 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the size in bytes, of the CommentIdentifier and CommentRecordParm
        /// fields in the RecordBuffer field that follows. It MUST NOT include the size of itself or the size of the AlignmentPadding field,
        /// if present.
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 8 && dataSize <= size - 8 else {
            throw EmfReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        /// CommentIdentifier (4 bytes): An unsigned integer that identifies this comment record as containing EMFSPOOL records.
        /// The value 0x00000000 identifies this as an EMR_COMMENT_EMFSPOOL record.
        self.commentIdentifier = try dataStream.read(endianess: .littleEndian)
        guard self.commentIdentifier == 0x00000000 else {
            throw EmfReadError.corrupted
        }
        
        /// EMFSpoolRecordIdentifier (4 bytes): An unsigned integer that identifies the type of EMR_COMMENT_EMFSPOOL record.
        /// The value 0x544F4E46, which is the ASCII string "TONE", identifies this as an EMFSPOOL font definition record
        /// ([MS-EMFSPOOL] section 2.2.3.3).
        self.emfSpoolRecordIdentifier = try dataStream.read(endianess: .littleEndian)
        
        /// EMFSpoolRecords (variable): An array of bytes that contain one or more font definition records.
        self.emfSpoolRecords = try dataStream.readBytes(count: Int(self.dataSize) - 8)
        
        /// AlignmentPadding (variable, optional): An array of up to 3 bytes that pads the record so that its total size is a multiple of
        /// 4 bytes. This field MUST be ignored.
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
