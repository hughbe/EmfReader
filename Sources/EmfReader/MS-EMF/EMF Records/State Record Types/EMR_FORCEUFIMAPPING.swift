//
//  EMR_FORCEUFIMAPPING.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.11.2 EMR_FORCEUFIMAPPING Record
/// The EMR_FORCEUFIMAPPING record forces the font mapper to match fonts based on their UniversalFontId in preference to their
/// LogFont (section 2.2.13) information.
/// See section 2.3.11 for more state record types.
public struct EMR_FORCEUFIMAPPING {
    public let type: RecordType
    public let size: UInt32
    public let ufi: UniversalFontId
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_FORCEUFIMAPPING. This value is 0x0000006D.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_FORCEUFIMAPPING else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000010 else {
            throw EmfReadError.corrupted
        }
        
        /// ufi (8 bytes): The font id to use, specified as a UniversalFontId (section 2.2.27).
        self.ufi = try UniversalFontId(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
