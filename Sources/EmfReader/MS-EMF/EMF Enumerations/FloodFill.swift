//
//  File.swift
//  
//
//  Created by Hugh Bellamy on 09/12/2020.
//

/// [MS-EMF] 2.1.13 FloodFill Enumeration
/// The FloodFill enumeration defines values that specify how to determine the area for a flood fill operation.
/// typedef enum
/// {
///  FLOODFILLBORDER = 0x00000000,
///  FLOODFILLSURFACE = 0x00000001
/// } FloodFill;
public enum FloodFill: UInt32, DataStreamCreatable {
    /// FLOODFILLBORDER: The fill area is bounded by a specific color.
    case border = 0x00000000
    
    /// FLOODFILLSURFACE: The fill area is defined by a specific color. Filling continues outward in all directions as long as the color
    /// is encountered. This style is useful for filling areas with multicolored boundaries.
    case surface = 0x00000001
}
