//
//  BitFIX28_4.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.1 BitFIX28_4 Object
/// The BitFIX28_4 object defines a numeric value in 28.4 bit FIX notation.
/// The real number represented by this object is computed as follows:
/// IntValue + (FracValue / 16)
public struct BitFIX28_4 {
    public let intValue: Int32
    public let fracValue: UInt8
    
    public var value: Float {
        Float(intValue) + (Float(fracValue) / 16)
    }
    
    public init(dataStream: inout DataStream) throws {
        var flags: BitFieldReader<Int32> = try dataStream.readBits(endianess: .littleEndian)
        
        /// IntValue (28 bits): The signed, integral part of the number.
        self.intValue = flags.readBits(count: 28)
        
        /// FracValue (4 bits): The unsigned fractional part of the number, in units of one-sixteenth.
        self.fracValue = UInt8(flags.readRemainingBits())
    }
}
