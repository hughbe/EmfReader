//
//  FamilyType.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.12 FamilyType Enumeration
/// The FamilyType enumeration defines values for one of the characteristics in the PANOSE system for classifying typefaces.
/// typedef enum
/// {
///  PAN_ANY = 0x00,
///  PAN_NO_FIT = 0x01,
///  PAN_FAMILY_TEXT_DISPLAY = 0x02,
///  PAN_FAMILY_SCRIPT = 0x03,
///  PAN_FAMILY_DECORATIVE = 0x04,
///  PAN_FAMILY_PICTORIAL = 0x05
/// } FamilyType;
public enum FamilyType: UInt8, DataStreamCreatable {
    /// PAN_ANY: Any.
    case any = 0x00
    
    /// PAN_NO_FIT: No fit.
    case noFit = 0x01
    
    /// PAN_FAMILY_TEXT_DISPLAY: Text and display.
    case familyTextDisplay = 0x02
    
    /// PAN_FAMILY_SCRIPT: Script.
    case familyScript = 0x03
    
    /// PAN_FAMILY_DECORATIVE: Decorative.
    case familyDecorative = 0x04

    /// PAN_FAMILY_PICTORIAL: Pictorial.
    case familyPictorial = 0x05
}
