//
//  EMR_SETWINDOWEXTEX.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.11.30 EMR_SETWINDOWEXTEX Record
/// The EMR_SETWINDOWEXTEX record defines the window extent.
/// See section 2.3.11 for more state record types.
public struct EMR_SETWINDOWEXTEX {
    public let type: RecordType
    public let size: UInt32
    public let extent: SizeL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETWINDOWEXTEX. This value is 0x00000009.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETWINDOWEXTEX else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 16 else {
            throw EmfReadError.corrupted
        }
        
        /// Extent (8 bytes): A SizeL object ([MS-WMF] section 2.2.2.22) that specifies the horizontal and vertical extents in logical units.
        self.extent = try SizeL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
