//
//  EMR_SETVIEWPORTORGEX.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.11.29 EMR_SETVIEWPORTORGEX Record
/// The EMR_SETVIEWPORTORGEX record defines the viewport origin
/// See section 2.3.11 for more state record types.
public struct EMR_SETVIEWPORTORGEX {
    public let type: RecordType
    public let size: UInt32
    public let origin: PointL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETVIEWPORTORGEX. This value is 0x0000000C.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETVIEWPORTORGEX else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 16 else {
            throw EmfReadError.corrupted
        }
        
        /// Origin (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15) that specifies the window horizontal and vertical origin in
        /// device units.
        self.origin = try PointL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
