//
//  EMR_CREATEPALETTE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.7.6 EMR_CREATEPALETTE Record
/// The EMR_CREATEPALETTE record defines a logical palette for graphics operations.
/// Fields not specified in this section are specified in section 2.3.7.
/// See section 2.3.7 for more object creation record types.
public struct EMR_CREATEPALETTE {
    public let type: RecordType
    public let size: UInt32
    public let ihPal: UInt32
    public let logPalette: LogPalette
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_CREATEPALETTE. This value is 0x00000031.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_CREATEPALETTE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes, of this record.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size >= 16 else {
            throw EmfReadError.corrupted
        }
        
        /// ihPal (4 bytes): An unsigned integer that specifies the index of the logical palette object in the EMF object table (section
        /// 3.1.1.1). This index MUST be saved so that this object can be reused or modified.
        self.ihPal = try dataStream.read(endianess: .littleEndian)
        
        /// LogPalette (variable): A LogPalette object (section 2.2.17). The Version field of this object MUST be set to 0x0300.
        /// If the NumberOfEntries value in this object is zero, processing of this record MUST fail.
        self.logPalette = try LogPalette(dataStream: &dataStream)
        guard self.logPalette.numberOfEntries > 0 else {
            throw EmfReadError.corrupted
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
