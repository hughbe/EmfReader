//
//  EMR_SETBKCOLOR.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.11.10 EMR_SETBKCOLOR Record
/// The EMR_SETBKCOLOR record specifies the background color for text output.
/// See section 2.3.11 for more state record types.
public struct EMR_SETBKCOLOR {
    public let type: RecordType
    public let size: UInt32
    public let color: ColorRef
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETBKCOLOR. This value is 0x00000019.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETBKCOLOR else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// Color (4 bytes): A ColorRef object ([MS-WMF] section 2.2.2.8), which specifies the background color value.
        self.color = try ColorRef(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
