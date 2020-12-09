//
//  EMR_PIXELFORMAT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.11.5 EMR_PIXELFORMAT Record
/// The EMR_PIXELFORMAT record specifies the pixel format to use for graphics operations.<83>
/// See section 2.3.11 for more state record types.
public struct EMR_PIXELFORMAT {
    public let type: RecordType
    public let size: UInt32
    public let pfd: PixelFormatDescriptor
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_PIXELFORMAT. This value is 0x00000068.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_PIXELFORMAT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 48 else {
            throw EmfReadError.corrupted
        }
        
        /// pfd (40 bytes): A PixelFormatDescriptor object (section 2.2.22) that specifies pixel format data.
        self.pfd = try PixelFormatDescriptor(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
