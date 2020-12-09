//
//  EMR_LINETO.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.13 EMR_LINETO Record
/// The EMR_LINETO record specifies a line from the current drawing position up to, but not including, the specified point. It resets the
/// current position to the specified point.
/// See section 2.3.5 for more drawing record types.
public struct EMR_LINETO {
    public let type: RecordType
    public let size: UInt32
    public let point: PointL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_LINETO. This value is 0x00000036.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_LINETO else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 16 else {
            throw EmfReadError.corrupted
        }
        
        /// Point (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15), which specifies the coordinates of the line's endpoint.
        self.point = try PointL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
