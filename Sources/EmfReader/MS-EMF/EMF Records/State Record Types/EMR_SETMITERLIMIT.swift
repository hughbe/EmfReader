//
//  EMR_SETMITERLIMIT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.11.21 EMR_SETMITERLIMIT Record
/// The EMR_SETMITERLIMIT record specifies the limit for the length of miter joins.
/// See section 2.3.11 for more state record types.
public struct EMR_SETMITERLIMIT {
    public let type: RecordType
    public let size: UInt32
    public let miterLimit: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETMITERLIMIT. This value is 0x0000003A.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETMITERLIMIT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// MiterLimit (4 bytes): An unsigned integer that specifies the new miter length limit.<89>
        self.miterLimit = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
