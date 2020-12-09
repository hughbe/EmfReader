//
//  EMR_EXTFLOODFILL.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.6 EMR_EXTFLOODFILL Record
/// The EMR_EXTFLOODFILL record fills an area of the display surface with the current brush.
/// See section 2.3.5 for more drawing record types.
public struct EMR_EXTFLOODFILL {
    public let type: RecordType
    public let size: UInt32
    public let start: PointL
    public let color: ColorRef
    public let floodFillMode: FloodFill
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_EXTFLOODFILL. This value is 0x00000035.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_EXTFLOODFILL else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 24 else {
            throw EmfReadError.corrupted
        }
        
        /// Start (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15), which specifies the coordinates, in logical units, where filling
        /// begins.
        self.start = try PointL(dataStream: &dataStream)
        
        /// Color (4 bytes): A ColorRef object ([MS-WMF] section 2.2.2.8), which is used with the FloodFillMode to determine the
        /// area to fill.
        self.color = try ColorRef(dataStream: &dataStream)
        
        /// FloodFillMode (4 bytes): An unsigned integer that specifies how to use the Color value to determine the area for the
        /// flood fill operation. This value is in the FloodFill enumeration (section 2.1.13).
        self.floodFillMode = try FloodFill(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
