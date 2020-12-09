//
//  XForm.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.28 XForm Object
/// The XForm object defines a two-dimensional, linear transform matrix.
/// The following equations specify how the matrix values are used to transform a point (X,Y) to a new point (X',Y'):
/// X' = M11 * X + M21 * Y + Dx
/// Y' = M12 * X + M22 * Y + Dy
/// For more information concerning transforms and coordinate spaces, see [MSDN-WRLDPGSPC].
public struct XForm {
    public let m11: Float
    public let m12: Float
    public let m21: Float
    public let m22: Float
    public let dx: Float
    public let dy: Float
    
    public init(dataStream: inout DataStream) throws {
        /// M11 (4 bytes): A FLOAT matrix value.
        self.m11 = try dataStream.readFloat(endianess: .littleEndian)
        
        /// M12 (4 bytes): A FLOAT matrix value.
        self.m12 = try dataStream.readFloat(endianess: .littleEndian)
        
        /// M21 (4 bytes): A FLOAT matrix value.
        self.m21 = try dataStream.readFloat(endianess: .littleEndian)
        
        /// M22 (4 bytes): A FLOAT matrix value.
        self.m22 = try dataStream.readFloat(endianess: .littleEndian)
        
        /// Dx (4 bytes): A FLOAT value that contains a horizontal translation component, in logical units.
        self.dx = try dataStream.readFloat(endianess: .littleEndian)
        
        /// Dy (4 bytes): A FLOAT value that contains a vertical translation component, in logical units.
        self.dy = try dataStream.readFloat(endianess: .littleEndian)
    }
}
