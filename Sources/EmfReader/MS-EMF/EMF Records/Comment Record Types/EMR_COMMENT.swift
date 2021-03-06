//
//  EMR_COMMENT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.3.1 EMR_COMMENT Record
/// The EMR_COMMENT record contains arbitrary private data.
/// Private data is unknown to EMF; it is meaningful only to applications that know the format of the data and how to use it.
/// EMR_COMMENT private data records MAY<60> be ignored.
/// Fields not specified in this section are specified in section 2.3.4.
public struct EMR_COMMENT {
    public let type: RecordType
    public let size: UInt32
    public let dataSize: UInt32
    public let privateData: [UInt8]
    
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
        guard size >= 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the size in bytes, of the CommentIdentifier and CommentRecordParm
        /// fields in the RecordBuffer field that follows. It MUST NOT include the size of itself or the size of the AlignmentPadding field,
        /// if present.
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize < 0xFFFFFFF0 &&
                0x0000000C + dataSize <= size else {
            throw EmfReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        /// PrivateData (variable, optional): An array of bytes that specifies the private data. The first 32-bit field of this data MUST
        /// NOT be one of the predefined comment identifier values specified in section 2.3.3.
        self.privateData = try dataStream.readBytes(count: Int(self.dataSize))
        
        /// AlignmentPadding (variable, optional): An array of up to 3 bytes that pads the record so that its total size is a multiple of
        /// 4 bytes. This field MUST be ignored.
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
