//
//  EMR_POLYBEZIERTO.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.5.18 EMR_POLYBEZIERTO Record
/// The EMR_POLYBEZIERTO record specifies one or more Bezier curves based upon the current drawing position.
/// The Bezier curves SHOULD be drawn using the current pen.
/// See section 2.3.5 for more drawing record types.
public struct EMR_POLYBEZIERTO {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let count: UInt32
    public let aPoints: [PointL]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_POLYBEZIERTO. This value is 0x00000005.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_POLYBEZIERTO else {
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
        
        /// Count (4 bytes): An unsigned integer that specifies the number of points in the aPoints array. The first curve MUST be
        /// drawn from the current position to the third point by using the first two points as control points. For each subsequent
        /// curve, exactly three more points MUST be specified, and the ending point of the previous curve MUST be used as the
        /// starting point for the next.
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
        
        /// aPoints (variable): An array of PointL objects ([MS-WMF] section 2.2.2.15), which specify the endpoints and control
        /// points of the Bezier curves in logical units.
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
