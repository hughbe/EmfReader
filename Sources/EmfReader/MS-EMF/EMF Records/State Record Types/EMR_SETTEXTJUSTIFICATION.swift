//
//  EMR_SETTEXTJUSTIFICATION.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.11.27 EMR_SETTEXTJUSTIFICATION Record
/// The EMR_SETTEXTJUSTIFICATION record specifies the amount of extra space to add to break characters for text justification.<90>
/// See section 2.3.11 for more state record types.
public struct EMR_SETTEXTJUSTIFICATION {
    public let type: RecordType
    public let size: UInt32
    public let nBreakExtra: Int32
    public let nBreakCount: Int32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETTEXTJUSTIFICATION. This value is 0x00000078.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETTEXTJUSTIFICATION else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 20 else {
            throw EmfReadError.corrupted
        }
        
        /// nBreakExtra (4 bytes): A signed integer that specifies the total amount of extra space to add in logical units.
        self.nBreakExtra = try dataStream.read(endianess: .littleEndian)
        
        /// nBreakCount (4 bytes): A signed integer that specifies the number of break characters.
        self.nBreakCount = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
