//
//  EpsData.swift
//  
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.6 EpsData Object
/// The EpsData object is a container for EPS data.
/// An EpsData object can be used to embed a PostScript image in an EMF metafile as follows:
///  An EMF metafile contains an EMR_COMMENT_MULTIFORMATS record (section 2.3.3.4.3).
///  The EMR_COMMENT_MULTIFORMATS record specifies an aFormats field that contains an EmrFormat object (section 2.2.4).
///  The EmrFormat object specifies a Signature field that is set to EPS_SIGNATURE from the FormatSignature enumeration (section
/// 2.1.14).
///  The EPS_SIGNATURE value specifies that the FormatData field in the EMR_COMMENT_MULTIFORMATS record contains an
/// EpsData object.
///  The EmrFormat object also specifies an offData field that indicates where the EpsData object is in the FormatData field in the
/// EMR_COMMENT_MULTIFORMATS record.
public struct EpsData {
    public let sizeData: UInt32
    public let version: UInt32
    public let points: [Point28_4]
    public let postScriptData: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// SizeData (4 bytes): An unsigned integer that specifies the total size of this object in bytes.
        self.sizeData = try dataStream.read(endianess: .littleEndian)
        guard self.sizeData >= 32 else {
            throw EmfReadError.corrupted
        }
        
        /// Version (4 bytes): An unsigned integer that specifies the PostScript language level. This value is 0x00000001.
        self.version = try dataStream.read(endianess: .littleEndian)
        
        /// Points (24 bytes): An array of three Point28_4 objects (section 2.2.23) that defines the coordinates of the output
        /// parallelogram using 28.4 bit FIX notation.
        /// The upper-left corner of the parallelogram is the first point in this array, the upper-right corner is the second point, and the
        /// lower-left corner is the third point. The lower-right corner of the parallelogram is computed from the first three points
        /// (A, B, and C) by treating them as vectors.
        self.points = [
            try Point28_4(dataStream: &dataStream),
            try Point28_4(dataStream: &dataStream),
            try Point28_4(dataStream: &dataStream)
        ]
        
        /// PostScriptData (variable): An array of bytes of PostScript data. The length of this array can be computed from the SizeData
        /// field. This data MAY be used to render an image.<45>
        self.postScriptData = try dataStream.readBytes(count: Int(self.sizeData) - 32)
        
        guard dataStream.position - startPosition == self.sizeData else {
            throw EmfReadError.corrupted
        }
    }
}
