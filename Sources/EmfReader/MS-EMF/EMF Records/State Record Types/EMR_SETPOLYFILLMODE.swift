//
//  EMR_SETPOLYFILLMODE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF]2.3.11.22 EMR_SETPOLYFILLMODE Record
/// The EMR_SETPOLYFILLMODE record defines polygon fill mode.
/// In general, the modes differ only in cases where a complex, overlapping polygon MUST be filled; for example, a five-sided polygon
/// that forms a five-pointed star with a pentagon in the center. In such cases, ALTERNATE mode SHOULD fill every other enclosed
/// region within the polygon (the points of the star), but WINDING mode SHOULD fill all regions (the points of the star and the pentagon).
/// When the fill mode is ALTERNATE, the area between odd-numbered and even-numbered polygon sides on each scan line SHOULD
/// be filled. That is, the area between the first and second side SHOULD be filled, and between the third and fourth side, and so on.
/// When the fill mode is WINDING, any region that has a nonzero winding value SHOULD be filled. The winding value is the number of
/// times a pen used to draw the polygon would go around the region. The direction of each edge of the polygon is significant.
/// See section 2.3.11 for more state record types.
public struct EMR_SETPOLYFILLMODE {
    public let type: RecordType
    public let size: UInt32
    public let polygonFillMode: PolygonFillMode
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETPOLYFILLMODE. This value is 0x00000013.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETPOLYFILLMODE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// PolygonFillMode (4 bytes): An unsigned integer that specifies the polygon fill mode and is in the PolygonFillMode
        /// (section 2.1.27) enumeration.
        self.polygonFillMode = try PolygonFillMode(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
