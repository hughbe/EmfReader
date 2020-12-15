//
//  EMR_COLORCORRECTPALETTE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.8.1 EMR_COLORCORRECTPALETTE Record
/// The EMR_COLORCORRECTPALETTE record specifies the correction of entries of a logical palette object using WCS.<75>
/// See section 2.3.8 for more object manipulation record types.
public struct EMR_COLORCORRECTPALETTE {
    public let type: RecordType
    public let size: UInt32
    public let ihPalette: UInt32
    public let nFirstEntry: UInt32
    public let nPalEntries: UInt32
    public let nReserved: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_COLORCORRECTPALETTE. This value is 0x0000006F.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_COLORCORRECTPALETTE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes. This value is 0x00000018.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000018 else {
            throw EmfReadError.corrupted
        }
        
        /// ihPalette (4 bytes): An unsigned integer that specifies the index of a logical palette object (section 2.2.17) in the EMF object
        /// table (section 3.1.1.1).
        self.ihPalette = try dataStream.read(endianess: .littleEndian)
        
        /// nFirstEntry (4 bytes): An unsigned integer that specifies the index of the first entry to correct.
        self.nFirstEntry = try dataStream.read(endianess: .littleEndian)
        
        /// nPalEntries (4 bytes): An unsigned integer that specifies the number of palette entries to correct.
        self.nPalEntries = try dataStream.read(endianess: .littleEndian)
        
        /// nReserved (4 bytes): An unsigned integer that is undefined and unused.
        self.nReserved = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
