//
//  EMR_POLYLINE16.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.25 EMR_POLYLINE16 Record
/// The EMR_POLYLINE16 record specifies a series of line segments by connecting the points in the specified array.
/// See section 2.3.5 for more drawing record types.
public struct EMR_POLYLINE16 {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let count: UInt32
    public let aPoints: [PointS]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_POLYLINE16. This value is 0x00000057.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_POLYLINE16 else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 28 && (size %  4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object, specified in [MS-WMF] section 2.2.2.19, which specifies the bounding rectangle in
        /// logical units.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// Count (4 bytes): An unsigned integer that specifies the total number of points.
        self.count = try dataStream.read(endianess: .littleEndian)
        guard 28 + self.count * 4 == size else {
            throw EmfReadError.corrupted
        }
        
        /// aPoints (variable): A Count length array of PointS objects, specified in [MS-WMF] section 2.2.2.16, which specifies the
        /// array of points.
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
