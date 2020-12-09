//
//  ArmStyle.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.3 ArmStyle Enumeration
/// The ArmStyle enumeration defines values for one of the characteristics in the PANOSE system for classifying typefaces.
/// typedef enum
/// {
///  PAN_ANY = 0x00,
///  PAN_NO_FIT = 0x01,
///  PAN_STRAIGHT_ARMS_HORZ = 0x02,
///  PAN_STRAIGHT_ARMS_WEDGE = 0x03,
///  PAN_STRAIGHT_ARMS_VERT = 0x04,
///  PAN_STRAIGHT_ARMS_SINGLE_SERIF = 0x05,
///  PAN_STRAIGHT_ARMS_DOUBLE_SERIF = 0x06,
///  PAN_BENT_ARMS_HORZ = 0x07,
///  PAN_BENT_ARMS_WEDGE = 0x08,
///  PAN_BENT_ARMS_VERT = 0x09,
///  PAN_BENT_ARMS_SINGLE_SERIF = 0x0A,
///  PAN_BENT_ARMS_DOUBLE_SERIF = 0x0B
/// } ArmStyle;
public enum ArmStyle: UInt8, DataStreamCreatable {
    /// PAN_ANY: Any.
    case any = 0x00
    
    /// PAN_NO_FIT: No fit.
    case noFit = 0x01
    
    /// PAN_STRAIGHT_ARMS_HORZ: Straight arms/horizontal.
    case straightArmsHorz = 0x02
    
    /// PAN_STRAIGHT_ARMS_WEDGE: Straight arms/wedge.
    case straightArmsWedge = 0x03
    
    /// PAN_STRAIGHT_ARMS_VERT: Straight arms/vertical.
    case straightArmsVert = 0x04
    
    /// PAN_STRAIGHT_ARMS_SINGLE_SERIF: Straight arms/single-serif.
    case straightArmsSingleSerif = 0x05
    
    /// PAN_STRAIGHT_ARMS_DOUBLE_SERIF: Straight arms/double-serif.
    case straightArmsDoubleSerif = 0x06
    
    /// PAN_BENT_ARMS_HORZ: Nonstraight arms/horizontal.
    case bentArmsHorz = 0x07
    
    /// PAN_BENT_ARMS_WEDGE: Nonstraight arms/wedge.
    case bentArmsWedge = 0x08
    
    /// PAN_BENT_ARMS_VERT: Nonstraight arms/vertical.
    case bentArmsVert = 0x09
    
    /// PAN_BENT_ARMS_SINGLE_SERIF: Nonstraight arms/single-serif.
    case bentArmsSingleSerif = 0x0A
    
    /// PAN_BENT_ARMS_DOUBLE_SERIF: Nonstraight arms/double-serif.
    case bentArmsDoubleSerif = 0x0B
}
