//
//  EMR_GLSBOUNDEDRECORD.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.9.1 EMR_GLSBOUNDEDRECORD Record
/// The EMR_GLSBOUNDEDRECORD record specifies an OpenGL function with a bounding rectangle for output.
/// Fields not specified in this section are specified in section 2.3.1.
/// See section 2.3.9 for more OpenGL record types.
public struct EMR_GLSBOUNDEDRECORD {
    public let type: RecordType
    public let bounds: RectL
    public let size: UInt32
    public let cbData: UInt32
    public let data: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_GLSBOUNDEDRECORD. This value is 0x00000067.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_GLSBOUNDEDRECORD else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 28 && (size % 4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that defines a bounding rectangle in logical units, for output
        /// produced by executing the OpenGL function.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// cbData (4 bytes): An unsigned integer that specifies the size in bytes, of the Data field. If this value is zero, no data is
        /// attached to this record.
        self.cbData = try dataStream.read(endianess: .littleEndian)
        guard 28 + self.cbData <= size else {
            throw EmfReadError.corrupted
        }
        
        /// Data (variable, optional): An array of bytes that specifies data for the OpenGL function.
        self.data = try dataStream.readBytes(count: Int(self.cbData))
        
        /// AlignmentPadding (variable, optional): An array of up to 3 bytes that pads the record so that its total size is a multiple of
        /// 4 bytes. This field MUST be ignored.
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
