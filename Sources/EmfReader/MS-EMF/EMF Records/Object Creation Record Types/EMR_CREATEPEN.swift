//
//  EMR_CREATEPEN.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.7.7 EMR_CREATEPEN Record
/// The EMR_CREATEPEN record defines a logical pen for graphics operations.
/// The logical pen object defined by this record can be selected into the playback device context by an EMR_SELECTOBJECT record
/// (section 2.3.8.5), which specifies the logical pen to use in subsequent graphics operations.
/// See section 2.3.7 for more object creation record types.
public struct EMR_CREATEPEN {
    public let type: RecordType
    public let size: UInt32
    public let ihPen: UInt32
    public let logPen: LogPen
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_CREATEPEN. This value is 0x00000026.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_CREATEPEN else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes, of this record. This value is 0x0000001C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000001C else {
            throw EmfReadError.corrupted
        }
        
        /// ihPen (4 bytes): An unsigned integer that specifies the index of the logical pen object in the EMF object table (section 3.1.1.1).
        /// This index MUST be saved so that this object can be reused or modified.
        self.ihPen = try dataStream.read(endianess: .littleEndian)
        
        /// LogPen (16 bytes): A LogPen object (section 2.2.19) that specifies the style, width, and color of the logical pen.
        self.logPen = try LogPen(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
