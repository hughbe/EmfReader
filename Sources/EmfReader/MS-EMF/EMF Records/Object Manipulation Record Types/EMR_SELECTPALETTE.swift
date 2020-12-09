//
//  EMR_SELECTPALETTE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.8.6 EMR_SELECTPALETTE Record
/// The EMR_SELECTPALETTE record selects a logical palette into the playback device context.
/// The palette specified by this record MUST be used in subsequent EMF drawing operations, until another EMR_SELECTPALETTE
/// record changes the object or the object is deleted.
/// See section 2.3.8 for more object manipulation record types.
public struct EMR_SELECTPALETTE {
    public let type: RecordType
    public let size: UInt32
    public let ihPal: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SELECTPALETTE. This value is 0x00000030.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SELECTPALETTE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes. This value is 0x0000000C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// ihPal (4 bytes): An unsigned integer that specifies either the index of a LogPalette object (section 2.2.17) in the EMF object
        /// table (section 3.1.1.1) or the value DEFAULT_PALETTE from the StockObject enumeration (section 2.1.31), which is the
        /// index of a stock palette.
        /// The object index MUST NOT be zero, which is reserved and refers to the EMF metafile itself.
        self.ihPal = try dataStream.read(endianess: .littleEndian)
        guard self.ihPal != 0 else {
            throw EmfReadError.corrupted
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
