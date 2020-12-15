//
//  EMR_SCALEVIEWPORTEXTEX.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.11.7 EMR_SCALEVIEWPORTEXTEX Record
/// The EMR_SCALEVIEWPORTEXTEX record specifies the current viewport in the playback device context by using ratios formed by
/// the specified multiplicands and divisors.
/// The extent MUST NOT be changed if the current mapping mode (section 2.1.21) is fixed scale. Only MM_ISOTROPIC and
/// MM_ANISOTROPIC are not fixed scale.
/// The new viewport extent is computed as follows.
/// xNewWE = (xOldWE * xNum) / xDenom
/// yNewWE = (yOldWE * yNum) / yDenom
/// See section 2.3.11 for more state record types.
public struct EMR_SCALEVIEWPORTEXTEX {
    public let type: RecordType
    public let size: UInt32
    public let xNum: Int32
    public let xDenom: Int32
    public let yNum: Int32
    public let yDenom: Int32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SCALEVIEWPORTEXTEX. This value is 0x0000001F.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SCALEVIEWPORTEXTEX else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000018 else {
            throw EmfReadError.corrupted
        }
        
        /// xNum (4 bytes): A signed integer that specifies the horizontal multiplicand. Cannot be zero.
        self.xNum = try dataStream.read(endianess: .littleEndian)
        guard self.xNum != 0 else {
            throw EmfReadError.corrupted
        }
        
        /// xDenom (4 bytes): A signed integer that specifies the horizontal divisor. Cannot be zero.
        self.xDenom = try dataStream.read(endianess: .littleEndian)
        guard self.xDenom != 0 else {
            throw EmfReadError.corrupted
        }
        
        /// yNum (4 bytes): A signed integer that specifies the vertical multiplicand. Cannot be zero.
        self.yNum = try dataStream.read(endianess: .littleEndian)
        guard self.yNum != 0 else {
            throw EmfReadError.corrupted
        }
        
        /// yDenom (4 bytes): A signed integer that specifies the vertical divisor. Cannot be zero.
        self.yDenom = try dataStream.read(endianess: .littleEndian)
        guard self.yDenom != 0 else {
            throw EmfReadError.corrupted
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
