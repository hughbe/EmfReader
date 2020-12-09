//
//  EMR_CHORD.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.4 EMR_CHORD Record
/// The EMR_CHORD record specifies a chord, which is a region bounded by the intersection of an ellipse and a line segment, called a
/// secant. The chord is outlined by using the current pen and filled by using the current brush.
/// The curve of the chord is defined by an ellipse that fits the specified bounding rectangle. The curve begins at the point where the
/// ellipse intersects the first radial and extends counterclockwise to the point where the ellipse intersects the second radial. The chord
/// is closed by drawing a line from the intersection of the first radial and the curve to the intersection of the second radial and the curve.
/// If the starting point and ending point of the curve are the same, a complete ellipse is drawn.
/// The current drawing position is neither used nor updated by processing this record.
/// See section 2.3.5 for more drawing record types.
public struct EMR_CHORD {
    public let type: RecordType
    public let size: UInt32
    public let box: RectL
    public let start: PointL
    public let end: PointL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_CHORD. This value is 0x0000002E.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_CHORD else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 40 else {
            throw EmfReadError.corrupted
        }
        
        /// Box (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19), which specifies the inclusive-inclusive bounding rectangle in logical units.
        self.box = try RectL(dataStream: &dataStream)
        
        /// Start (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15), which specifies the coordinates, in logical units, of the
        /// endpoint of the radial defining the beginning of the chord.
        self.start = try PointL(dataStream: &dataStream)
        
        /// End (8 bytes): A PointL object that specifies the logical coordinates of the endpoint of the radial defining the end of the chord.
        self.end = try PointL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
