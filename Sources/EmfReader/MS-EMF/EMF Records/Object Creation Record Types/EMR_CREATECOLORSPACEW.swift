//
//  EMR_CREATECOLORSPACEW.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.7.3 EMR_CREATECOLORSPACEW Record
/// The EMR_CREATECOLORSPACEW record creates a logical color space object from a color profile with a name consisting of Unicode
/// characters.<73>
/// Fields not specified in this section are specified in section 2.3.7.
/// The logical color space object defined by this record can be selected into the playback device context by an EMR_SETCOLORSPACE
/// record (section 2.3.8.7), which defines the logical color spaceto use in subsequent graphics operations.
/// See section 2.3.7 for more object creation record types.
public struct EMR_CREATECOLORSPACEW {
    public let type: RecordType
    public let size: UInt32
    public let ihCS: UInt32
    public let lcs: LogColorSpaceW
    public let cbData: UInt32
    public let data: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_CREATECOLORSPACEW. This value is 0x0000007A.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_CREATECOLORSPACEW else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes, of this record. This value is 0x0000001C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size >= 80 else {
            throw EmfReadError.corrupted
        }
        
        /// ihCS (4 bytes): An unsigned integer that specifies the index of the logical color space object in the EMF object table
        /// (section 3.1.1.1). This index MUST be saved so that this object can be reused or modified.
        self.ihCS = try dataStream.read(endianess: .littleEndian)
        
        /// lcs (variable): A LogColorSpaceW object ([MS-WMF] section 2.2.2.12) that can specify the name of a color profile in
        /// Unicode UTF16-LE characters.
        self.lcs = try LogColorSpaceW(dataStream: &dataStream)
        
        /// cbData (4 bytes): An unsigned integer that specifies the size in bytes, of the Data field.
        self.cbData = try dataStream.read(endianess: .littleEndian)
        
        /// Data (variable, optional): An array of bytes that specifies color profile data.
        self.data = try dataStream.readBytes(count: Int(self.cbData))
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
