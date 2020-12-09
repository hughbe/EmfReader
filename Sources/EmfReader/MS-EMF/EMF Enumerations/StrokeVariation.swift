//
//  StrokeVariation.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.33 StrokeVariation Enumeration
/// The StrokeVariation enumeration defines values for one of the characteristics in the PANOSE system for classifying typefaces.
/// typedef enum
/// {
///  PAN_ANY = 0x00,
///  PAN_NO_FIT = 0x01,
///  PAN_STROKE_GRADUAL_DIAG = 0x02,
///  PAN_STROKE_GRADUAL_TRAN = 0x03,
///  PAN_STROKE_GRADUAL_VERT = 0x04,
///  PAN_STROKE_GRADUAL_HORZ = 0x05,
///  PAN_STROKE_RAPID_VERT = 0x06,
///  PAN_STROKE_RAPID_HORZ = 0x07,
///  PAN_STROKE_INSTANT_VERT = 0x08
/// } StrokeVariation;
public enum StrokeVariation: UInt8, DataStreamCreatable {
    /// PAN_ANY: Any.
    case any = 0x00
    
    /// PAN_NO_FIT: No fit.
    case noFit = 0x01
    
    /// PAN_STROKE_GRADUAL_DIAG: Gradual/diagonal.
    case gradualDiag = 0x02
    
    /// PAN_STROKE_GRADUAL_TRAN: Gradual/transitional.
    case gradualTran = 0x03
    
    /// PAN_STROKE_GRADUAL_VERT: Gradual/vertical.
    case gradualVert = 0x04
    
    /// PAN_STROKE_GRADUAL_HORZ: Gradual/horizontal.
    case gradualHorz = 0x05
    
    /// PAN_STROKE_RAPID_VERT: Rapid/vertical.
    case rapidVert = 0x06
    
    /// PAN_STROKE_RAPID_HORZ: Rapid/horizontal.
    case rapidHorz = 0x07
    
    /// PAN_STROKE_INSTANT_VERT: Instant/vertical.
    case instantVert = 0x08
}
