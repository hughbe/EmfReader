//
//  LogPaletteEntry.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.18 LogPaletteEntry Object
/// The LogPaletteEntry object defines the values that make up a single entry in a LogPalette object (section 2.2.17).
/// EMF MUST define colors as device-independent values because the metafile itself is deviceindependent.
public struct LogPaletteEntry {
    public let reserved: UInt8
    public let blue: UInt8
    public let green: UInt8
    public let red: UInt8
    
    public init(dataStream: inout DataStream) throws {
        /// Reserved (1 byte): An unsigned integer that MUST NOT be used and MUST be ignored.
        self.reserved = try dataStream.read()
        
        /// Blue (1 byte): An unsigned integer that defines the blue intensity value for the entry.
        self.blue = try dataStream.read()
        
        /// Green (1 byte): An unsigned integer that defines the green intensity value for the entry.
        self.green = try dataStream.read()
        
        /// Red (1 byte): An unsigned integer that defines the red intensity value for the entry.
        self.red = try dataStream.read()
    }
}
