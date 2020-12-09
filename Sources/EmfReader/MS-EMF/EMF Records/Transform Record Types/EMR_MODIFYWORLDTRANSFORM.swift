//
//  EMR_MODIFYWORLDTRANSFORM.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.12.1 EMR_MODIFYWORLDTRANSFORM Record
/// The EMR_MODIFYWORLDTRANSFORM record modifies the current world-space to page-space transform in the playback device
/// context.
/// For more information concerning transforms and coordinate spaces, see [MSDN-WRLDPGSPC]. See section 2.3.12 for more
/// transform record types.
public struct EMR_MODIFYWORLDTRANSFORM {
    public let type: RecordType
    public let size: UInt32
    public let xform: XForm
    public let modifyWorldTransformMode: ModifyWorldTransformMode
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_MODIFYWORLDTRANSFORM. This value is 0x00000024.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_MODIFYWORLDTRANSFORM else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes. This value is 0x00000024.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000024 else {
            throw EmfReadError.corrupted
        }
        
        /// Xform (24 bytes): An XForm object (section 2.2.28) that defines a two-dimensional linear transform in logical units.
        /// This transform is used according to the ModifyWorldTransformMode to define a new value for the world-space to
        /// page-space transform in the playback device context.
        self.xform = try XForm(dataStream: &dataStream)
        
        /// ModifyWorldTransformMode (4 bytes): An unsigned integer that specifies how the transform specified in Xform is used.
        /// This value is in the ModifyWorldTransformMode enumeration (section 2.1.24).
        self.modifyWorldTransformMode = try ModifyWorldTransformMode(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
