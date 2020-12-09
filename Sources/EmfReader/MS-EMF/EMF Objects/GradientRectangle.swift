//
//  GradientRectangle.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.7 GradientRectangle Object
/// The GradientRectangle object defines a rectangle using TriVertex objects (section 2.2.26) in an EMR_GRADIENTFILL record (section 2.3.5.12).
public struct GradientRectangle {
    public let upperLeft: UInt32
    public let lowerRight: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// UpperLeft (4 bytes): An index into an array of TriVertex objects that specifies the upper-left vertex of a rectangle.
        /// The index MUST be smaller than the size of the array, as defined by the nVer field of the EMR_GRADIENTFILL record.
        self.upperLeft = try dataStream.read(endianess: .littleEndian)
        
        /// LowerRight (4 bytes): An index into an array of TriVertex objects that specifies the lower-right vertex of a rectangle.
        /// The index MUST be smaller than the size of the array, as defined by the nVer field of the EMR_GRADIENTFILL record.
        self.lowerRight = try dataStream.read(endianess: .littleEndian)
    }
}
