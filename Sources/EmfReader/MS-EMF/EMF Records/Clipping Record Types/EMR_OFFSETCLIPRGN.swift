//
//  EMR_OFFSETCLIPRGN.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.2.4 EMR_OFFSETCLIPRGN Record
/// The EMR_OFFSETCLIPRGN record moves the current clipping region in the playback device context by the specified offsets.
/// Fields not specified in this section are specified in section 2.3.2.
/// See section 2.3.2 for more clipping record types.
public struct EMR_OFFSETCLIPRGN {
    public let type: RecordType
    public let size: UInt32
    public let offset: PointL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_OFFSETCLIPRGN. This value is 0x0000001A.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_OFFSETCLIPRGN else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000010 else {
            throw EmfReadError.corrupted
        }
        
        /// Offset (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15) that specifies the horizontal and vertical offsets in logical units.
        self.offset = try PointL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
