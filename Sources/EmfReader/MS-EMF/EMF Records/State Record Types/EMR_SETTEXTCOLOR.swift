//
//  EMR_SETTEXTCOLOR.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.11.26 EMR_SETTEXTCOLOR Record
/// The EMR_SETTEXTCOLOR record defines the current text foreground color.
/// See section 2.3.11 for more state record types.
public struct EMR_SETTEXTCOLOR {
    public let type: RecordType
    public let size: UInt32
    public let color: ColorRef
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETTEXTCOLOR. This value is 0x00000018.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETTEXTCOLOR else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// Color (4 bytes): A ColorRef object ([MS-WMF] section 2.2.2.8) that specifies the text foreground color.
        self.color = try ColorRef(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
