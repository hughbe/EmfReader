//
//  EMR_SELECTOBJECT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.8.5 EMR_SELECTOBJECT Record
/// The EMR_SELECTOBJECT record selects a graphics object into the playback device context.
/// See section 2.3.8 for more object manipulation record types.
public struct EMR_SELECTOBJECT {
    public let type: RecordType
    public let size: UInt32
    public let ihObject: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SELECTOBJECT. This value is 0x00000025.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SELECTOBJECT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// ihObject (4 bytes): An unsigned integer that specifies either the index of a graphics object in the EMF object table
        /// (section 3.1.1.1) or the index of a stock object in the StockObject enumeration (section 2.1.31).
        /// The object index MUST NOT be zero, which is reserved and refers to the EMF metafile itself.
        self.ihObject = try dataStream.read(endianess: .littleEndian)
        guard self.ihObject != 0 else {
            throw EmfReadError.corrupted
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
