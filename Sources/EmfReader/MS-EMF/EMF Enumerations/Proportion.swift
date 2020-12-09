//
//  Proportion.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.28 Proportion Enumeration
/// The Proportion enumeration defines values for one of the characteristics in the PANOSE system for classifying typefaces.
/// typedef enum
/// {
///  PAN_ANY = 0x00,
///  PAN_NO_FIT = 0x01,
///  PAN_PROP_OLD_STYLE = 0x02,
///  PAN_PROP_MODERN = 0x03,
///  PAN_PROP_EVEN_WIDTH = 0x04,
///  PAN_PROP_EXPANDED = 0x05,
///  PAN_PROP_CONDENSED = 0x06,
///  PAN_PROP_VERY_EXPANDED = 0x07,
///  PAN_PROP_VERY_CONDENSED = 0x08,
///  PAN_PROP_MONOSPACED = 0x09
/// } Proportion;
public enum Proportion: UInt8, DataStreamCreatable {
    /// PAN_ANY: Any.
    case any = 0x00
    
    /// PAN_NO_FIT: No fit.
    case noFit = 0x01
    
    /// PAN_PROP_OLD_STYLE: Old style.
    case oldStyle = 0x02
    
    /// PAN_PROP_MODERN: Modern.
    case modern = 0x03
    
    /// PAN_PROP_EVEN_WIDTH: Even width.
    case evenWidth = 0x04
    
    /// PAN_PROP_EXPANDED: Expanded.
    case expanded = 0x05
    
    /// PAN_PROP_CONDENSED: Condensed.
    case condensed = 0x06
    
    /// PAN_PROP_VERY_EXPANDED: Very expanded.
    case veryExpanded = 0x07
    
    /// PAN_PROP_VERY_CONDENSED: Very condensed.
    case veryCondensed = 0x08
    
    /// PAN_PROP_MONOSPACED: Monospaced.
    case monospaced = 0x09
}
