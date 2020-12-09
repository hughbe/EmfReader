//
//  EMR_SETWORLDTRANSFORM.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.12.2 EMR_SETWORLDTRANSFORM Record
/// The EMR_SETWORLDTRANSFORM record specifies a transform for the current world-space to pagespace transform in the
/// playback device context.
/// See section 2.3.11 for more state record types.
public struct EMR_SETWORLDTRANSFORM {
    public let type: RecordType
    public let size: UInt32
    public let xform: XForm
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETWORLDTRANSFORM. This value is 0x00000023.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETWORLDTRANSFORM else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes. This value is 0x00000020.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000020 else {
            throw EmfReadError.corrupted
        }
        
        /// Xform (24 bytes): An XForm object (section 2.2.28) that specifies a two-dimensional linear transform in logical units.
        /// This transform defines a new value for the current world-space to pagespace transform.
        self.xform = try XForm(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
