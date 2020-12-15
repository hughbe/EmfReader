//
//  EMR_SETMAPPERFLAGS.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.11.20 EMR_SETMAPPERFLAGS Record
/// The EMR_SETMAPPERFLAGS record specifies parameters for the process of matching logical fonts to physical fonts, which is
/// performed by the font mapper.<88>
/// See section 2.3.11 for more state record types.
public struct EMR_SETMAPPERFLAGS {
    public let type: RecordType
    public let size: UInt32
    public let flags: Flags
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETMAPPERFLAGS. This value is 0x00000010.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETMAPPERFLAGS else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes. This value is 0x0000000C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// Flags (4 bytes): An unsigned integer that specifies parameters for the font matching process.
        self.flags = try Flags(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
    
    /// Flags (4 bytes): An unsigned integer that specifies parameters for the font matching process.
    public enum Flags: UInt32, DataStreamCreatable {
        /// 0x00000000 The font mapper is not limited to fonts that match the aspect ratio of the output device.
        case dontLimitToFontsThatMatchAspectRatio = 0x00000000
        
        /// 0x00000001 The font mapper SHOULD select only fonts that match the aspect ratio of the output device
        case selectOnlyFontsThatMatchAspectRatio = 0x00000001
    }
}
