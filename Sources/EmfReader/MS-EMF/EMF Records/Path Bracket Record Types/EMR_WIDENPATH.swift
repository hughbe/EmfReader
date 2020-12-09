//
//  EMR_WIDENPATH.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.10 Path Bracket Record Types
/// EMR_WIDENPATH This record redefines the current path as the area that would be painted if its path were drawn using the current pen.
public struct EMR_WIDENPATH {
    public let type: RecordType
    public let size: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_WIDENPATH. This value is 0x00000042.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_WIDENPATH else {
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
