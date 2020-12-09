//
//  Illuminant.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

/// [MS-EMF] 2.1.19 Illuminant Enumeration
/// The Illuminant enumeration defines values that specify the illuminant value of an image, which determines the standard light source
/// under which the image is viewed so that the color can be adjusted appropriately.
/// typedef enum
/// {
///  ILLUMINANT_DEVICE_DEFAULT = 0x00,
///  ILLUMINANT_TUNGSTEN = 0x01,
///  ILLUMINANT_B = 0x02,
///  ILLUMINANT_DAYLIGHT = 0x03,
///  ILLUMINANT_D50 = 0x04,
///  ILLUMINANT_D55 = 0x05,
///  ILLUMINANT_D65 = 0x06,
///  ILLUMINANT_D75 = 0x07,
///  ILLUMINANT_FLUORESCENT = 0x08
/// } Illuminant;
public enum Illuminant: UInt16, DataStreamCreatable {
    /// ILLUMINANT_DEVICE_DEFAULT: Device's default. Standard used by output devices.
    case deviceDefault = 0x00
    
    /// ILLUMINANT_TUNGSTEN: Tungsten lamp.
    case tungsten = 0x01
    
    /// ILLUMINANT_B: Noon sunlight.
    case b = 0x02
    
    /// ILLUMINANT_DAYLIGHT: Daylight.
    case daylight = 0x03
    
    /// ILLUMINANT_D50: Normal print.
    case d50 = 0x04
    
    /// ILLUMINANT_D55: Bond paper print.
    case d55 = 0x05
    
    /// ILLUMINANT_D65: Standard daylight. Standard for CRTs and pictures.
    case d65 = 0x06
    
    /// ILLUMINANT_D75: Northern daylight.
    case d75 = 0x07
    
    /// ILLUMINANT_FLUORESCENT: Cool white lamp.
    case fluorescent = 0x08
}
