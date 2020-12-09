//
//  EMR_REALIZEPALETTE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.11 State Record Types
/// EMR_REALIZEPALETTE 2.3.11 This record maps palette entries from the current LogPalette object (section 2.2.17) to the
/// system_palette.
/// This record specifies no parameters.
public struct EMR_REALIZEPALETTE {
    public let type: RecordType
    public let size: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_REALIZEPALETTE. This value is 0x00000034.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_REALIZEPALETTE else {
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
