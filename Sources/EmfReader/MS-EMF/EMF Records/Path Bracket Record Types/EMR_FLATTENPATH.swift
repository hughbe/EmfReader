//
//  EMR_FLATTENPATH.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.10 Path Bracket Record Types
/// EMR_FLATTENPATH This record transforms each curve in the current path into a sequence of lines.
public struct EMR_FLATTENPATH {
    public let type: RecordType
    public let size: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_FLATTENPATH. This value is 0x00000041.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_FLATTENPATH else {
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
