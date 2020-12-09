//
//  LogPalette.swift
//  
//
//  Created by Hugh Bellamy on 08/12/2020.
//

import DataStream

public struct LogPalette {
    public let version: UInt16
    public let numberOfEntries: UInt16
    public let paletteEntries: [LogPaletteEntry]
    
    public init(dataStream: inout DataStream) throws {
        /// Version (2 bytes): An unsigned integer that specifies the version number of the system. This value is 0x0300.
        self.version = try dataStream.read(endianess: .littleEndian)
        guard self.version == 0x0300 else {
            throw EmfReadError.corrupted
        }
        
        /// NumberOfEntries (2 bytes): An unsigned integer that specifies the number of entries in the PaletteEntries field.
        self.numberOfEntries = try dataStream.read(endianess: .littleEndian)
        
        /// PaletteEntries (variable): An array of LogPaletteEntry objects (section 2.2.18) that defines the color and usage of each
        /// entry in the logical_palette.
        var paletteEntries: [LogPaletteEntry] = []
        paletteEntries.reserveCapacity(Int(self.numberOfEntries))
        for _ in 0..<self.numberOfEntries {
            paletteEntries.append(try LogPaletteEntry(dataStream: &dataStream))
        }
        
        self.paletteEntries = paletteEntries
    }
}
