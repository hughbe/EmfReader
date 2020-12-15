//
//  EMR_POLYPOLYLINE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.5.30 EMR_POLYPOLYLINE Record
/// The EMR_POLYPOLYLINE record draws multiple series of connected line segments.
/// The line segments SHOULD be drawn using the current pen. The figures formed by the segments SHOULD NOT filled. The current
/// drawing position SHOULD neither be used nor updated by this record.
/// See section 2.3.5 for more drawing record types.
public struct EMR_POLYPOLYLINE {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let numberOfPolylines: UInt32
    public let count: UInt32
    public let aPolylinePointCount: [UInt32]
    public let aPoints: [PointL]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_POLYPOLYLINE. This value is 0x00000007.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_POLYPOLYLINE else {
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
        
        /// NumberOfPolylines (4 bytes): An unsigned integer that specifies the number of polylines, which is the number of elements
        /// in the aPolylinePointCount array.
        self.numberOfPolylines = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000020 + self.numberOfPolylines * 4 else {
            throw EmfReadError.corrupted
        }
        
        /// Count (4 bytes): An unsigned integer that specifies the total number of points in all polylines, which is the number of
        /// elements in the aPoints array.
        /// Line width Device supports wideline Maximum points allowed
        /// 1 n/a 16K
        /// > 1 yes 16K
        /// > 1 no 1360
        /// Any extra points MUST be ignored.
        self.count = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000020 + self.numberOfPolylines * 4 + self.count * 8 else {
            throw EmfReadError.corrupted
        }
        
        /// aPolylinePointCount (variable): A NumberOfPolylines-length array of 32-bit unsigned integers that specify the point
        /// counts for all polylines. Each value MUST be >= 0x00000002.
        /// Each point count refers to a number of consecutive elements in the aPoints array.
        var aPolylinePointCount: [UInt32] = []
        aPolylinePointCount.reserveCapacity(Int(self.numberOfPolylines))
        for _ in 0..<self.numberOfPolylines {
            let value: UInt32 = try dataStream.read(endianess: .littleEndian)
            guard value >= 0x00000002 else {
                throw EmfReadError.corrupted
            }

            aPolylinePointCount.append(value)
        }
        
        self.aPolylinePointCount = aPolylinePointCount
        
        /// aPoints (variable): A Count-length array of PointL objects ([MS-WMF] section 2.2.2.15) that specify the point data,
        /// in logical units.
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
