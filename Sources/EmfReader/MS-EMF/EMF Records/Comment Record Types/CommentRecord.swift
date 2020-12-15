//
//  CommentRecord.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.3 Comment Record Types
/// The Comment record types define formats for specifying arbitrary private data, embedding records in other metafile formats, and
/// adding new or special-purpose commands.
/// The following are EMF comment record types.
public enum CommentRecord {
    /// EMR_COMMENT 2.3.3.1 Contains arbitrary private data.
    case comment(_: EMR_COMMENT)
    
    /// EMR_COMMENT_EMFPLUS 2.3.3.2 Contains embedded EMF+ records ([MS-EMFPLUS] section 2.3).
    case commentEmfPlus(_: EMR_COMMENT_EMFPLUS)
    
    /// EMR_COMMENT_EMFSPOOL 2.3.3.3 Contains embedded EMFSPOOL records ([MS-EMFSPOOL] section 2.2).
    case commentEmfSpool(_: EMR_COMMENT_EMFSPOOL)
    
    /// EMR_COMMENT_PUBLIC 2.3.3.4 Specifies extensions to EMF processing.
    case commentPublic(_: EMR_COMMENT_PUBLIC)
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer from the RecordType enumeration (section 2.1.1) that identifies this record as a
        /// comment record. This value is 0x00000046.
        let type = try RecordType(dataStream: &dataStream)
        guard type == RecordType.EMR_COMMENT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes) The value of the Size field can be used to distinguish between the different EMR_HEADER record types.
        /// See the flowchart in section 2.3.4.2 for details.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the size in bytes, of the CommentIdentifier and CommentRecordParm
        /// fields in the RecordBuffer field that follows. It MUST NOT include the size of itself or the size of the AlignmentPadding field,
        /// if present.
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize < 0xFFFFFFF0 &&
                0x0000000C + dataSize <= size else {
            throw EmfReadError.corrupted
        }
                
        /// CommentIdentifier (4 bytes, optional): An unsigned integer that identifies the type of comment record. See the preceding
        /// table for descriptions of these record types.
        /// Valid comment identifier values are listed in the following table. If this field contains any other value, the comment record
        /// is processed as an EMR_COMMENT record.
        /// Name Value
        /// EMR_COMMENT_EMFSPOOL 0x00000000
        /// EMR_COMMENT_EMFPLUS 0x2B464D45
        /// EMR_COMMENT_PUBLIC 0x43494447
        if size >= 0x00000014 {
            let identifier: UInt32 = try dataStream.peek(endianess: .littleEndian)
            dataStream.position = startPosition
            if identifier == 0x00000000 {
                self = .commentEmfSpool(try EMR_COMMENT_EMFSPOOL(dataStream: &dataStream))
            } else if identifier == 0x2B464D45 {
                self = .commentEmfPlus(try EMR_COMMENT_EMFPLUS(dataStream: &dataStream))
            } else if identifier == 0x43494447 {
                self = .commentPublic(try EMR_COMMENT_PUBLIC(dataStream: &dataStream))
            } else {
                self = .comment(try EMR_COMMENT(dataStream: &dataStream))
            }
        } else {
            dataStream.position = startPosition
            self = .comment(try EMR_COMMENT(dataStream: &dataStream))
        }
        
        guard dataStream.position - startPosition == size else {
            throw EmfReadError.corrupted
        }
    }
}
