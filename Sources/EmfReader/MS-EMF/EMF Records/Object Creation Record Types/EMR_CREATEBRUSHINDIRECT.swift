//
//  EMR_CREATEBRUSHINDIRECT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.7.1 EMR_CREATEBRUSHINDIRECT Record
/// The EMR_CREATEBRUSHINDIRECT record defines a logical brush for graphics operations
/// See section 2.3.7 for more object creation record types.
public struct EMR_CREATEBRUSHINDIRECT {
    public let type: RecordType
    public let size: UInt32
    public let ihBrush: UInt32
    public let logBrush: LogBrushEx
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_CREATEBRUSHINDIRECT. This value is 0x00000018.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_CREATEBRUSHINDIRECT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes, of this record. This value is 0x00000018.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000018 else {
            throw EmfReadError.corrupted
        }
        
        /// ihBrush (4 bytes): An unsigned integer that specifies the index of the logical brush object in the EMF object table (section
        /// 3.1.1.1). This index is used to refer to the object, so it can be reused or modified.
        self.ihBrush = try dataStream.read(endianess: .littleEndian)
        
        /// LogBrush (12 bytes): A LogBrushEx object (section 2.2.12) that specifies the style, color, and pattern of the logical brush.
        /// The BrushStyle field in this object MUST be BS_SOLID, BS_HATCHED, or BS_NULL.
        self.logBrush = try LogBrushEx(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
