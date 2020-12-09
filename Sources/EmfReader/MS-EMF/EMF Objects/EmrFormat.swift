//
//  File.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.4 EmrFormat Object
/// The EmrFormat object contains information that identifies the format of image data in an EMR_COMMENT_MULTIFORMATS record
/// (section 2.3.3.4.3).
public struct EmrFormat {
    public let signature: UInt32
    public let version: UInt32
    public let sizeData: UInt32
    public let offData: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// Signature (4 bytes): An unsigned integer that specifies the format of the image data. This value is in the FormatSignature
        /// enumeration (section 2.1.14).
        self.signature = try dataStream.read(endianess: .littleEndian)
        
        /// Version (4 bytes): An unsigned integer that specifies the format version number. If the Signature field specifies encapsulated
        /// PostScript (EPS), this value is 0x00000001; otherwise, this value is ignored.
        self.version = try dataStream.read(endianess: .littleEndian)
        
        /// SizeData (4 bytes): An unsigned integer that specifies the size of the data in bytes.
        self.sizeData = try dataStream.read(endianess: .littleEndian)
        
        /// offData (4 bytes): An unsigned integer that specifies the offset to the data from the start of the identifier field in an
        /// EMR_COMMENT_PUBLIC record (section 2.3.3.4). The offset MUST be 32-bit aligned.
        self.offData = try dataStream.read(endianess: .littleEndian)
        guard (self.offData % 4) == 0 else {
            throw EmfReadError.corrupted
        }
    }
}
