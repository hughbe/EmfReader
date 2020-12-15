//
//  EMR_INVERTRGN.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.11.3 EMR_INVERTRGN Record
/// The EMR_INVERTRGN record inverts the colors in the specified region. The current clipping regions used by this record are maintained
/// in a Regions state element (section 3.1.1.2.1) in the playback device context (section 3.1).
/// If the output surface is monochrome, this record SHOULD convert white pixels to black and black pixels to white. For color output,
/// the inversion is dependent on the type of technology used to generate the colors.
/// See section 2.3.5 for more drawing record types.
public struct EMR_INVERTRGN {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let rgnDataSize: UInt32
    public let rgnData: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_INVERTRGN. This value is 0x00000049.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_INVERTRGN else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x0000001C && size % 4 == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the destination bounding rectangle in logical
        /// coordinates. If the intersection of this rectangle with the current clipping region is empty, this record has no effect.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// RgnDataSize (4 bytes): An unsigned integer that specifies the size of region data in bytes.
        let rgnDataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard rgnDataSize < 0xFFFFFFE0 &&
                0x0000001C + rgnDataSize <= size else {
            throw EmfReadError.corrupted
        }
        
        self.rgnDataSize = rgnDataSize
        
        /// RgnData (variable): A RgnDataSize length array of bytes that specifies the output region in a RegionData object (section
        /// 2.2.24). The bounds specified by the RegionDataHeader field of this object MAY<65> be used as the bounding region
        /// when this record is processed.
        self.rgnData = try dataStream.readBytes(count: Int(self.rgnDataSize))
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
