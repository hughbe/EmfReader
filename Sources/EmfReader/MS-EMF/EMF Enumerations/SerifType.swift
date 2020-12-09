//
//  SerifType.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.30 SerifType Enumeration
/// The SerifType enumeration defines values for one of the characteristics in the PANOSE system for classifying typefaces.
/// typedef enum
/// {
///  PAN_ANY = 0x00,
///  PAN_NO_FIT = 0x01,
///  PAN_SERIF_COVE = 0x02,
///  PAN_SERIF_OBTUSE_COVE = 0x03,
///  PAN_SERIF_SQUARE_COVE = 0x04,
///  PAN_SERIF_OBTUSE_SQUARE_COVE = 0x05,
///  PAN_SERIF_SQUARE = 0x06,
///  PAN_SERIF_THIN = 0x07,
///  PAN_SERIF_BONE = 0x08,
///  PAN_SERIF_EXAGGERATED = 0x09,
///  PAN_SERIF_TRIANGLE = 0x0A,
///  PAN_SERIF_NORMAL_SANS = 0x0B,
///  PAN_SERIF_OBTUSE_SANS = 0x0C,
///  PAN_SERIF_PERP_SANS = 0x0D,
///  PAN_SERIF_FLARED = 0x0E,
///  PAN_SERIF_ROUNDED = 0x0F
/// } SerifType;
public enum SerifType: UInt8, DataStreamCreatable {
    /// PAN_ANY: Any.
    case any = 0x00
    
    /// PAN_NO_FIT: No fit.
    case noFit = 0x01
    
    /// PAN_SERIF_COVE: Cove.
    case cove = 0x02
    
    /// PAN_SERIF_OBTUSE_COVE: Obtuse cove.
    case obtuseCove = 0x03
    
    /// PAN_SERIF_SQUARE_COVE: Square cove.
    case squareCove = 0x04
    
    /// PAN_SERIF_OBTUSE_SQUARE_COVE: Obtuse square cove.
    case obtuseSquareCove = 0x05
    
    /// PAN_SERIF_SQUARE: Square.
    case square = 0x06
    
    /// PAN_SERIF_THIN: Thin.
    case thin = 0x07
    
    /// PAN_SERIF_BONE: Bone.
    case bone = 0x08
    
    /// PAN_SERIF_EXAGGERATED: Exaggerated.
    case exaggerated = 0x09
    
    /// PAN_SERIF_TRIANGLE: Triangle.
    case triangle = 0x0A
    
    /// PAN_SERIF_NORMAL_SANS: Normal sans.
    case normalSans = 0x0B
    
    /// PAN_SERIF_OBTUSE_SANS: Obtuse sans.
    case obtuseSans = 0x0C
    
    /// PAN_SERIF_PERP_SANS: Perp sans.
    case perpSans = 0x0D
    
    /// PAN_SERIF_FLARED: Flared.
    case flared = 0x0E
    
    /// PAN_SERIF_ROUNDED: Rounded.
    case rounded = 0x0F
}
