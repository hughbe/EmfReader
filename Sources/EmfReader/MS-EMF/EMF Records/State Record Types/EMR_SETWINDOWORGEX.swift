//
//  EMR_SETWINDOWORGEX.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.11.31 EMR_SETWINDOWORGEX Record
/// The EMR_SETWINDOWORGEX record defines the window origin
/// See section 2.3.11 for more state record types.
public struct EMR_SETWINDOWORGEX {
    public let type: RecordType
    public let size: UInt32
    public let origin: PointL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETWINDOWORGEX. This value is 0x0000000A.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETWINDOWORGEX else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000010 else {
            throw EmfReadError.corrupted
        }
        
        /// Origin (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15) that specifies the window horizontal and vertical origin in
        /// logical units.
        self.origin = try PointL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
