//
//  EMR_SETMETARGN.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.2 Clipping Record Types
/// EMR_SETMETARGN 2.3.2 If the current metaregion is null, it is set to the current clipping region. Otherwise, the current metaregion is
/// intersected with the current clipping region, and the result is the new metaregion.
/// After the operation, the current clipping region is set to null.
/// During playback, drawing occurs only within the intersection of the metaregion and clipping region.
/// This EMF record specifies no parameters.
public struct EMR_SETMETARGN {
    public let type: RecordType
    public let size: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETMETARGN. This value is 0x0000001C.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETMETARGN else {
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
