//
//  EMR_ANGLEARC.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.1 EMR_ANGLEARC Record
/// The EMR_ANGLEARC record specifies a line segment of an arc. The line segment is drawn from the current position to the beginning
/// of the arc. The arc is drawn along the perimeter of a circle with the given radius and center. The length of the arc is defined by the
/// given start and sweep angles.
/// See section 2.3.5 for more drawing record types.
public struct EMR_ANGLEARC {
    public let type: RecordType
    public let size: UInt32
    public let center: PointL
    public let radius: UInt32
    public let startAngle: Float
    public let sweepAngle: Float
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_ANGLEARC. This value is 0x00000029.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_ANGLEARC else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 28 else {
            throw EmfReadError.corrupted
        }
        
        /// Center (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15), which specifies the logical coordinates of the circle's center.
        self.center = try PointL(dataStream: &dataStream)
        
        /// Radius (4 bytes): An unsigned integer that specifies the circle's radius, in logical units.
        self.radius = try dataStream.read(endianess: .littleEndian)
        
        /// StartAngle (4 bytes): A 32-bit float that specifies the arc's start angle, in degrees.
        self.startAngle = try dataStream.readFloat(endianess: .littleEndian)
        
        /// SweepAngle (4 bytes): A 32-bit float that specifies the arc's sweep angle, in degrees.
        self.sweepAngle = try dataStream.readFloat(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
