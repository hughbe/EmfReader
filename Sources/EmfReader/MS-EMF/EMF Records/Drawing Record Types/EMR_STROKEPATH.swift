//
//  EMR_STROKEPATH.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.39 EMR_STROKEPATH Record
/// The EMR_STROKEPATH record renders the specified path by using the current pen.
/// See section 2.3.5 for more drawing record types.
public struct EMR_STROKEPATH {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_STROKEPATH. This value is 0x00000040.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_STROKEPATH else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 24 else {
            throw EmfReadError.corrupted
        }
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the bounding rectangle in logical units.
        self.bounds = try RectL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
