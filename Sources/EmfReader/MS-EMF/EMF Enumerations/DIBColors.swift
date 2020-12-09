//
//  DIBColors.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

/// [MS-EMF] 2.1.9 DIBColors Enumeration
/// The DIBColors enumeration defines how to interpret the values in the color table of a DIB.
/// typedef enum
/// {
///  DIB_RGB_COLORS = 0x00,
///  DIB_PAL_COLORS = 0x01,
///  DIB_PAL_INDICES = 0x02
/// } DIBColors;
/// DIBs are specified by DeviceIndependentBitmap objects ([MS-WMF] section 2.2.2.9).
public enum DIBColors: UInt32, DataStreamCreatable {
    /// DIB_RGB_COLORS: The color table contains literal RGB values.
    case rgbColors = 0x00
    
    /// DIB_PAL_COLORS: The color table consists of an array of 16-bit indexes into the LogPalette object (section 2.2.17) that is
    /// currently defined in the playback device context.
    case palColors = 0x01
    
    /// DIB_PAL_INDICES: No color table exists. The pixels in the DIB are indices into the current logical palette in the playback device
    /// context.
    case palIndices = 0x02
}
