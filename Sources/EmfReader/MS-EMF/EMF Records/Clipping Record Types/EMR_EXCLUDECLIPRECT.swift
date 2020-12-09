//
//  EMR_EXCLUDECLIPRECT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.2.1 EMR_EXCLUDECLIPRECT Record
/// The EMR_EXCLUDECLIPRECT record excludes the specified rectangle from the current clipping region.
/// Fields not specified in this section are specified in section 2.3.2.
/// The result of the intersection is saved as the new current clipping region. The lower and right edges of the specified rectangle MUST
/// NOT be excluded from clipping.
/// See section 2.3.2 for more clipping record types.
public struct EMR_EXCLUDECLIPRECT {
    public let type: RecordType
    public let size: UInt32
    public let clip: RectL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_EXCLUDECLIPRECT. This value is 0x0000001D.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_EXCLUDECLIPRECT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 24 else {
            throw EmfReadError.corrupted
        }
        
        /// Clip (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies a rectangle in logical units.
        self.clip = try RectL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
