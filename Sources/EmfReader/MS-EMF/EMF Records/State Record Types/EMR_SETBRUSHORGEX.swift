//
//  EMR_SETBRUSHORGEX.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.11.12 EMR_SETBRUSHORGEX Record
/// The EMR_SETBRUSHORGEX record specifies the origin of the current brush.
/// See section 2.3.11 for more state record types.
public struct EMR_SETBRUSHORGEX {
    public let type: RecordType
    public let size: UInt32
    public let origin: PointL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETBRUSHORGEX. This value is 0x0000000D.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETBRUSHORGEX else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 16 else {
            throw EmfReadError.corrupted
        }
        
        /// Origin (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15), which specifies the horizontal and vertical origin of the
        /// current brush in logical units.
        self.origin = try PointL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
