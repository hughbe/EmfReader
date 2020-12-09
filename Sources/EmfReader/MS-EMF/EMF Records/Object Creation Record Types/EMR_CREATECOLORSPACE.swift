//
//  EMR_CREATECOLORSPACE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.7.2 EMR_CREATECOLORSPACE Record
/// The EMR_CREATECOLORSPACE record creates a logical color space object from a color profile with a name consisting of ASCII
/// characters.<72>
/// Fields not specified in this section are specified in section 2.3.7.
/// The logical color space object defined by this record can be selected into the playback device context by an EMR_SETCOLORSPACE
/// record (section 2.3.8.7), which defines the logical color space to use in subsequent graphics operations.
/// See section 2.3.7 for more object creation record types.
public struct EMR_CREATECOLORSPACE {
    public let type: RecordType
    public let size: UInt32
    public let ihCS: UInt32
    public let lcs: LogColorSpace
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_CREATECOLORSPACE. This value is 0x00000063.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_CREATECOLORSPACE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes, of this record. This value is 0x0000001C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size >= 76 else {
            throw EmfReadError.corrupted
        }
        
        /// ihCS (4 bytes): An unsigned integer that specifies the index of the logical color space object in the EMF object table
        /// (section 3.1.1.1). This index MUST be saved so that this object can be reused or modified.
        self.ihCS = try dataStream.read(endianess: .littleEndian)
        
        /// lcs (variable): A LogColorSpace object ([MS-WMF] section 2.2.2.11), which can specify the name of a color profile in
        /// ASCII characters.
        self.lcs = try LogColorSpace(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
