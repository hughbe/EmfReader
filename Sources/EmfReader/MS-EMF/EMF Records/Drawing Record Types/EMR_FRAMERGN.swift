//
//  EMR_FRAMERGN.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.11 EMR_FRAMERGN Record
/// The EMR_FRAMERGN record draws a border around the specified region using the specified brush.
/// The current clipping regions used by this record are maintained in a Regions state element (section 3.1.1.2.1) in the playback device
/// context (section 3.1).
/// See section 2.3.5 for more drawing record types.
public struct EMR_FRAMERGN {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let rgnDataSize: UInt32
    public let ihBrush: UInt32
    public let width: Int32
    public let height: Int32
    public let rgnData: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_FRAMERGN. This value is 0x00000048.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_FRAMERGN else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size >= 40 else {
            throw EmfReadError.corrupted
        }
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the destination bounding rectangle in logical
        /// coordinates. If the intersection of this rectangle with the current clipping region is empty, this record has no effect.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// RgnDataSize (4 bytes): An unsigned integer that specifies the size of region data in bytes.
        self.rgnDataSize = try dataStream.read(endianess: .littleEndian)
        guard self.rgnDataSize <= self.size - 40 else {
            throw EmfReadError.corrupted
        }
        
        /// ihBrush (4 bytes): An unsigned integer that specifies the index of the brush in the EMF object table (section 3.1.1.1) for filling
        /// the region.
        self.ihBrush = try dataStream.read(endianess: .littleEndian)
        
        /// Width (4 bytes): A signed integer that specifies the width of the vertical brush stroke, in logical units.
        self.width = try dataStream.read(endianess: .littleEndian)
        
        /// Height (4 bytes): A signed integer that specifies the height of the horizontal brush stroke, in logical units.
        self.height = try dataStream.read(endianess: .littleEndian)
        
        /// RgnData (variable): A RgnDataSize length array of bytes that specifies the output region in a RegionData object (section
        /// 2.2.24). The bounds specified by the RegionDataHeader field of this object MAY<65> be used as the bounding region
        /// when this record is processed.
        self.rgnData = try dataStream.readBytes(count: Int(self.rgnDataSize))
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
