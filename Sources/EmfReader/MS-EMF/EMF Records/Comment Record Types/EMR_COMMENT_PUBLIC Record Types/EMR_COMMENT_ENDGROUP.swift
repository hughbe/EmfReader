//
//  EMR_COMMENT_ENDGROUP.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.3.4.2 EMR_COMMENT_ENDGROUP Record
/// The EMR_COMMENT_ENDGROUP record specifies the end of a group of drawing records.
/// Fields not specified in this section are specified in section 2.3.3 or 2.3.3.4.
/// This record MUST be preceded by a corresponding. EMR_COMMENT_BEGINGROUP (section 2.3.3.4.1).
/// These records can be nested.
/// See section 2.3.3.4 for more public comment record types.
public struct EMR_COMMENT_ENDGROUP {
    public let type: RecordType
    public let size: UInt32
    public let dataSize: UInt32
    public let commentIdentifier: UInt32
    public let publicCommentIdentifier: EmrComment

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
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000014 else {
            throw EmfReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the size in bytes, of the CommentIdentifier and CommentRecordParm
        /// fields in the RecordBuffer field that follows. It MUST NOT include the size of itself or the size of the AlignmentPadding field,
        /// if present.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == 0x00000008 else {
            throw EmfReadError.corrupted
        }
        
        /// CommentIdentifier (4 bytes): An unsigned integer that identifies this comment record as specifying public data.
        /// The value 0x43494447, which is the ASCII string "CIDG", identifies this as an EMR_COMMENT_PUBLIC record.
        self.commentIdentifier = try dataStream.read(endianess: .littleEndian)
        guard self.commentIdentifier == 0x43494447 else {
            throw EmfReadError.corrupted
        }
        
        /// PublicCommentIdentifier (4 bytes): An unsigned integer that identifies the type of public comment record as
        /// EMR_COMMENT_ENDGROUP from the EmrComment enumeration (section 2.1.10). This value is 0x00000003.
        self.publicCommentIdentifier = try EmrComment(dataStream: &dataStream)
        guard self.publicCommentIdentifier == EmrComment.EMR_COMMENT_ENDGROUP else {
            throw EmfReadError.corrupted
        }

        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
