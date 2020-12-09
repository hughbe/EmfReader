//
//  GradientTriangle.swift
//  
//
//  Created by Hugh Bellamy on 08/12/2020.
//

import DataStream

/// [MS-EMF ] 2.2.8 GradientTriangle Object
/// The GradientTriangle object defines a triangle using TriVertex objects (section 2.2.26) in an EMR_GRADIENTFILL record (section 2.3.5.12).
public struct GradientTriangle {
    public let vertex1: UInt32
    public let vertex2: UInt32
    public let vertex3: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// Vertex1 (4 bytes): An index into an array of TriVertex objects that specifies a vertex of a triangle. The index MUST be
        /// smaller than the size of the array, as defined by the nVer field of the EMR_GRADIENTFILL record.
        self.vertex1 = try dataStream.read(endianess: .littleEndian)
        
        /// Vertex2 (4 bytes): An index into an array of TriVertex objects that specifies a vertex of a triangle. The index MUST be
        /// smaller than the size of the array, as defined by the nVer field of the EMR_GRADIENTFILL record.
        self.vertex2 = try dataStream.read(endianess: .littleEndian)
        
        /// Vertex3 (4 bytes): An index into an array of TriVertex objects that specifies a vertex of a triangle. The index MUST be
        /// smaller than the size of the array, as defined by the nVer field of the EMR_GRADIENTFILL record.
        self.vertex3 = try dataStream.read(endianess: .littleEndian)
    }
}
