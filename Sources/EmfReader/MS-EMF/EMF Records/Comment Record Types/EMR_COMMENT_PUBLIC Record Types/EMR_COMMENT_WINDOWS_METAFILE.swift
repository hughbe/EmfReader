//
//  EMR_COMMENT_WINDOWS_METAFILE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.3.4.4 EMR_COMMENT_WINDOWS_METAFILE Record
/// The EMR_COMMENT_WINDOWS_METAFILE record specifies an image in an embedded WMF metafile.
/// Fields not specified in this section are specified in section 2.3.3 or 2.3.3.4.
/// See section 2.3.3.4 for more public comment record types.
public struct EMR_COMMENT_WINDOWS_METAFILE {
    public let type: RecordType
    public let size: UInt32
    public let dataSize: UInt32
    public let commentIdentifier: UInt32
    public let publicCommentIdentifier: EmrComment
    public let version: MetafileVersion
    public let reserved: UInt16
    public let checksum: UInt32
    public let flags: UInt32
    public let winMetafileSize: UInt32
    public let winMetafile: [UInt8]
    
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
        guard size >= 0x00000018 && size % 4 == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the size in bytes, of the CommentIdentifier and CommentRecordParm
        /// fields in the RecordBuffer field that follows. It MUST NOT include the size of itself or the size of the AlignmentPadding field,
        /// if present.
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 0x00000018 &&
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
        /// EMR_COMMENT_WINDOWS_METAFILE from the EmrComment enumeration (section 2.1.10). This value is 0x80000001.
        self.publicCommentIdentifier = try EmrComment(dataStream: &dataStream)
        guard self.publicCommentIdentifier == EmrComment.EMR_COMMENT_WINDOWS_METAFILE else {
            throw EmfReadError.corrupted
        }
        
        /// Version (2 bytes): An unsigned integer that specifies the WMF metafile version in terms of support for DIBs, from the
        /// MetafileVersion enumeration ([MS-WMF] section 2.1.1.19).
        guard let version = MetafileVersion(rawValue: try dataStream.read(endianess: .littleEndian)) else {
            throw EmfReadError.corrupted
        }
        
        self.version = version
        
        /// Reserved (2 bytes): A value that MUST be 0x0000 and MUST be ignored.
        self.reserved = try dataStream.read(endianess: .littleEndian)
        
        /// Checksum (4 bytes): An unsigned integer that specifies the checksum for this record.
        self.checksum = try dataStream.read(endianess: .littleEndian)
        
        /// Flags (4 bytes): A value that MUST be 0x00000000 and MUST be ignored.
        self.flags = try dataStream.read(endianess: .littleEndian)
        
        /// WinMetafileSize (4 bytes): An unsigned integer that specifies the size in bytes, of the WinMetafilefield.
        self.winMetafileSize = try dataStream.read(endianess: .littleEndian)
        guard 0x00000024 + self.winMetafileSize <= size else {
            throw EmfReadError.corrupted
        }
        
        /// WinMetafile (variable): A buffer that contains the WMF metafile.
        self.winMetafile = try dataStream.readBytes(count: Int(self.winMetafileSize))
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
