//
//  EMR_POLYPOLYGON.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.28 EMR_POLYPOLYGON Record
/// The EMR_POLYPOLYGON record specifies a series of closed polygons.
/// Fields not specified in this section are specified in section 2.3.5.
/// Each polygon SHOULD be outlined using the current pen, and filled using the current brush and polygon fill mode that are defined
/// in the playback device context. The polygons defined by this record can overlap.
/// See section 2.3.5 for more drawing record types.
public struct EMR_POLYPOLYGON {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let numberOfPolygons: UInt32
    public let count: UInt32
    public let polygonPointCount: [UInt32]
    public let aPoints: [PointL]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_POLYPOLYGON. This value is 0x00000008.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_POLYPOLYGON else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 32 && (size %  4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19), which specifies the bounding rectangle in logical units.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// NumberOfPolygons (4 bytes): An unsigned integer that specifies the number of polygons.
        self.numberOfPolygons = try dataStream.read(endianess: .littleEndian)
        guard size >= 32 + self.numberOfPolygons * 4 else {
            throw EmfReadError.corrupted
        }
        
        /// Count (4 bytes): An unsigned integer that specifies the total number of points in all polygons.
        /// Line width Device supports wideline Maximum points allowed
        /// 1 n/a 16K
        /// > 1 yes 16K
        /// > 1 no 1360
        /// Any extra points MUST be ignored. To draw a line with more points, the data SHOULD be divided into groups that have
        /// less than the maximum number of points, and an EMR_POLYPOLYGON operation SHOULD be performed for each group
        /// of points.
        self.count = try dataStream.read(endianess: .littleEndian)
        guard size >= 32 + self.numberOfPolygons * 4 + self.count * 8 else {
            throw EmfReadError.corrupted
        }
        
        /// PolygonPointCount (variable): An array of 32-bit unsigned integers that specifies the point count for each polygon.
        var polygonPointCount: [UInt32] = []
        polygonPointCount.reserveCapacity(Int(self.numberOfPolygons))
        for _ in 0..<self.numberOfPolygons {
            polygonPointCount.append(try dataStream.read(endianess: .littleEndian))
        }
        
        self.polygonPointCount = polygonPointCount
        
        /// aPoints (variable): An array of PointL objects ([MS-WMF] section 2.2.2.15) that specifies the points for all polygons in
        /// logical units. The number of points is specified by the Count field value.
        var aPoints: [PointL] = []
        aPoints.reserveCapacity(Int(self.count))
        for _ in 0..<self.count {
            aPoints.append(try PointL(dataStream: &dataStream))
        }
        
        self.aPoints = aPoints
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
