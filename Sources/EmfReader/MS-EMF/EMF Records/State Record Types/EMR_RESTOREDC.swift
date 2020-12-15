//
//  EMR_RESTOREDC.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.11.6 EMR_RESTOREDC Record
/// The EMR_RESTOREDC record restores the playback device context to the specified state. The playback device context is restored
/// by popping state information off a stack that was created by a prior EMR_SAVEDC record (section 2.3.11).
/// See section 2.3.11 for more state record types.
public struct EMR_RESTOREDC {
    public let type: RecordType
    public let size: UInt32
    public let savedDC: Int32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_RESTOREDC. This value is 0x00000022.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_RESTOREDC else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of the record in bytes. This value is 0x0000000C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// SavedDC (4 bytes): A signed integer that specifies the saved state to restore relative to the current state. This value MUST
        /// be negative; –1 represents the state that was most recently saved on the stack, –2 the one before that, etc.
        self.savedDC = try dataStream.read(endianess: .littleEndian)
        guard self.savedDC < 0 else {
            throw EmfReadError.corrupted
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
