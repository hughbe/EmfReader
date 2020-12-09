//
//  BackgroundMode.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

/// [MS-EMF] 2.1.4 BackgroundMode Enumeration
/// The BackgroundMode enumeration is used to specify the background mode to be used with text, hatched brushes, and pen styles
/// that are not solid. The background mode determines how to combine the background with foreground text, hatched brushes, and
/// pen styles that are not solid lines.
/// typedef enum
/// {
///  TRANSPARENT = 0x0001,
///  OPAQUE = 0x0002
/// } BackgroundMode;
public enum BackgroundMode: UInt32, DataStreamCreatable {
    /// TRANSPARENT: Background remains untouched.
    case transparent = 0x0001

    /// OPAQUE: Background is filled with the current background color before the text, hatched brush, or pen is drawn.
    case opaque = 0x0002
}
