//
//  HatchStyle.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

/// [MS-EMF] 2.1.17 HatchStyle Enumeration
/// The HatchStyle enumeration is an extension to the WMF HatchStyle enumeration ([MS-WMF] section 2.1.1.12).
/// typedef enum
/// {
///  HS_SOLIDCLR = 0x0006,
///  HS_DITHEREDCLR = 0x0007,
///  HS_SOLIDTEXTCLR = 0x0008,
///  HS_DITHEREDTEXTCLR = 0x0009,
///  HS_SOLIDBKCLR = 0x000A,
///  HS_DITHEREDBKCLR = 0x000B
/// } HatchStyle;
public enum HatchStyle: UInt16, DataStreamCreatable {
    /// HS_HORIZONTAL: A horizontal hatch.
    case horizontal = 0x0000
    
    /// HS_VERTICAL: A vertical hatch.
    case vertical = 0x0001
    
    /// HS_FDIAGONAL: A 45-degree downward, left-to-right hatch.
    case fDiagonal = 0x0002
    
    /// HS_BDIAGONAL: A 45-degree upward, left-to-right hatch.
    case bDiagonal = 0x0003
    
    /// HS_CROSS: A horizontal and vertical cross-hatch.
    case cross = 0x0004
    
    /// HS_DIAGCROSS: A 45-degree crosshatch.
    case diagCross = 0x0005
    
    /// HS_SOLIDCLR: The hatch is not a pattern, but is a solid color.
    case solidClr = 0x0006
    
    /// HS_DITHEREDCLR: The hatch is not a pattern, but is a dithered color.
    case ditheredClr = 0x0007
    
    /// HS_SOLIDTEXTCLR: The hatch is not a pattern, but is a solid color, defined by the current text (foreground) color.
    case solidTextClr = 0x0008
    
    /// HS_DITHEREDTEXTCLR: The hatch is not a pattern, but is a dithered color, defined by the current text (foreground) color.
    case ditheredTextClr = 0x0009
    
    /// HS_SOLIDBKCLR: The hatch is not a pattern, but is a solid color, defined by the current background color.
    case solidBkClr = 0x000A
    
    /// HS_DITHEREDBKCLR: The hatch is not a pattern, but is a dithered color, defined by the current background color.
    case ditheredBkClr = 0x000B
}
