//
//  GradientFill.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.15 GradientFill Enumeration
/// The GradientFill enumeration defines the modes for gradient fill operations.
/// typedef enum
/// {
///  GRADIENT_FILL_RECT_H = 0x00000000,
///  GRADIENT_FILL_RECT_V = 0x00000001,
///  GRADIENT_FILL_TRIANGLE = 0x00000002
/// } GradientFill;
public enum GradientFill: UInt32, DataStreamCreatable {
    /// GRADIENT_FILL_RECT_H: Color interpolation along a gradient from the left to the right edges of a rectangle.
    case rectH = 0x00000000
    
    /// GRADIENT_FILL_RECT_V: Color interpolation along a gradient from the top to the bottom edges of a rectangle.
     case rectV = 0x00000001
    
    /// GRADIENT_FILL_TRIANGLE: Color interpolation between vertexes of a triangle.
    case triangle = 0x00000002
}
