//
//  Letterform.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.20 Letterform Enumeration
/// The Letterform enumeration defines values for one of the characteristics in the PANOSE system for classifying typefaces.
/// typedef enum
/// {
///  PAN_ANY = 0x00,
///  PAN_NO_FIT = 0x01,
///  PAN_LETT_NORMAL_CONTACT = 0x02,
///  PAN_LETT_NORMAL_WEIGHTED = 0x03,
///  PAN_LETT_NORMAL_BOXED = 0x04,
///  PAN_LETT_NORMAL_FLATTENED = 0x05,
///  PAN_LETT_NORMAL_ROUNDED = 0x06,
///  PAN_LETT_NORMAL_OFF_CENTER = 0x07,
///  PAN_LETT_NORMAL_SQUARE = 0x08,
///  PAN_LETT_OBLIQUE_CONTACT = 0x09,
///  PAN_LETT_OBLIQUE_WEIGHTED = 0x0A,
///  PAN_LETT_OBLIQUE_BOXED = 0x0B,
///  PAN_LETT_OBLIQUE_FLATTENED = 0x0C,
///  PAN_LETT_OBLIQUE_ROUNDED = 0x0D,
///  PAN_LETT_OBLIQUE_OFF_CENTER = 0x0E,
///  PAN_LETT_OBLIQUE_SQUARE = 0x0F
/// } Letterform;
public enum Letterform: UInt8, DataStreamCreatable {
    /// PAN_ANY: Any.
    case any = 0x00
    
    /// PAN_NO_FIT: No fit.
    case noFit = 0x01
    
    /// PAN_LETT_NORMAL_CONTACT: Normal/contact.
    case normalContact = 0x02
    
    /// PAN_LETT_NORMAL_WEIGHTED: Normal/weighted.
    case normalWeighted = 0x03
    
    /// PAN_LETT_NORMAL_BOXED: Normal/boxed.
    case normalBoxed = 0x04
    
    /// PAN_LETT_NORMAL_FLATTENED: Normal/flattened.
    case normalFlattened = 0x05
    
    /// PAN_LETT_NORMAL_ROUNDED: Normal/rounded.
    case normalRounded = 0x06
    
    /// PAN_LETT_NORMAL_OFF_CENTER: Normal/off center.
    case normalOffCenter = 0x07
    
    /// PAN_LETT_NORMAL_SQUARE: Normal/square
    case normalSquare = 0x08
    
    /// PAN_LETT_OBLIQUE_CONTACT: Oblique/contact.
    case obliqueContact = 0x09
    
    /// PAN_LETT_OBLIQUE_WEIGHTED: Oblique/weighted.
    case obliqueWeighted = 0x0A
    
    /// PAN_LETT_OBLIQUE_BOXED: Oblique/boxed.
    case obliqueBoxed = 0x0B
    
    /// PAN_LETT_OBLIQUE_FLATTENED: Oblique/flattened.
    case obliqueFlattened = 0x0C
    
    /// PAN_LETT_OBLIQUE_ROUNDED: Oblique/rounded.
    case obliqueRounded = 0x0D
    
    /// PAN_LETT_OBLIQUE_OFF_CENTER: Oblique/off center.
    case obliqueOffCenter = 0x0E
    
    /// PAN_LETT_OBLIQUE_SQUARE: Oblique/square.
    case obliqueSquare = 0x0F
    
}
