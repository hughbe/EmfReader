//
//  EMR_ENDPATH.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.10 Path Bracket Record Types
/// EMR_ENDPATH This record closes path bracket construction and selects the path into the playback device context.
public struct EMR_ENDPATH {
    public let type: RecordType
    public let size: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_ENDPATH. This value is 0x0000003C.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_ENDPATH else {
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
