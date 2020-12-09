//
//  EMR_SETCOLORADJUSTMENT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.11.13 EMR_SETCOLORADJUSTMENT Record
/// The EMR_SETCOLORADJUSTMENT record specifies color adjustment properties in the playback device context.
/// Color adjustment values are used to adjust the input color of the source bitmap for graphics operations performed by
/// EMR_STRETCHBLT and EMR_STRETCHDIBITS records when STRETCH_HALFTONE mode is set from the StretchMode
/// enumeration (section 2.1.32).
/// The ColorAdjustment object specified by this record MUST be used in graphics operations that require a ColorAdjustment object,
/// until a different ColorAdjustment object is specified by another EMR_SETCOLORADJUSTMENT record, or until the object is
/// removed by a EMR_DELETEOBJECT record.
/// See section 2.3.11 for more state record types.
public struct EMR_SETCOLORADJUSTMENT {
    public let type: RecordType
    public let size: UInt32
    public let colorAdjustment: ColorAdjustment
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETCOLORADJUSTMENT. This value is 0x00000017.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETCOLORADJUSTMENT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000020 else {
            throw EmfReadError.corrupted
        }
        
        /// ColorAdjustment (24 bytes): A ColorAdjustment object (section 2.2.2) that specifies color adjustment values.
        self.colorAdjustment = try ColorAdjustment(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
