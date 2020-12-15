//
//  EMR_INTERSECTCLIPRECT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.2.3 EMR_INTERSECTCLIPRECT Record
/// The EMR_INTERSECTCLIPRECT record specifies a new clipping region from the intersection of the current clipping region and the
/// specified rectangle.
/// Fields not specified in this section are specified in section 2.3.2.
/// The lower and right edges of the specified rectangle are excluded from the clipping region.
/// See section 2.3.2 for more clipping record types.
public struct EMR_INTERSECTCLIPRECT {
    public let type: RecordType
    public let size: UInt32
    public let clip: RectL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_INTERSECTCLIPRECT. This value is 0x0000001E.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_INTERSECTCLIPRECT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000018 else {
            throw EmfReadError.corrupted
        }
        
        /// Clip (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the rectangle in logical units.
        self.clip = try RectL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
