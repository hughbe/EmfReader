//
//  EmrComment.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.10 EmrComment Enumeration
/// The EmrComment enumeration defines the types of data that a public comment record can contain, as specified in section 2.3.3.4.
/// typedef enum
/// {
///  EMR_COMMENT_WINDOWS_METAFILE = 0x80000001,
///  EMR_COMMENT_BEGINGROUP = 0x00000002,
///  EMR_COMMENT_ENDGROUP = 0x00000003,
///  EMR_COMMENT_MULTIFORMATS = 0x40000004,
///  EMR_COMMENT_UNICODE_STRING = 0x00000040,
///  EMR_COMMENT_UNICODE_END = 0x00000080
/// } EmrComment;
public enum EmrComment: UInt32, DataStreamCreatable {
    /// EMR_COMMENT_WINDOWS_METAFILE: This comment record contains a specification of an image in WMF [MS-WMF].
    case EMR_COMMENT_WINDOWS_METAFILE = 0x80000001
    
    /// EMR_COMMENT_BEGINGROUP: This comment record identifies the beginning of a group of drawing records.
    case EMR_COMMENT_BEGINGROUP = 0x00000002
    
    /// EMR_COMMENT_ENDGROUP: This comment record identifies the end of a group of drawing records.
    case EMR_COMMENT_ENDGROUP = 0x00000003
    
    /// EMR_COMMENT_MULTIFORMATS: This comment record allows multiple definitions of an image to be included in the metafile.
    /// Using this comment, for example, an application can include encapsulated PostScript text as well as an EMF definition of an
    /// image.
    case EMR_COMMENT_MULTIFORMATS = 0x40000004
    
    /// EMR_COMMENT_UNICODE_STRING: This comment record is reserved and MUST NOT be used.
    case EMR_COMMENT_UNICODE_STRING = 0x00000040
    
    /// EMR_COMMENT_UNICODE_END: This comment record is reserved and MUST NOT be used.
    case EMR_COMMENT_UNICODE_END = 0x00000080
}
