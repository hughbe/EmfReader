//
//  ColorMatchToTarget.swift
//  
//
//  Created by Hugh Bellamy on 09/12/2020.
//

/// [MS-EMF] 2.1.6 ColorMatchToTarget Enumeration
/// The ColorMatchToTarget enumeration is used to determine whether a color profile has been embedded in the metafile.
/// typedef enum
/// {
///  COLORMATCHTOTARGET_NOTEMBEDDED = 0x00000000,
///  COLORMATCHTOTARGET_EMBEDDED = 0x00000001
/// } ColorMatchToTarget;
public enum ColorMatchToTarget: UInt32, DataStreamCreatable {
    /// COLORMATCHTOTARGET_NOTEMBEDDED: Indicates that a color profile has not been embedded in the metafile.
    case notEmbedded = 0x00000000
    
    /// COLORMATCHTOTARGET_EMBEDDED: Indicates that a color profile has been embedded in the metafile.
    case embedded = 0x00000001
}
