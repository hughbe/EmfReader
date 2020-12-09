//
//  HeaderExtension1.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.10 HeaderExtension1 Object
/// The HeaderExtension1 object defines the first extension to the EMF metafile header. It adds support for a PixelFormatDescriptor
/// object (section 2.2.22) and OpenGL [OPENGL] records (section 2.3.9).
public struct HeaderExtension1 {
    public let cbPixelFormat: UInt32
    public let offPixelFormat: UInt32
    public let bOpenGL: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// cbPixelFormat (4 bytes): An unsigned integer that specifies the size of the PixelFormatDescriptor object. This value is
        /// 0x00000000 if no pixel format is set.
        self.cbPixelFormat = try dataStream.read(endianess: .littleEndian)
        
        /// offPixelFormat (4 bytes): An unsigned integer that specifies the offset to the PixelFormatDescriptor object. This value is
        /// 0x00000000 if no pixel format is set.
        self.offPixelFormat = try dataStream.read(endianess: .littleEndian)
        
        /// bOpenGL (4 bytes): An unsigned integer that indicates whether OpenGL commands are present in the metafile.
        /// Value Meaning
        /// 0x00000000 OpenGL records are not present in the metafile.
        /// 0x00000001 OpenGL records are present in the metafile.
        self.bOpenGL = try dataStream.read(endianess: .littleEndian)
    }
}
