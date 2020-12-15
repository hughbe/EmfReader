//
//  EMR_SETCOLORSPACE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.8.7 EMR_SETCOLORSPACE Record
/// The EMR_SETCOLORSPACE record selects a logical color space into the playback device context.<78>
/// This object is either a LogColorSpace or LogColorSpaceW object ([MS-WMF] sections 2.2.2.11 and 2.2.2.12, respectively).
/// The color space specified by this record MUST be used in subsequent EMF drawing operations, until another
/// EMR_SETCOLORSPACE record changes the object or the object is deleted.
/// See section 2.3.8 for more object manipulation record types.
public struct EMR_SETCOLORSPACE {
    public let type: RecordType
    public let size: UInt32
    public let ihCS: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETCOLORSPACE. This value is 0x00000064.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETCOLORSPACE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes. This value is 0x0000000C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// ihCS (4 bytes): An unsigned integer that specifies the index of a logical color space object in the EMF object table
        /// (section 3.1.1.1).
        self.ihCS = try dataStream.read(endianess: .littleEndian)
        guard self.ihCS != 0 else {
            throw EmfReadError.corrupted
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
