//
//  EMR_SETBKMODE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.11.11 EMR_SETBKMODE Record
/// The EMR_SETBKMODE record specifies the background mix mode to use with text, hatched brushes, and pens that are not solid lines.
/// See section 2.3.11 for more state record types.
public struct EMR_SETBKMODE {
    public let type: RecordType
    public let size: UInt32
    public let backgroundMode: BackgroundMode
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETBKMODE. This value is 0x00000012.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETBKMODE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// BackgroundMode (4 bytes): An unsigned integer that specifies the background mode, from the BackgroundMode
        /// enumeration (section 2.1.4).
        self.backgroundMode = try BackgroundMode(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
