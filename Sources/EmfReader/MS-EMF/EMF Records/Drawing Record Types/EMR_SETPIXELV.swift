//
//  EMR_SETPIXELV.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.5.36 EMR_SETPIXELV Record
/// The EMR_SETPIXELV record defines the color of the pixel at the specified logical coordinates.
/// See section 2.3.5 for more drawing record types.
public struct EMR_SETPIXELV {
    public let type: RecordType
    public let size: UInt32
    public let pixel: PointL
    public let color: ColorRef
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETPIXELV. This value is 0x0000000F.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETPIXELV else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000014 else {
            throw EmfReadError.corrupted
        }
        
        /// Pixel (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15) that specifies the logical coordinates for the pixel.
        self.pixel = try PointL(dataStream: &dataStream)
        
        /// Color (4 bytes): A 32-bit ColorRef object ([MS-WMF] section 2.2.2.8) that specifies the pixel color.
        self.color = try ColorRef(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
