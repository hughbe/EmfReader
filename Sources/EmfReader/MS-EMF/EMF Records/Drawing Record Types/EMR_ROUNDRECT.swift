//
//  EMR_ROUNDRECT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.5.35 EMR_ROUNDRECT Record
/// The EMR_ROUNDRECT record specifies a rectangle with rounded corners. The rectangle is outlined by using the current pen and
/// filled by using the current brush.
/// See section 2.3.5 for more drawing record types.
public struct EMR_ROUNDRECT {
    public let type: RecordType
    public let size: UInt32
    public let box: RectL
    public let corner: SizeL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_ROUNDRECT. This value is 0x0000002C.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_ROUNDRECT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000020 else {
            throw EmfReadError.corrupted
        }
        
        /// Box (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19), which specifies the inclusive-inclusive rectangle to draw.
        self.box = try RectL(dataStream: &dataStream)
        
        /// Corner (8 bytes): A 64-bit SizeL object ([MS-WMF] section 2.2.2.22), which specifies the width and height, in logical
        /// coordinates, of the ellipse used to draw the rounded corners.
        self.corner = try SizeL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
