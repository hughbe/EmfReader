//
//  EMR_POLYBEZIER.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.5.16 EMR_POLYBEZIER Record
/// The EMR_POLYBEZIER record specifies one or more Bezier curves.
/// Cubic Bezier curves are defined using the endpoints and control points specified by the aPoints field.
/// The first curve is drawn from the first point to the fourth point, using the second and third points as control points. Each subsequent
/// curve in the sequence needs exactly three more points: the ending point of the previous curve is used as the starting point, the next
/// two points in the sequence are control points, and the third is the ending point.
/// The cubic Bezier curves SHOULD be drawn using the current pen.
/// See section 2.3.5 for more drawing record types.
public struct EMR_POLYBEZIER {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let count: UInt32
    public let aPoints: [PointL]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_POLYBEZIER. This value is 0x00000002.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_POLYBEZIER else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x0000001C && size % 4 == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the bounding rectangle in logical units.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// Count (4 bytes): An unsigned integer that specifies the number of points in the aPoints array. This value MUST be one
        /// more than three times the number of curves to be drawn because each Bezier curve requires two control points and an
        /// endpoint, and the initial curve requires an additional starting point.
        /// Line width Device supports wideline Maximum points allowed
        /// 1 n/a 16K
        /// > 1 yes 16K
        /// > 1 no 1360
        /// Any extra points MUST be ignored.
        let count: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard count < 0x1FFFFFFC &&
                0x0000001C + count * 8 == size else {
            throw EmfReadError.corrupted
        }
        
        self.count = count
        
        /// aPoints (variable): An array of PointL objects ([MS-WMF] section 2.2.2.15) that specify the endpoints and control points
        /// of the Bezier curves in logical units.
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
