//
//  EMR_PAINTRGN.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.14 EMR_PAINTRGN Record
/// The EMR_PAINTRGN record paints the specified region by using the current brush. The current clipping regions used by this record
/// are maintained in a Regions state element (section 3.1.1.2.1) in the playback device context (section 3.1).
/// See section 2.3.5 for more drawing record types.
public struct EMR_PAINTRGN {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let rgnDataSize: UInt32
    public let rgnData: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_PAINTRGN. This value is 0x0000004A.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_PAINTRGN else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size >= 28 else {
            throw EmfReadError.corrupted
        }
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the destination bounding rectangle in logical
        /// coordinates. If the intersection of this rectangle with the current clipping region is empty, this record has no effect.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// RgnDataSize (4 bytes): An unsigned integer that specifies the size of region data in bytes.
        self.rgnDataSize = try dataStream.read(endianess: .littleEndian)
        guard self.rgnDataSize <= self.size - 28 else {
            throw EmfReadError.corrupted
        }
        
        /// RgnData (variable): A RgnDataSize length array of bytes that specifies the output region in a RegionData object (section
        /// 2.2.24). The bounds specified by the RegionDataHeader field of this object MAY<65> be used as the bounding region
        /// when this record is processed.
        self.rgnData = try dataStream.readBytes(count: Int(self.rgnDataSize))
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
