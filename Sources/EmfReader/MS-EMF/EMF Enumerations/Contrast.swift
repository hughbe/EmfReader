//
//  File.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.8 Contrast Enumeration
/// The Contrast enumeration defines values for one of the characteristics in the PANOSE system for classifying typefaces.
/// typedef enum
/// {
///  PAN_ANY = 0x00,
///  PAN_NO_FIT = 0x01,
///  PAN_CONTRAST_NONE = 0x02,
///  PAN_CONTRAST_VERY_LOW = 0x03,
///  PAN_CONTRAST_LOW = 0x04,
///  PAN_CONTRAST_MEDIUM_LOW = 0x05,
///  PAN_CONTRAST_MEDIUM = 0x06,
///  PAN_CONTRAST_MEDIUM_HIGH = 0x07,
///  PAN_CONTRAST_HIGH = 0x08,
///  PAN_CONTRAST_VERY_HIGH = 0x09
/// } Contrast;
public enum Contrast: UInt8, DataStreamCreatable {
    /// PAN_ANY: Any.
    case any = 0x00
    
    /// PAN_NO_FIT: No fit.
    case noFit = 0x01
    
    /// PAN_CONTRAST_NONE: None.
    case none = 0x02
    
    /// PAN_CONTRAST_VERY_LOW: Very low.
    case veryLow = 0x03
    
    /// PAN_CONTRAST_LOW: Low.
    case low = 0x04
    
    /// PAN_CONTRAST_MEDIUM_LOW: Medium low.
    case mediumLow = 0x05
    
    /// PAN_CONTRAST_MEDIUM: Medium.
    case medum = 0x06
    
    /// PAN_CONTRAST_MEDIUM_HIGH: Medium high.
    case mediumHigh = 0x07
    
    /// PAN_CONTRAST_HIGH: High.
    case high = 0x08
    
    /// PAN_CONTRAST_VERY_HIGH: Very high.
    case veryHigh = 0x09
    
}
