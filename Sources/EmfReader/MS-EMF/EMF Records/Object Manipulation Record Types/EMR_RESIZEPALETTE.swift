//
//  EMR_RESIZEPALETTE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.8.4 EMR_RESIZEPALETTE Record
/// The EMR_RESIZEPALETTE record increases or decreases the size of an existing LogPalette object (section 2.2.17).
/// See section 2.3.8 for more object manipulation record types.
public struct EMR_RESIZEPALETTE {
    public let type: RecordType
    public let size: UInt32
    public let ihPal: UInt32
    public let numberOfEntries: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_RESIZEPALETTE. This value is 0x00000033.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_RESIZEPALETTE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000010 else {
            throw EmfReadError.corrupted
        }
        
        /// ihPal (4 bytes): An unsigned integer that specifies the index of the palette object in the EMF object table (section 3.1.1.1).
        self.ihPal = try dataStream.read(endianess: .littleEndian)
        
        /// NumberOfEntries (4 bytes): An unsigned integer that specifies the number of entries in the palette after resizing. The value
        /// MUST be <= 0x00000400 and > 0x00000000.<77>
        /// <77> Section 2.3.8.4: Windows GDI does not perform parameter validation on this value, which can lead to the generation
        /// of EMF metafiles that contain invalid EMR_RESIZEPALETTE records. Windows ignores such invalid records when processing
        /// metafiles.
        self.numberOfEntries = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
