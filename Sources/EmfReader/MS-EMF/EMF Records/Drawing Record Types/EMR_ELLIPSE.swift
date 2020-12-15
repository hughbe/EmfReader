//
//  EMR_ELLIPSE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.5.5 EMR_ELLIPSE Record
/// The EMR_ELLIPSE record specifies an ellipse. The center of the ellipse is the center of the specified bounding rectangle. The ellipse
/// is outlined by using the current pen and is filled by using the current brush.
/// See section 2.3.5 for more drawing record types.
public struct EMR_ELLIPSE {
    public let type: RecordType
    public let size: UInt32
    public let box: RectL
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_ELLIPSE. This value is 0x0000002A.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_ELLIPSE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000018 else {
            throw EmfReadError.corrupted
        }
        
        /// Box (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19), which specifies the inclusive-inclusive bounding rectangle in
        /// logical units.
        self.box = try RectL(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
