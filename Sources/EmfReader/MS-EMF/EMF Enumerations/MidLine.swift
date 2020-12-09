//
//  MidLine.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.23 MidLine Enumeration
/// The MidLine enumeration defines values for one of the characteristics in the PANOSE system for classifying typefaces.
/// typedef enum
/// {
///  PAN_ANY = 0x00,
///  PAN_NO_FIT = 0x01,
///  PAN_MIDLINE_STANDARD_TRIMMED = 0x02,
///  PAN_MIDLINE_STANDARD_POINTED = 0x03,
///  PAN_MIDLINE_STANDARD_SERIFED = 0x04,
///  PAN_MIDLINE_HIGH_TRIMMED = 0x05,
///  PAN_MIDLINE_HIGH_POINTED = 0x06,
///  PAN_MIDLINE_HIGH_SERIFED = 0x07,
///  PAN_MIDLINE_CONSTANT_TRIMMED = 0x08,
///  PAN_MIDLINE_CONSTANT_POINTED = 0x09,
///  PAN_MIDLINE_CONSTANT_SERIFED = 0x0A,
///  PAN_MIDLINE_LOW_TRIMMED = 0x0B,
///  PAN_MIDLINE_LOW_POINTED = 0x0C,
///  PAN_MIDLINE_LOW_SERIFED = 0x0D
/// } MidLine;
public enum MidLine: UInt8, DataStreamCreatable {
    /// PAN_ANY: Any.
    case any = 0x00
    
    /// PAN_NO_FIT: No fit.
    case noFit = 0x01
    
    /// PAN_MIDLINE_STANDARD_TRIMMED: Standard/trimmed.
    case standardTrimmed = 0x02
    
    /// PAN_MIDLINE_STANDARD_POINTED: Standard/pointed.
    case standardPointed = 0x03
    
    /// PAN_MIDLINE_STANDARD_SERIFED: Standard/serifed.
    case standardSerifed = 0x04
    
    /// PAN_MIDLINE_HIGH_TRIMMED: High/trimmed.
    case highTrimmed = 0x05
    
    /// PAN_MIDLINE_HIGH_POINTED: High/pointed.
    case highPointed = 0x06
    
    /// PAN_MIDLINE_HIGH_SERIFED: High/serifed.
    case highSerifed = 0x07
    
    /// PAN_MIDLINE_CONSTANT_TRIMMED: Constant/trimmed.
    case constantTrimmed = 0x08
    
    /// PAN_MIDLINE_CONSTANT_POINTED: Constant/pointed.
    case constantPointed = 0x09
    
    /// PAN_MIDLINE_CONSTANT_SERIFED: Constant/serifed.
    case constantSerifed = 0x0A
    
    /// PAN_MIDLINE_LOW_TRIMMED: Low/trimmed.
    case lowTrimmed = 0x0B
    
    /// PAN_MIDLINE_LOW_POINTED: Low/pointed.
    case lowPointed = 0x0C
    
    /// PAN_MIDLINE_LOW_SERIFED: Low/serifed.
    case lowSerifed = 0x0D
}
