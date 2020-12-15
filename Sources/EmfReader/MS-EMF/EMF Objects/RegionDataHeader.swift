//
//  RegionDataHeader.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.2.25 RegionDataHeader Object
/// The RegionDataHeader object defines the properties of a RegionData (section 2.2.24) object.
public struct RegionDataHeader {
    public let size: UInt32
    public let type: UInt32
    public let countRects: UInt32
    public let rgnSize: UInt32
    public let bounds: RectL
    
    public init(dataStream: inout DataStream) throws {
        /// Size (4 bytes): An unsigned integer that specifies the size of this object in bytes. This value is 0x00000020.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000020 else {
            throw EmfReadError.corrupted
        }
        
        /// Type (4 bytes): An unsigned integer that specifies the region type. This value is 0x00000001.
        self.type = try dataStream.read(endianess: .littleEndian)
        
        /// CountRects (4 bytes): An unsigned integer that specifies the number of rectangles in this region.
        self.countRects = try dataStream.read(endianess: .littleEndian)
        
        /// RgnSize (4 bytes): An unsigned integer that specifies the size of the buffer of rectangles in bytes.
        self.rgnSize = try dataStream.read(endianess: .littleEndian)
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19), which specifies the bounds of the region.
        self.bounds = try RectL(dataStream: &dataStream)
    }
}
