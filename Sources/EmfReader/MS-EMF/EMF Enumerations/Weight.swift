//
//  Weight.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.34Weight Enumeration
/// The Weight enumeration defines values for one of the characteristics in the PANOSE system for classifying typefaces.
/// typedef enum
/// {
///  PAN_ANY = 0x00,
///  PAN_NO_FIT = 0x01,
///  PAN_WEIGHT_VERY_LIGHT = 0x02,
///  PAN_WEIGHT_LIGHT = 0x03,
///  PAN_WEIGHT_THIN = 0x04,
///  PAN_WEIGHT_BOOK = 0x05,
///  PAN_WEIGHT_MEDIUM = 0x06,
///  PAN_WEIGHT_DEMI = 0x07,
///  PAN_WEIGHT_BOLD = 0x08,
///  PAN_WEIGHT_HEAVY = 0x09,
///  PAN_WEIGHT_BLACK = 0x0A,
///  PAN_WEIGHT_NORD = 0x0B
/// } Weight;
public enum Weight: UInt8, DataStreamCreatable {
    /// PAN_ANY: Any.
    case any = 0x00
    
    /// PAN_NO_FIT: No fit.
    case noFit = 0x01
    
    /// PAN_WEIGHT_VERY_LIGHT: Very light.
    case veryLight = 0x02
    
    /// PAN_WEIGHT_LIGHT: Light.
    case light = 0x03
    
    /// PAN_WEIGHT_THIN: Thin.
    case thin = 0x04
    
    /// PAN_WEIGHT_BOOK: Book.
    case book = 0x05
    
    /// PAN_WEIGHT_MEDIUM: Medium.
    case medium = 0x06
    
    /// PAN_WEIGHT_DEMI: Demi.
    case demi = 0x07
    
    /// PAN_WEIGHT_BOLD: Bold.
    case bold = 0x08
    
    /// PAN_WEIGHT_HEAVY: Heavy.
    case heavy = 0x09
    
    /// PAN_WEIGHT_BLACK: Black.
    case black = 0x0A
    
    /// PAN_WEIGHT_NORD: Nord.
    case nord = 0x0B
}
