//
//  EMR_POLYPOLYGON16.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.5.29 EMR_POLYPOLYGON16 Record
/// The EMR_POLYPOLYGON16 record specifies a series of closed polygons. Each polygon is outlined using the current pen, and filled
/// using the current brush and polygon fill mode. The polygons drawn by this record can overlap.
/// See section 2.3.5 for more drawing record types.
public struct EMR_POLYPOLYGON16 {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let numberOfPolygons: UInt32
    public let count: UInt32
    public let polygonPointCount: [UInt32]
    public let aPoints: [PointS]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_POLYPOLYGON16. This value is 0x0000005B.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_POLYPOLYGON16 else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000020 && size % 4 == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19), which specifies the bounding rectangle in logical units.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// NumberOfPolygons (4 bytes): An unsigned integer that specifies the number of polygons.
        self.numberOfPolygons = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000020 + self.numberOfPolygons * 4 else {
            throw EmfReadError.corrupted
        }
        
        /// Count (4 bytes): An unsigned integer that specifies the total number of points in all polygons.
        self.count = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000020 + self.numberOfPolygons * 4 + self.count * 4 else {
            throw EmfReadError.corrupted
        }
        
        /// PolygonPointCount (variable): A NumberOfPolygons length array of 32-bit unsigned integers that specifies the point
        /// counts for each polygon.
        var polygonPointCount: [UInt32] = []
        polygonPointCount.reserveCapacity(Int(self.numberOfPolygons))
        for _ in 0..<self.numberOfPolygons {
            polygonPointCount.append(try dataStream.read(endianess: .littleEndian))
        }
        
        self.polygonPointCount = polygonPointCount
        
        /// aPoints (variable): A Count length array of PointS objects ([MS-WMF] section 2.2.2.16), which specifies the array of points.
        var aPoints: [PointS] = []
        aPoints.reserveCapacity(Int(self.count))
        for _ in 0..<self.count {
            aPoints.append(try PointS(dataStream: &dataStream))
        }
        
        self.aPoints = aPoints
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
