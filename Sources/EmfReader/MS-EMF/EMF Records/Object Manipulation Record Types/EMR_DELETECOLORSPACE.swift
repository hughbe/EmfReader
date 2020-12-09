//
//  EMR_DELETECOLORSPACE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.8.2 EMR_DELETECOLORSPACE Record
/// The EMR_DELETECOLORSPACE record deletes a logical color space object.<76>
/// The color space is specified by either a LogColorSpace or LogColorSpaceW object ([MS-WMF] sections 2.2.2.11 and 2.2.2.12,
/// respectively). If the deleted color space is currently selected into the playback device context, the default object MUST be restored.
/// An EMR_DELETEOBJECT record (section 2.3.8.3) SHOULD be used instead of this record to delete a logical color space object.
/// See section 2.3.8 for more object manipulation record types.
public struct EMR_DELETECOLORSPACE {
    public let type: RecordType
    public let size: UInt32
    public let ihCS: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_DELETECOLORSPACE. This value is 0x00000065.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_DELETECOLORSPACE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// ihCS (4 bytes): An unsigned integer that specifies the index of a logical color space object in the EMF object table (section 3.1.1.1).
        self.ihCS = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
