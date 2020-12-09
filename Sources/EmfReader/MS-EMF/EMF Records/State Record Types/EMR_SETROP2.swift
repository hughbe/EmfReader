//
//  EMR_SETROP2.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.11.23 EMR_SETROP2 Record
/// The EMR_SETROP2 record defines a binary raster operation mode.
/// See section 2.3.11 for more state record types.
public struct EMR_SETROP2 {
    public let type: RecordType
    public let size: UInt32
    public let rop2Mode: BinaryRasterOperation
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETROP2. This value is 0x00000014.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETROP2 else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// ROP2Mode (4 bytes): An unsigned integer that specifies the raster operation mode and is in the Binary Raster Op
        /// enumeration ([MS-WMF] section 2.1.1.2).
        let rop2ModeRaw: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard let rop2Mode = BinaryRasterOperation(rawValue: UInt16(rop2ModeRaw)) else {
            throw EmfReadError.corrupted
        }
        
        self.rop2Mode = rop2Mode
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
