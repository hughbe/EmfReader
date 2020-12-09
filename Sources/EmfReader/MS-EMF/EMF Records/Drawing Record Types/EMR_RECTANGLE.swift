//
//  EMR_RECTANGLE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.34 EMR_RECTANGLE Record
/// The EMR_RECTANGLE record draws a rectangle. The rectangle is outlined by using the current pen and filled by using the current brush.
/// The current drawing position is neither used nor updated by this record.
/// If a PS_NULL pen is used, the dimensions of the rectangle are 1 pixel less in height and 1 pixel less in width.
/// See section 2.3.5 for more drawing record types.
public struct EMR_RECTANGLE {
    public let type: RecordType
    public let size: UInt32
    public let box: RectL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_RECTANGLE. This value is 0x0000002B.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_RECTANGLE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 24 else {
            throw EmfReadError.corrupted
        }
        
        /// Box (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19), which specifies the inclusive-inclusive rectangle to draw.
        self.box = try RectL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
