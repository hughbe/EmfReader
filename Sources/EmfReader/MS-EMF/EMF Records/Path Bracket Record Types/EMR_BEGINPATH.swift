//
//  EMR_BEGINPATH.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.10 Path Bracket Record Types
/// EMR_BEGINPATH This record opens path bracket construction.
/// Once path bracket construction is open, an application can begin specifying records to define the points that lie in the path.
/// Path bracket construction MUST be closed by an EMR_ABORTPATH or EMR_ENDPATH record.
/// When an application processes an EMR_BEGINPATH record, path bracket construction MUST NOT be open.
public struct EMR_BEGINPATH {
    public let type: RecordType
    public let size: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_BEGINPATH. This value is 0x0000003B.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_BEGINPATH else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of the record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000008 else {
            throw EmfReadError.corrupted
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
