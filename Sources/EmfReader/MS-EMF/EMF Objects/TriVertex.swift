//
//  File.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream

/// [SM_EMF] 2.2.26 TriVertex Object
/// The TriVertex object specifies color and position information for the definition of a rectangle or triangle vertex.
public struct TriVertex {
    public let x: Int32
    public let y: Int32
    public let red: UInt16
    public let green: UInt16
    public let blue: UInt16
    public let alpha: UInt16
    
    public init(dataStream: inout DataStream) throws {
        /// x (4 bytes): A signed integer that specifies the horizontal position, in logical units.
        self.x = try dataStream.read(endianess: .littleEndian)
        
        /// y (4 bytes): A signed integer that specifies the vertical position, in logical units.
        self.y = try dataStream.read(endianess: .littleEndian)
        
        /// Red (2 bytes): An unsigned integer that specifies the red color value for the point.
        self.red = try dataStream.read(endianess: .littleEndian)
        
        /// Green (2 bytes): An unsigned integer that specifies the green color value for the point.
        self.green = try dataStream.read(endianess: .littleEndian)
        
        /// Blue (2 bytes): An unsigned integer that specifies the blue color value for the point.
        self.blue = try dataStream.read(endianess: .littleEndian)
        
        /// Alpha (2 bytes): An unsigned integer that specifies the alpha transparency value for the point.
        self.alpha = try dataStream.read(endianess: .littleEndian)
    }
}
