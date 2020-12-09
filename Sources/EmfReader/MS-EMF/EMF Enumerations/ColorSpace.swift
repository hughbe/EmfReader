//
//  ColorSpace.swift
//  
//
//  Created by Hugh Bellamy on 09/12/2020.
//

/// [MS-EMF] 2.1.7 ColorSpace Enumeration
/// The ColorSpace enumeration is used to specify when to turn color proofing on and off, and when to delete transforms.
/// typedef enum
/// {
///  CS_ENABLE = 0x00000001,
///  CS_DISABLE = 0x00000002,
///  CS_DELETE_TRANSFORM = 0x00000003
/// } ColorSpace;
public enum ColorSpace: UInt32, DataStreamCreatable {
    /// CS_ENABLE: Maps colors to the target device's color gamut. This enables color proofing. All subsequent draw commands
    /// render colors as they would appear on the target device.
    case enable = 0x00000001
    
    /// CS_DISABLE: Disables color proofing.
    case disable = 0x00000002
    
    /// CS_DELETE_TRANSFORM: If color management is enabled for the target profile, disables it and deletes the current color
    /// transform.
    case deleteTransform = 0x00000003
}
