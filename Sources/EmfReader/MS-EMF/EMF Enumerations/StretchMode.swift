//
//  StretchMode.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

/// [MS-EMF] 2.1.32 StretchMode Enumeration
/// The StretchMode enumeration is used to specify how color data is added to or removed from bitmaps that are stretched or
/// compressed.<41>
/// typedef enum
/// {
///  STRETCH_ANDSCANS = 0x01,
///  STRETCH_ORSCANS = 0x02,
///  STRETCH_DELETESCANS = 0x03,
///  STRETCH_HALFTONE = 0x04
/// } StretchMode;
public enum StretchMode: UInt32, DataStreamCreatable {
    /// STRETCH_ANDSCANS: Performs a Boolean AND operation using the color values for the eliminated and existing pixels.
    /// If the bitmap is a monochrome bitmap, this mode preserves black pixels at the expense of white pixels.
    case andScans = 0x01
    
    /// STRETCH_ORSCANS: Performs a Boolean OR operation using the color values for the eliminated and existing pixels.
    /// If the bitmap is a monochrome bitmap, this mode preserves white pixels at the expense of black pixels.
    case orScans = 0x02
    
    /// STRETCH_DELETESCANS: Deletes the pixels. This mode deletes all eliminated lines of pixels without trying to preserve their
    /// information.
    case deleteScans = 0x03
    
    /// STRETCH_HALFTONE: Maps pixels from the source rectangle into blocks of pixels in the destination rectangle. The average
    /// color over the destination block of pixels approximates the color of the source pixels.
    /// After setting the STRETCH_HALFTONE stretching mode, the brush origin SHOULD be defined by an EMR_SETBRUSHORGEX
    /// record. If it fails to do so, brush misalignment can occur.
    case halftone = 0x04
}
