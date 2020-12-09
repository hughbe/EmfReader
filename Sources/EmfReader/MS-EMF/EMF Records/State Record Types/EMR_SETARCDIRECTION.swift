//
//  EMR_SETARCDIRECTION.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.11.9 EMR_SETARCDIRECTION Record
/// The EMR_SETARCDIRECTION record specifies the drawing direction to be used for arc and rectangle output.
/// The arc direction affects the direction in which the following records draw:
///  EMR_ARC (section 2.3.5.2)
///  EMR_ARCTO (section 2.3.5.3)
///  EMR_CHORD (section 2.3.5.4)
///  EMR_ELLIPSE (section 2.3.5.5)
///  EMR_PIE (section 2.3.5.15)
///  EMR_RECTANGLE (section 2.3.5.34)
///  EMR_ROUNDRECT (section 2.3.5.35)
/// See section 2.3.11 for more state record types.
public struct EMR_SETARCDIRECTION {
    public let type: RecordType
    public let size: UInt32
    public let arcDirection: ArcDirection
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETARCDIRECTION. This value is 0x00000039.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETARCDIRECTION else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes. This value is 0x0000000C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// ArcDirection (4 bytes): An unsigned integer that specifies the arc direction. This value is in the ArcDirection enumeration
        /// (section 2.1.2). The default direction is counterclockwise.
        self.arcDirection = try ArcDirection(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
