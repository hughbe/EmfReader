//
//  EMR_SAVEDC.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.11 State Record Types
/// EMR_SAVEDC 2.3.11 Saves the current state of the playback device context in an array of states saved by preceding
/// EMR_SAVEDC records if any.
/// An EMR_RESTOREDC record is used to restore the state.
/// This record specifies no parameters.
public struct EMR_SAVEDC {
    public let type: RecordType
    public let size: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SAVEDC. This value is 0x00000021.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SAVEDC else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of the record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000008 else {
            throw EmfReadError.corrupted
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
