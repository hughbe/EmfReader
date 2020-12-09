//
//  EMR_COMMENT_PUBLIC_UNKNOWN.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.3.4 EMR_COMMENT_PUBLIC Record Types
/// The EMR_COMMENT_PUBLIC record types specify extensions to EMF processing.
/// Following are the EMF public comment record types that have been defined.
/// Name Section Description
/// EMR_COMMENT_BEGINGROUP 2.3.3.4.1 Specifies the beginning of a group of drawing records.
/// EMR_COMMENT_ENDGROUP 2.3.3.4.2 Specifies the end of a group of drawing records.
/// EMR_COMMENT_MULTIFORMATS 2.3.3.4.3 Specifies an image in multiple graphics formats.
/// EMR_COMMENT_WINDOW_METAFILE 2.3.3.4.4 Specifies an image in an embedded WMF metafile.
/// The generic structure of EMR_COMMENT_PUBLIC records is specified as follows.
/// Fields not specified in this section are specified in section 2.3.3.
/// See section 2.3.3 for more comment record types.
public struct EMR_COMMENT_PUBLIC_UNKNOWN {
    public let type: RecordType
    public let size: UInt32
    public let dataSize: UInt32
    public let commentIdentifier: UInt32
    public let publicCommentIdentifier: UInt32
    public let publicCommentRecordParm: [UInt8]
    
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
        guard size >= 16 else {
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
        
        /// CommentIdentifier (4 bytes): An unsigned integer that identifies this comment record as specifying public data.
        /// The value 0x43494447, which is the ASCII string "CIDG", identifies this as an EMR_COMMENT_PUBLIC record.
        self.commentIdentifier = try dataStream.read(endianess: .littleEndian)
        guard self.commentIdentifier == 0x43494447 else {
            throw EmfReadError.corrupted
        }
        
        /// PublicCommentIdentifier (4 bytes): An unsigned integer that identifies the type of public comment record. This
        /// SHOULD be one of the values listed in the preceding table, which are specified in the EmrComment enumeration
        /// (section 2.1.10), unless additional public comment record types have been implemented on the print server.
        self.publicCommentIdentifier = try dataStream.read(endianess: .littleEndian)
        
        /// PublicCommentRecordParm (variable): An array of bytes that contains the parameters for the public comment record.
        self.publicCommentRecordParm = try dataStream.readBytes(count: Int(self.dataSize) - 8)
        
        /// AlignmentPadding (variable, optional): An array of up to 3 bytes that pads the record so that its total size is a multiple of
        /// 4 bytes. This field MUST be ignored.
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
