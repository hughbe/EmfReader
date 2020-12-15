//
//  EMR_SETICMPROFILEA.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.11.15 EMR_SETICMPROFILEA Record
/// The EMR_SETICMPROFILEA record specifies a color profile in a file with a name consisting of ASCII characters, for graphics
/// output.<85>
/// See section 2.3.11 for more state record types.
public struct EMR_SETICMPROFILEA {
    public let type: RecordType
    public let size: UInt32
    public let dwFlags: UInt32
    public let cbName: UInt32
    public let cbData: UInt32
    public let data: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETICMPROFILEA. This value is 0x00000070.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETICMPROFILEA else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000014 && size % 4 == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// dwFlags (4 bytes): An unsigned integer that contains color profile flags.
        self.dwFlags = try dataStream.read(endianess: .littleEndian)
        
        /// cbName (4 bytes): An unsigned integer that specifies the number of bytes in the ASCII name of the desired color profile.
        self.cbName = try dataStream.read(endianess: .littleEndian)
        
        /// cbData (4 bytes): An unsigned integer that specifies the size of the color profile data, if it is contained in the Data field.
        self.cbData = try dataStream.read(endianess: .littleEndian)
        let dataCount = Int(self.cbName) + Int(self.cbData)
        guard dataCount < 0xFFFFFFE8 &&
                0x00000014 + dataCount <= size else {
            throw EmfReadError.corrupted
        }
        
        /// Data (variable): An array of size (cbName + cbData) in bytes, which specifies the ASCII name and raw data of the desired
        /// color profile.
        self.data = try dataStream.readBytes(count: dataCount)
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
