//
//  EMR_POLYBEZIER16.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.17 EMR_POLYBEZIER16 Record
/// The EMR_POLYBEZIER16 record specifies one or more Bezier curves. The curves are drawn using the current pen.
/// See section 2.3.5 for more drawing record types.
public struct EMR_POLYBEZIER16 {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let count: UInt32
    public let aPoints: [PointS]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_POLYBEZIER16. This value is 0x00000055.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_POLYBEZIER16 else {
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
        
        /// Count (4 bytes): An unsigned integer that specifies the total number of points. This value MUST be one more than three
        /// times the number of curves to be drawn because each Bezier curve requires two control points and an endpoint, and
        /// the initial curve requires an additional starting point.
        self.count = try dataStream.read(endianess: .littleEndian)
        guard 28 + self.count * 4 == size else {
            throw EmfReadError.corrupted
        }
        
        /// aPoints (variable): An array of PointS objects ([MS-WMF] section 2.2.2.16), which specify the points of the Bezier curves
        /// in logical units.
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
