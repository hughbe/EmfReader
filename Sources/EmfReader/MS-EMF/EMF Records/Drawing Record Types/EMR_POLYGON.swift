//
//  EMR_POLYGON.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.22 EMR_POLYGON Record
/// The EMR_POLYGON record specifies a polygon consisting of two or more vertexes connected by straight lines.
/// The polygon SHOULD be outlined using the current pen and filled using the current brush and polygon fill mode. The polygon
/// SHOULD be closed automatically by drawing a line from the last vertex to the first.
/// See section 2.3.5 for more drawing record types.
public struct EMR_POLYGON {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let count: UInt32
    public let aPoints: [PointL]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_POLYGON. This value is 0x00000003.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_POLYGON else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 28 && (size %  4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the bounding rectangle in logical units.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// Count (4 bytes): An unsigned integer that specifies the number of points in the aPoints array.
        /// Line width Device supports wideline Maximum points allowed
        /// 1 n/a 16K
        /// > 1 yes 16K
        /// > 1 no 1360
        /// Any extra points MUST be ignored.
        self.count = try dataStream.read(endianess: .littleEndian)
        guard 28 + self.count * 8 == size else {
            throw EmfReadError.corrupted
        }
        
        /// aPoints (variable): A Count length array of PointL objects ([MS-WMF] section 2.2.2.15) that specifies the vertexes of the
        /// polygon in logical units.
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
