//
//  EMR_COMMENT_BEGINGROUP.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.3.4.1 EMR_COMMENT_BEGINGROUP Record
/// The EMR_COMMENT_BEGINGROUP record specifies the beginning of a group of drawing records.
/// Fields not specified in this section are specified in section 2.3.3 or 2.3.3.4.
/// This record MUST be followed by a corresponding EMR_COMMENT_ENDGROUP record (section 2.3.3.4.2). These record groups
/// can be nested.
/// See section 2.3.3.4 for more public comment record types.
public struct EMR_COMMENT_BEGINGROUP {
    public let type: RecordType
    public let size: UInt32
    public let dataSize: UInt32
    public let commentIdentifier: UInt32
    public let publicCommentIdentifier: EmrComment
    public let rectangle: RectL
    public let nDescription: UInt32
    public let description: String
    
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
        guard size >= 0x00000028 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the size in bytes, of the CommentIdentifier and CommentRecordParm
        /// fields in the RecordBuffer field that follows. It MUST NOT include the size of itself or the size of the AlignmentPadding field,
        /// if present.
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 0x0000001C &&
                dataSize < 0xFFFFFFF0 &&
                0x0000000C + dataSize <= size else {
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
        /// EMR_COMMENT_BEGINGROUP from the EmrComment enumeration (section 2.1.10). This value is 0x00000002.
        self.publicCommentIdentifier = try EmrComment(dataStream: &dataStream)
        guard self.publicCommentIdentifier == EmrComment.EMR_COMMENT_BEGINGROUP else {
            throw EmfReadError.corrupted
        }
        
        /// Rectangle (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the output rectangle in logical coordinates.
        self.rectangle = try RectL(dataStream: &dataStream)
        
        /// nDescription (4 bytes): The number of Unicode characters in the optional description string that follows.
        self.nDescription = try dataStream.read(endianess: .littleEndian)
        guard 0x00000028 + self.nDescription * 2 <= self.size else {
            throw EmfReadError.corrupted
        }
        
        /// Description (variable, optional): A null-terminated Unicode string that describes this group of records.
        self.description = try dataStream.readString(count: Int(self.nDescription) * 2, encoding: .utf16LittleEndian)!
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
