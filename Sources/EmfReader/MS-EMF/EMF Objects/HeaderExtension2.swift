//
//  HeaderExtension2.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.11 HeaderExtension2 Object
/// The HeaderExtension2 object defines the second extension to the EMF metafile header. It adds the ability to measure device surfaces
/// in micrometers, which enhances the resolution and scalability of EMF metafiles.
public struct HeaderExtension2 {
    public let micrometersX: UInt32
    public let micrometersY: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// MicrometersX (4 bytes): The 32-bit horizontal size of the display device for which the metafile image was generated, in
        /// micrometers.
        self.micrometersX = try dataStream.read(endianess: .littleEndian)
        
        /// MicrometersY (4 bytes): The 32-bit vertical size of the display device for which the metafile image was generated, in
        /// micrometers.
        self.micrometersY = try dataStream.read(endianess: .littleEndian)
    }
}
