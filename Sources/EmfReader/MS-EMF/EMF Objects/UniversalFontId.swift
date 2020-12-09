//
//  UniversalFontId.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.27 UniversalFontId Object
/// The UniversalFontId object defines a mechanism for identifying fonts in EMF metafiles.
public struct UniversalFontId {
    public let checksum: UInt32
    public let index: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// Checksum (4 bytes): An unsigned integer that is the checksum of the font. The checksum value has the following meanings.
        /// Value Meaning
        /// 0x00000000 The object is a device font.
        /// 0x00000001 The object is a Type 1 font that has been installed on the client machine and is enumerated by the PostScript
        /// printer driver as a device font.
        /// 0x00000002 The object is not a font but is a Type 1 rasterizer.
        /// 3 ≤ value The object is a bitmap, vector, or TrueType font, or a Type 1 rasterized font that was created by a Type 1 rasterizer.
        /// A checksum value SHOULD be computed for the font and compared to the value in this field.
        /// If it matches, it is considered to be the same as the font referenced by this metafile record. If it does not match, the
        /// system font mapper MAY use a default mechanism to select a backup font.<55>
        /// If a checksum value is computed, it SHOULD be computed using the following algorithm.
        /// For the purpose of this computation, the font is considered simply to be a stream of bytes that is external to this EMF
        /// record. Any larger file structure in which the font might reside is systemdependent or implementation-dependent.
        /// ULONG ComputeFileviewCheckSum(PVOID pvView, ULONG cjView)
        /// {
        ///  ULONG sum;
        ///  PULONG pulCur,pulEnd;
        ///  pulCur = (PULONG) pvView;
        ///  for (sum = 0, pulEnd = pulCur + cjView / sizeof(ULONG);
        ///  pulCur < pulEnd; pulCur += 1)
        ///  {
        ///  sum += 256 * sum + *pulCur;
        ///  }
        ///  return ( sum < 2 ) ? 2 : sum;
        /// }
        /// pvView: A pointer to the start of the font.
        /// cjView: The length of the font in bytes.
        self.checksum = try dataStream.read(endianess: .littleEndian)
        
        /// Index (4 bytes): An unsigned integer that is an index associated with the font object. The meaning of this field is determined
        /// by the type of font.
        self.index = try dataStream.read(endianess: .littleEndian)
    }
}
