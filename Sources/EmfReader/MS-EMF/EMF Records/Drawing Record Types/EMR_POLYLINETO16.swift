//
//  EMR_POLYLINETO16.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.27 EMR_POLYLINETO16 Record
/// The EMR_POLYLINETO16 record specifies one or more straight lines based upon the current drawing position.
/// A line is drawn from the current drawing position to the first point specified by the aPoints field by using the current pen. For each
/// additional line, drawing is performed from the ending point of the previous line to the next point specified by aPoints.
/// See section 2.3.5 for more drawing record types.
public struct EMR_POLYLINETO16 {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let count: UInt32
    public let aPoints: [PointS]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_POLYLINETO16. This value is 0x00000059.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_POLYLINETO16 else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 28 && (size %  4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19, which specifies the bounding rectangle in logical units.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// Count (4 bytes): An unsigned integer that specifies the number of points.
        self.count = try dataStream.read(endianess: .littleEndian)
        guard 28 + self.count * 4 == size else {
            throw EmfReadError.corrupted
        }
        
        /// aPoints (variable): A Count length array of PointS objects ([MS-WMF] section 2.2.2.16, which specifies the array of points.
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
