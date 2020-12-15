//
//  EMR_COMMENT_PUBLIC.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.3.4 EMR_COMMENT_PUBLIC Record Types
/// The EMR_COMMENT_PUBLIC record types specify extensions to EMF processing.
/// Following are the EMF public comment record types that have been defined.
/// The generic structure of EMR_COMMENT_PUBLIC records is specified as follows.
/// Fields not specified in this section are specified in section 2.3.3.
/// See section 2.3.3 for more comment record types.
public enum EMR_COMMENT_PUBLIC {
    /// EMR_COMMENT_BEGINGROUP 2.3.3.4.1 Specifies the beginning of a group of drawing records.
    case beginGroup(_: EMR_COMMENT_BEGINGROUP)
    
    /// EMR_COMMENT_ENDGROUP 2.3.3.4.2 Specifies the end of a group of drawing records.
    case endGroup(_: EMR_COMMENT_ENDGROUP)
    
    /// EMR_COMMENT_MULTIFORMATS 2.3.3.4.3 Specifies an image in multiple graphics formats.
    case multiformats(_: EMR_COMMENT_MULTIFORMATS)
    
    /// EMR_COMMENT_WINDOW_METAFILE 2.3.3.4.4 Specifies an image in an embedded WMF metafile.
    case windowsMetafile(_: EMR_COMMENT_WINDOWS_METAFILE)

    case unknown(_: EMR_COMMENT_PUBLIC_UNKNOWN)
    
    public init(dataStream: inout DataStream) throws {
        let position = dataStream.position
        
        /// Type (4 bytes): An unsigned integer from the RecordType enumeration (section 2.1.1) that identifies this record as a
        /// comment record. This value is 0x00000046.
        let type = try RecordType(dataStream: &dataStream)
        guard type == RecordType.EMR_COMMENT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes) The value of the Size field can be used to distinguish between the different EMR_HEADER record types.
        /// See the flowchart in section 2.3.4.2 for details.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000014 else {
            throw EmfReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the size in bytes, of the CommentIdentifier and CommentRecordParm
        /// fields in the RecordBuffer field that follows. It MUST NOT include the size of itself or the size of the AlignmentPadding field,
        /// if present.
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 8 &&
                dataSize < 0xFFFFFFF0 &&
                0x0000000C + dataSize <= size else {
            throw EmfReadError.corrupted
        }
        
        /// CommentIdentifier (4 bytes): An unsigned integer that identifies this comment record as specifying public data.
        /// The value 0x43494447, which is the ASCII string "CIDG", identifies this as an EMR_COMMENT_PUBLIC record.
        let commentIdentifier: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard commentIdentifier == 0x43494447 else {
            throw EmfReadError.corrupted
        }
        
        /// PublicCommentIdentifier (4 bytes): An unsigned integer that identifies the type of public comment record. This
        /// SHOULD be one of the values listed in the preceding table, which are specified in the EmrComment enumeration
        /// (section 2.1.10), unless additional public comment record types have been implemented on the print server.
        let publicCommentIdentifier: UInt32 = try dataStream.read(endianess: .littleEndian)
        
        dataStream.position = position
        switch publicCommentIdentifier {
        case EmrComment.EMR_COMMENT_BEGINGROUP.rawValue:
            self = .beginGroup(try EMR_COMMENT_BEGINGROUP(dataStream: &dataStream))
        case EmrComment.EMR_COMMENT_ENDGROUP.rawValue:
            self = .endGroup(try EMR_COMMENT_ENDGROUP(dataStream: &dataStream))
        case EmrComment.EMR_COMMENT_MULTIFORMATS.rawValue:
            self = .multiformats(try EMR_COMMENT_MULTIFORMATS(dataStream: &dataStream))
        case EmrComment.EMR_COMMENT_WINDOWS_METAFILE.rawValue:
            self = .windowsMetafile(try EMR_COMMENT_WINDOWS_METAFILE(dataStream: &dataStream))
        default:
            self = .unknown(try EMR_COMMENT_PUBLIC_UNKNOWN(dataStream: &dataStream))
        }
        
        guard dataStream.position - position == size else {
            throw EmfReadError.corrupted
        }
    }
}
