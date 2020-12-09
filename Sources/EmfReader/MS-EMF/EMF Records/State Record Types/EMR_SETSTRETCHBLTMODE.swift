//
//  EMR_SETSTRETCHBLTMODE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.11.24 EMR_SETSTRETCHBLTMODE Record
/// The EMR_SETSTRETCHBLTMODE record specifies bitmap stretch mode.
/// The stretching mode specifies how to combine rows or columns of a bitmap with existing pixels on the display device that the
/// EMR_STRETCHBLT record is processed on.
/// The STRETCH_ANDSCANS and STRETCH_ORSCANS modes are typically used to preserve foreground pixels in monochrome
/// bitmaps. The STRETCH_DELETESCANS mode is typically used to preserve color in color bitmaps.
/// The STRETCH_HALFTONE mode is slower and requires more processing of the source image than the other three modes, but
/// produces higher quality images. Also note that an EMR_SETBRUSHORGEX SHOULD be encountered after setting the
/// STRETCH_HALFTONE mode to avoid brush misalignment.
/// See section 2.3.11 for more state record types.
public struct EMR_SETSTRETCHBLTMODE {
    public let type: RecordType
    public let size: UInt32
    public let stretchMode: StretchMode
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETSTRETCHBLTMODE. This value is 0x00000015.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETSTRETCHBLTMODE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// StretchMode (4 bytes): An unsigned integer that specifies the stretch mode and MAY be in the StretchMode enumeration.
        self.stretchMode = try StretchMode(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
