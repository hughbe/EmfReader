//
//  FormatSignature.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

/// [MS-WMF] 2.1.14 FormatSignature Enumeration
/// The FormatSignature enumeration defines values that are used to identify the format of embedded data in EMF metafiles.
/// typedef enum
/// {
///  ENHMETA_SIGNATURE = 0x464D4520,
///  EPS_SIGNATURE = 0x46535045
/// } FormatSignature;
public enum FormatSignature: UInt32, DataStreamCreatable {
    /// ENHMETA_SIGNATURE: The sequence of ASCII characters "FME ", which denotes EMF data. The reverse of the string is " EMF".
    /// Note: The space character in the string is significant and MUST be present.
    /// This signature is used in the following structures:
    ///  EMR_HEADER records (section 2.3.4.2) to identify the EMF metafile
    ///  The EmrFormat object (section 2.2.4) in EMR_COMMENT_MULTIFORMATS records (section 2.3.3.4.3), to specify embedded
    /// EMF records.
    case ENHMETA_SIGNATURE = 0x464D4520
    
    /// EPS_SIGNATURE: The value of this member is the sequence of ASCII characters "FSPE", which denotes encapsulated PostScript
    /// (EPS) data. The reverse of the string is "EPSF".
    /// This signature is used in EmrFormat objects to specify embedded PostScript data in the EpsData object (section 2.2.6) in
    /// EMR_COMMENT_MULTIFORMATS records.
    case EPS_SIGNATURE = 0x46535045
}
