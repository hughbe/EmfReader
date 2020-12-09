//
//  EMR_MOVETOEX.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.11.4 EMR_MOVETOEX Record
/// The EMR_MOVETOEX record specifies the coordinates of s new drawing position in logical units.
/// See section 2.3.11 for more state record types.
public struct EMR_MOVETOEX {
    public let type: RecordType
    public let size: UInt32
    public let offset: PointL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_MOVETOEX. This value is 0x0000001B.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_MOVETOEX else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 16 else {
            throw EmfReadError.corrupted
        }
        
        /// Offset (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15), which specifies coordinates of the new drawing position
        /// in logical units.
        self.offset = try PointL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
