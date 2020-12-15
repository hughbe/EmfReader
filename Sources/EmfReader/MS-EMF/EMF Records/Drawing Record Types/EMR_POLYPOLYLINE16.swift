//
//  EMR_POLYPOLYLINE16.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.5.31 EMR_POLYPOLYLINE16 Record
/// The EMR_POLYPOLYLINE16 record specifies multiple series of connected line segments.
/// See section 2.3.5 for more drawing record types.
public struct EMR_POLYPOLYLINE16 {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let numberOfPolylines: UInt32
    public let count: UInt32
    public let polylinePointCount: [UInt32]
    public let aPoints: [PointS]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_POLYPOLYLINE16. This value is 0x0000005A.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_POLYPOLYLINE16 else {
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
        
        /// NumberOfPolylines (4 bytes): An unsigned integer that specifies the number of polylines.
        self.numberOfPolylines = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000020 + self.numberOfPolylines * 4 else {
            throw EmfReadError.corrupted
        }
        
        /// Count (4 bytes): An unsigned integer that specifies the total number of points in all polylines.
        self.count = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000020 + self.numberOfPolylines * 4 + self.count * 4 else {
            throw EmfReadError.corrupted
        }
        
        /// PolylinePointCount (variable): A NumberOfPolylines length array of 32-bit unsigned integers that specifies the point
        /// counts for each polyline.
        var polylinePointCount: [UInt32] = []
        polylinePointCount.reserveCapacity(Int(self.numberOfPolylines))
        for _ in 0..<self.numberOfPolylines {
            let value: UInt32 = try dataStream.read(endianess: .littleEndian)
            guard value >= 0x00000002 else {
                throw EmfReadError.corrupted
            }

            polylinePointCount.append(value)
        }
        
        self.polylinePointCount = polylinePointCount
        
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
