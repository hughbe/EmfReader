//
//  XHeight.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.35 XHeight Enumeration
/// The XHeight enumeration defines values for one of the characteristics in the PANOSE system for classifying typefaces.
/// typedef enum
/// {
///  PAN_ANY = 0x00,
///  PAN_NO_FIT = 0x01,
///  PAN_XHEIGHT_CONSTANT_SMALL = 0x02,
///  PAN_XHEIGHT_CONSTANT_STD = 0x03,
///  PAN_XHEIGHT_CONSTANT_LARGE = 0x04,
///  PAN_XHEIGHT_DUCKING_SMALL = 0x05,
///  PAN_XHEIGHT_DUCKING_STD = 0x06,
///  PAN_XHEIGHT_DUCKING_LARGE = 0x07
/// } XHeight;
public enum XHeight: UInt8, DataStreamCreatable {
    /// PAN_ANY: Any.
    case any = 0x00
    
    /// PAN_NO_FIT: No fit.
    case noFit = 0x01
    
    /// PAN_XHEIGHT_CONSTANT_SMALL: Constant/small.
    case constantSmall = 0x02
    
    /// PAN_XHEIGHT_CONSTANT_STD: Constant/standard.
    case constantStd = 0x03
    
    /// PAN_XHEIGHT_CONSTANT_LARGE: Constant/large.
    case constantLarge = 0x04
    
    /// PAN_XHEIGHT_DUCKING_SMALL: Ducking/small
    case duckingSmall = 0x05
    
    /// PAN_XHEIGHT_DUCKING_STD: Ducking/standard.
    case duckingStd = 0x06
    
    /// PAN_XHEIGHT_DUCKING_LARGE: Ducking/large.
    case duckingLarge = 0x07
}
