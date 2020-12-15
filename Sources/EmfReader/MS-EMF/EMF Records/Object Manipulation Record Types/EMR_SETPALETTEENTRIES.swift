//
//  EMR_SETPALETTEENTRIES.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.8.8 EMR_SETPALETTEENTRIES Record
/// The EMR_SETPALETTEENTRIES record defines RGB color values in a range of entries for an existing logical palette.
/// See section 2.3.8 for more object manipulation record types.
public struct EMR_SETPALETTEENTRIES {
    public let type: RecordType
    public let size: UInt32
    public let ihPal: UInt32
    public let start: UInt32
    public let numberofEntries: UInt32
    public let aPalEntries: [LogPaletteEntry]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETPALETTEENTRIES. This value is 0x00000031.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_CREATEPALETTE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000014 && size % 4 == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// ihPal (4 bytes): An unsigned integer that specifies an index of a LogPalette object (section 2.2.17) in the EMF object table
        /// (section 3.1.1.1).
        self.ihPal = try dataStream.read(endianess: .littleEndian)
        
        /// Start (4 bytes): An unsigned integer that specifies the index in the palette of the first entry to set.
        self.start = try dataStream.read(endianess: .littleEndian)
        
        /// NumberofEntries (4 bytes): An unsigned integer that specifies the number of entries in the aPalEntries array.
        let numberofEntries: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard numberofEntries < 0x3FFFFFFA &&
                0x00000014 + numberofEntries * 4 == size else {
            throw EmfReadError.corrupted
        }
        
        self.numberofEntries = numberofEntries
        
        /// aPalEntries (variable): An array of LogPaletteEntry objects (section 2.2.18) that specify the palette data.
        var aPalEntries: [LogPaletteEntry] = []
        aPalEntries.reserveCapacity(Int(self.numberofEntries))
        for _ in 0..<self.numberofEntries {
            aPalEntries.append(try LogPaletteEntry(dataStream: &dataStream))
        }
        
        self.aPalEntries = aPalEntries
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
