//
//  DesignVector.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.3 DesignVector Object
/// The DesignVector (section 2.2.3) object defines the design vector, which specifies values for the font axes of a multiple master font.
public struct DesignVector {
    public let signature: UInt32
    public let numAxes: UInt32
    public let values: [Int32]
    
    public init(dataStream: inout DataStream) throws {
        /// Signature (4 bytes): An unsigned integer that MUST be set to the value 0x08007664.
        self.signature = try dataStream.read(endianess: .littleEndian)
        guard self.signature == 0x08007664 else {
            throw EmfReadError.corrupted
        }
        
        /// NumAxes (4 bytes): An unsigned integer that specifies the number of elements in the Values array. It MUST be in the range
        /// 0 to 16, inclusive.
        self.numAxes = try dataStream.read(endianess: .littleEndian)
        guard self.numAxes <= 16 else {
            throw EmfReadError.corrupted
        }
        
        /// Values (variable, optional): An array of 32-bit signed integers that specify the values of the font axes of a multiple master,
        /// OpenType font. The maximum number of values in the array is 16.
        var values: [Int32] = []
        values.reserveCapacity(Int(self.numAxes))
        for _ in 0..<self.numAxes {
            values.append(try dataStream.read(endianess: .littleEndian))
        }
        
        self.values = values
    }
}
