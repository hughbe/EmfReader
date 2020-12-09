//
//  EMR_SELECTCLIPPATH.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.2.5 EMR_SELECTCLIPPATH Record
/// The EMR_SELECTCLIPPATH record sets the current clipping region in the playback device context to the current clipping region
/// combined with current path bracket.
/// Fields not specified in this section are specified in section 2.3.2.
/// This EMF record specifies no parameters.
public struct EMR_SELECTCLIPPATH {
    public let type: RecordType
    public let size: UInt32
    public let regionMode: RegionMode
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SELECTCLIPPATH. This value is 0x00000043.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SELECTCLIPPATH else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of the record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// RegionMode (4 bytes): An unsigned integer that specifies how to combine the current clipping region with the current path
        /// bracket. This value is in the RegionMode enumeration (section 2.1.29).
        self.regionMode = try RegionMode(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
