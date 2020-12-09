//
//  EMR_SETICMPROFILEW.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.11.16 EMR_SETICMPROFILEW Record
/// The EMR_SETICMPROFILEW record specifies a color profile in a file with a name consisting of Unicode characters, for graphics
/// output.<86>
/// See section 2.3.11 for more state record types.
public struct EMR_SETICMPROFILEW {
    public let type: RecordType
    public let size: UInt32
    public let dwFlags: UInt32
    public let cbName: UInt32
    public let cbData: UInt32
    public let data: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETICMPROFILEW. This value is 0x00000071.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETICMPROFILEW else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size >= 20 else {
            throw EmfReadError.corrupted
        }
        
        /// dwFlags (4 bytes): An unsigned integer that contains color profile flags.
        self.dwFlags = try dataStream.read(endianess: .littleEndian)
        
        /// cbName (4 bytes): An unsigned integer that specifies the number of bytes in the Unicode UTF16-LE name of the desired
        /// color profile.
        self.cbName = try dataStream.read(endianess: .littleEndian)
        
        /// cbData (4 bytes): An unsigned integer that specifies the size of color profile data, if attached.
        self.cbData = try dataStream.read(endianess: .littleEndian)
        guard 20 + self.cbName + self.cbData <= self.size else {
            throw EmfReadError.corrupted
        }
        
        /// Data (variable): An array of size (cbName + cbData) in bytes, which specifies the UTF16-LE name and raw data of the
        /// desired color profile.
        self.data = try dataStream.readBytes(count: Int(self.cbName + cbData))
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
