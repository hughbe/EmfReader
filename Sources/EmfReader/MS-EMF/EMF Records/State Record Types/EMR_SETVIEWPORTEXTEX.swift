//
//  EMR_SETVIEWPORTEXTEX.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.11.28 EMR_SETVIEWPORTEXTEX Record
/// The EMR_SETVIEWPORTEXTEX record defines the viewport extent.
/// See section 2.3.11 for more state record types.
public struct EMR_SETVIEWPORTEXTEX {
    public let type: RecordType
    public let size: UInt32
    public let extent: SizeL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETVIEWPORTEXTEX. This value is 0x0000000B.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETVIEWPORTEXTEX else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 16 else {
            throw EmfReadError.corrupted
        }
        
        /// Extent (8 bytes): A SizeL object ([MS-WMF] section 2.2.2.22) that specifies the horizontal and vertical extents in device units.
        self.extent = try SizeL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
