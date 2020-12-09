//
//  EMR_GRADIENTFILL.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.12 EMR_GRADIENTFILL Record
/// The EMR_GRADIENTFILL record specifies filling rectangles or triangles with gradients of color.<67>
/// See section 2.3.5 for more drawing record types.
public struct EMR_GRADIENTFILL {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let nVer: UInt32
    public let nTri: UInt32
    public let ulMode: GradientFill
    public let vertexObjects: [TriVertex]
    public let vertexIndexes: [VertexIndex]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_GRADIENTFILL. This value is 0x00000076.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_GRADIENTFILL else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 36 && (size % 4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19), which specifies the inclusive-inclusive bounding
        /// rectangle in logical units.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// nVer (4 bytes): An unsigned integer that specifies the number of vertexes.
        self.nVer = try dataStream.read(endianess: .littleEndian)
        guard 36 + self.nVer * 16 <= self.size else {
            throw EmfReadError.corrupted
        }
        
        /// nTri (4 bytes): An unsigned integer that specifies the number of rectangles or triangles to fill.
        self.nTri = try dataStream.read(endianess: .littleEndian)
        
        /// ulMode (4 bytes): An unsigned integer that specifies the gradient fill mode. This value is in the GradientFill enumeration
        /// (section 2.1.15).
        self.ulMode = try GradientFill(dataStream: &dataStream)
        let vertexIndicesSize: UInt32 = (self.ulMode == .triangle) ? 12 : 8
        guard 36 + self.nVer * 16 + self.nTri * vertexIndicesSize <= self.size else {
            throw EmfReadError.corrupted
        }
        
        /// VertexData (variable): Objects that specify the vertexes of either rectangles or triangles and the colors that correspond to
        /// them.
        /// VertexObjects (variable): An array of nVer TriVertex objects (section 2.2.26). Each object specifies the position and
        /// color of a vertex of either a rectangle or a triangle, depending on the value of the ulMode field.
        var vertexObjects: [TriVertex] = []
        vertexObjects.reserveCapacity(Int(self.nVer))
        for _ in 0..<self.nVer {
            vertexObjects.append(try TriVertex(dataStream: &dataStream))
        }
        
        self.vertexObjects = vertexObjects
        
        /// VertexIndexes (variable): An array of nTri GradientRectangle objects (section 2.2.7) or GradientTriangle objects
        /// (section 2.2.8), depending on the value of the ulMode field. Each object specifies indexes into the array of
        /// TriVertex objects in the VertexObjects field.
        var vertexIndexes: [VertexIndex] = []
        vertexIndexes.reserveCapacity(Int(self.nTri))
        for _ in 0..<self.nTri {
            if self.ulMode == .triangle {
                vertexIndexes.append(.triangle(try GradientTriangle(dataStream: &dataStream)))
            } else {
                vertexIndexes.append(.rectangle(try GradientRectangle(dataStream: &dataStream)))
            }
        }
        
        self.vertexIndexes = vertexIndexes
        
        /// VertexPadding (variable, optional): An array of nTri times four bytes that MUST be present if the value of the
        /// ulMode field indicates GradientRectangle objects (section 2.2.7). If the value of the ulMode field indicates
        /// GradientTriangle objects (section 2.2.8), no VertexPadding is present. This field MUST be ignored.
        if self.ulMode != .triangle {
            let paddingSize = Int(nTri * 4)
            guard dataStream.position + paddingSize <= dataStream.count else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position += paddingSize
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
    
    /// VertexIndexes (variable): An array of nTri GradientRectangle objects (section 2.2.7) or GradientTriangle objects
    /// (section 2.2.8), depending on the value of the ulMode field. Each object specifies indexes into the array of
    /// TriVertex objects in the VertexObjects field.
    public enum VertexIndex {
        case rectangle(_: GradientRectangle)
        case triangle(_: GradientTriangle)
    }
}
