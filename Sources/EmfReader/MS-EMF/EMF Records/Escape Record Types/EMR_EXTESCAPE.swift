//
//  EMR_EXTESCAPE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.6.2 EMR_EXTESCAPE Record
/// The EMR_EXTESCAPE record passes arbitrary information to a printer driver. The intent is that the information does not result in
/// drawing being done.
/// Fields not specified in this section are specified in section 2.3.6.
/// See section 2.3.5 for more drawing record types.
public struct EMR_EXTESCAPE {
    public let type: RecordType
    public let size: UInt32
    public let iEscape: MetafileEscapes
    public let cjIn: UInt32
    public let data: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type from the EmrComment enumeration (section 2.1.10).
        /// It MUST be EMR_EXTESCAPE, which is 0x0000006A.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_EXTESCAPE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 20 && (size % 4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// iEscape (4 bytes): An unsigned integer that specifies the printer driver escape to execute. This MUST be one of the values
        /// in the MetafileEscapes enumeration ([MS-WMF] section 2.1.1.17).
        let iEscapeRaw: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard let iEscape = MetafileEscapes(rawValue: UInt16(iEscapeRaw)) else {
            throw EmfReadError.corrupted
        }
        
        self.iEscape = iEscape
        
        /// cjIn (4 bytes): An unsigned integer specifying the number of bytes to pass to the printer driver.
        self.cjIn = try dataStream.read(endianess: .littleEndian)
        
        /// Data (variable): The data to pass to the printer driver. There MUST be cjIn bytes available.
        self.data = try dataStream.readBytes(count: Int(self.cjIn))
        
        /// AlignmentPadding (variable, optional): An array of up to 3 bytes that pads the record so that its total size is a multiple of
        /// 4 bytes. This field MUST be ignored.
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
