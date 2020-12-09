//
//  StockObject.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

/// [MS-EMF] 2.1.31 StockObject Enumeration
/// The StockObject enumeration specifies the indexes of predefined logical graphics objects that can be used in graphics operations.
/// The specific structures of stock objects are implementation-dependent; however, the properties of stock objects SHOULD be
/// equivalent to the properties of explicitly created objects of the same type.
/// These properties are specified where possible for the stock objects defined in this enumeration.
/// typedef enum
/// {
/// WHITE_BRUSH = 0x80000000,
/// LTGRAY_BRUSH = 0x80000001,
/// GRAY_BRUSH = 0x80000002,
/// DKGRAY_BRUSH = 0x80000003,
/// BLACK_BRUSH = 0x80000004,
/// NULL_BRUSH = 0x80000005,
/// WHITE_PEN = 0x80000006,
/// BLACK_PEN = 0x80000007,
/// NULL_PEN = 0x80000008,
/// OEM_FIXED_FONT = 0x8000000A,
/// ANSI_FIXED_FONT = 0x8000000B,
/// ANSI_VAR_FONT = 0x8000000C,
/// SYSTEM_FONT = 0x8000000D,
/// DEVICE_DEFAULT_FONT = 0x8000000E,
/// DEFAULT_PALETTE = 0x8000000F,
/// SYSTEM_FIXED_FONT = 0x80000010,
/// DEFAULT_GUI_FONT = 0x80000011,
/// DC_BRUSH = 0x80000012,
/// DC_PEN = 0x80000013
/// } StockObject;
public enum StockObject: UInt32 {
    /// WHITE_BRUSH: A white, solid-color brush that is equivalent to a logical brush (LogBrushEx object, section 2.2.12) with
    /// the following properties:
    ///  BrushStyle: BS_SOLID from the BrushStyle enumeration ([MS-WMF] section 2.1.1.4)
    ///  Color: 0x00FFFFFF in a ColorRef object ([MS-WMF] section 2.2.2.8)
    case WHITE_BRUSH = 0x80000000
    
    /// LTGRAY_BRUSH: A light gray, solid-color brush that is equivalent to a logical brush with the following properties:
    ///  BrushStyle: BS_SOLID
    ///  Color: 0x00C0C0C0
    case LTGRAY_BRUSH = 0x80000001
    
    /// GRAY_BRUSH: A gray, solid-color brush that is equivalent to a logical brush with the following properties:
    ///  BrushStyle: BS_SOLID
    ///  Color: 0x00808080
    case GRAY_BRUSH = 0x80000002
    
    /// DKGRAY_BRUSH: A dark gray, solid color brush that is equivalent to a logical brush with the following properties:
    ///  BrushStyle: BS_SOLID
    ///  Color: 0x00404040
    case DKGRAY_BRUSH = 0x80000003
    
    /// BLACK_BRUSH: A black, solid color brush that is equivalent to a logical brush with the following properties:
    ///  BrushStyle: BS_SOLID
    ///  Color: 0x00000000
    case BLACK_BRUSH = 0x80000004
    
    /// NULL_BRUSH: A null brush that is equivalent to a logical brush with the following properties:
    ///  BrushStyle: BS_NULL
    case NULL_BRUSH = 0x80000005
    
    /// WHITE_PEN: A white, solid-color pen that is equivalent to a logical pen (LogPen object, section 2.2.19) with the following
    /// properties:
    ///  PenStyle: PS_COSMETIC + PS_SOLID from the PenStyle enumeration (section 2.1.25)
    ///  ColorRef: 0x00FFFFFF in a ColorRef object.
    case WHITE_PEN = 0x80000006
    
    /// BLACK_PEN: A black, solid-color pen that is equivalent to a logical pen with the following properties:
    ///  PenStyle: PS_COSMETIC + PS_SOLID
    ///  ColorRef: 0x00000000
    case BLACK_PEN = 0x80000007
    
    /// NULL_PEN: A null pen that is equivalent to a logical pen with the following properties:
    ///  PenStyle: PS_NULL
    case NULL_PEN = 0x80000008
    
    /// OEM_FIXED_FONT: A fixed-width, OEM character set font that is equivalent to a LogFont object (section 2.2.13) with the
    /// following properties:
    ///  Charset: OEM_CHARSET from the CharacterSet enumeration ([MS-WMF] section 2.1.1.5)
    ///  PitchAndFamily: FF_DONTCARE (FamilyFont enumeration, [MS-WMF] section 2.1.1.8) + FIXED_PITCH (PitchFont enumeration,
    /// [MS-WMF] section 2.1.1.24)
    case OEM_FIXED_FONT = 0x8000000A
    
    /// ANSI_FIXED_FONT: A fixed-width font that is equivalent to a LogFont object with the following properties:<33>
    ///  Charset: ANSI_CHARSET
    ///  PitchAndFamily: FF_DONTCARE + FIXED_PITCH
    case ANSI_FIXED_FONT = 0x8000000B
    
    /// ANSI_VAR_FONT: A variable-width font that is equivalent to a logical font with the following properties:<34>
    ///  Charset: ANSI_CHARSET
    ///  PitchAndFamily: FF_DONTCARE + VARIABLE_PITCH
    case ANSI_VAR_FONT = 0x8000000C
    
    /// SYSTEM_FONT: A font that is guaranteed to be available in the operating system. The actual font that is specified by this value
    /// is implementation-dependent.<35>
    case SYSTEM_FONT = 0x8000000D
    
    /// DEVICE_DEFAULT_FONT: The default font that is provided by the graphics device driver for the current output device.
    /// The actual font that is specified by this value is implementation-dependent.<36>
    case DEVICE_DEFAULT_FONT = 0x8000000E
    
    /// DEFAULT_PALETTE: The default palette that is defined for the current output device. The actual palette that is specified by this
    /// value is implementation-dependent.<37>
    case DEFAULT_PALETTE = 0x8000000F
    
    /// SYSTEM_FIXED_FONT: A fixed-width font that is guaranteed to be available in the operating system. The actual font that is
    /// specified by this value is implementation-dependent.
    case SYSTEM_FIXED_FONT = 0x80000010
    
    /// DEFAULT_GUI_FONT: The default font that is used for user interface objects such as menus and dialog boxes. The actual font
    /// that is specified by this value is implementation-dependent.<38>
    case DEFAULT_GUI_FONT = 0x80000011
    
    /// DC_BRUSH: The solid-color brush that is currently selected in the playback device context. The default SHOULD<39> be
    /// WHITE_BRUSH.
    case DC_BRUSH = 0x80000012
    
    /// DC_PEN: The solid-color pen that is currently selected in the playback device context. The default SHOULD<40> be BLACK_PEN.
    case DC_PEN = 0x80000013
}
