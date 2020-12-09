//
//  ArcDirection.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.2 ArcDirection Enumeration
/// The ArcDirection enumeration is used in setting the drawing direction for arcs and rectangles.
/// typedef enum
/// {
///  AD_COUNTERCLOCKWISE = 0x00000001,
///  AD_CLOCKWISE = 0x00000002
/// } ArcDirection;
public enum ArcDirection: UInt32, DataStreamCreatable {
    /// AD_COUNTERCLOCKWISE: Figures drawn counterclockwise.
    case counterclockwise = 0x00000001
    
    /// AD_CLOCKWISE: Figures drawn clockwise.
    case clockwise = 0x00000002
}
