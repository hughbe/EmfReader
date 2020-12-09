//
//  EMR_ARC.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.2 EMR_ARC Record
/// The EMR_ARC record specifies an elliptical arc.
/// See section 2.3.5 for more drawing record types.
public struct EMR_ARC {
    public let type: RecordType
    public let size: UInt32
    public let box: RectL
    public let start: PointL
    public let end: PointL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_ARC. This value is 0x0000002D.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_ARC else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 40 else {
            throw EmfReadError.corrupted
        }
        
        /// Box (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19), which specifies the inclusive-inclusive bounding rectangle in logical units.
        self.box = try RectL(dataStream: &dataStream)
        
        /// Start (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15), which specifies the coordinates in logical units of the
        /// ending point of the radial line defining the starting point of the arc.
        self.start = try PointL(dataStream: &dataStream)
        
        /// End (8 bytes): A PointL object that specifies the coordinates in logical units of the ending point of the radial line defining
        /// the ending point of the arc.
        self.end = try PointL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
