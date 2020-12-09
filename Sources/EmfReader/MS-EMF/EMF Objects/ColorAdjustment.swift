//
//  ColorAdjustment.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF]2.2.2 ColorAdjustment Object
/// The ColorAdjustment object defines values for adjusting the colors in source bitmaps in bit-block transfers.<42>
/// The ColorAdjustment object is used in bit-block transfers performed by EMR_STRETCHBLT and EMR_STRETCHDIBITS records
/// when the StretchMode enumeration (section 2.1.32) value is STRETCH_HALFTONE. The color adjustment values can apply a color
/// filter or lighten or darken an image.
/// An EMR_SETCOLORADJUSTMENT record (section 2.3.11.13) sets the current ColorAdjustment object in the playback device context.
/// That ColorAdjustment object affects all subsequent EMR_STRETCHBLT and EMR_STRETCHDIBITS records until a different
/// ColorAdjustment object is specified by another EMR_SETCOLORADJUSTMENT record, or until the object is removed by a
/// EMR_DELETEOBJECT record.
public struct ColorAdjustment {
    public let size: UInt16
    public let values: ColorAdjustmentValues
    public let illuminantIndex: Illuminant
    public let redGamma: UInt16
    public let greenGamma: UInt16
    public let blueGamma: UInt16
    public let referenceBlack: UInt16
    public let referenceWhite: UInt16
    public let contrast: Int16
    public let brightness: Int16
    public let colorfulness: Int16
    public let redGreenTint: Int16
    
    public init(dataStream: inout DataStream) throws {
        /// Size (2 bytes): An unsigned integer that specifies the size in bytes of this object. This value is 0x0018.
        self.size = try dataStream.read(endianess: .littleEndian)
        
        /// Values (2 bytes): An unsigned integer that specifies how to prepare the output image. This field can be set to NULL or
        /// to any combination of values in the ColorAdjustment enumeration (section 2.1.5).
        self.values = try ColorAdjustmentValues(dataStream: &dataStream)
        
        /// IlluminantIndex (2 bytes): An unsigned integer that specifies the type of standard light source under which the image is
        /// viewed, from the Illuminant enumeration (section 2.1.19).
        self.illuminantIndex = try Illuminant(dataStream: &dataStream)
        
        /// RedGamma (2 bytes): An unsigned integer that specifies the nth power gamma correction value for the red primary of the
        /// source colors. This value SHOULD be in the range from 2,500 to 65,000.<43> A value of 10,000 means gamma correction
        /// MUST NOT be performed.
        self.redGamma = try dataStream.read(endianess: .littleEndian)
        
        /// GreenGamma (2 bytes): An unsigned integer that specifies the nth power gamma correction value for the green primary of
        /// the source colors. This value SHOULD be in the range from 2,500 to 65,000. A value of 10,000 means gamma correction
        /// MUST NOT be performed.
        self.greenGamma = try dataStream.read(endianess: .littleEndian)
        
        /// BlueGamma (2 bytes): An unsigned integer that specifies the nth power gamma correction value for the blue primary of the
        /// source colors. This value SHOULD be in the range from 2,500 to 65,000. A value of 10,000 means gamma correction
        /// MUST NOT be performed.
        self.blueGamma = try dataStream.read(endianess: .littleEndian)
        
        /// ReferenceBlack (2 bytes): An unsigned integer that specifies the black reference for the source colors. Any colors that are
        /// darker than this are treated as black. This value SHOULD be in the range from zero to 4,000.
        self.referenceBlack = try dataStream.read(endianess: .littleEndian)
        
        /// ReferenceWhite (2 bytes): An unsigned integer that specifies the white reference for the source colors. Any colors that are
        /// lighter than this are treated as white. This value SHOULD be in the range from 6,000 to 10,000.
        self.referenceWhite = try dataStream.read(endianess: .littleEndian)
        
        /// Contrast (2 bytes): A signed integer that specifies the amount of contrast to be applied to the source object. This value
        /// SHOULD be in the range from –100 to 100. A value of zero means contrast adjustment MUST NOT be performed.
        self.contrast = try dataStream.read(endianess: .littleEndian)
        
        /// Brightness (2 bytes): A signed integer that specifies the amount of brightness to be applied to the source object.
        /// This value SHOULD be in the range from –100 to 100. A value of zero means brightness adjustment MUST NOT be performed.
        self.brightness = try dataStream.read(endianess: .littleEndian)
        
        /// Colorfulness (2 bytes): A signed integer that specifies the amount of colorfulness to be applied to the source object.
        /// This value SHOULD be in the range from –100 to 100. A value of zero means colorfulness adjustment MUST NOT be performed.
        self.colorfulness = try dataStream.read(endianess: .littleEndian)
        
        /// RedGreenTint (2 bytes): A signed integer that specifies the amount of red or green tint adjustment to be applied to the
        /// source object. This value SHOULD be in the range from –100 to 100. Positive numbers adjust towards red and negative
        /// numbers adjust towards green. A value of zero means tint adjustment MUST NOT be performed.
        self.redGreenTint = try dataStream.read(endianess: .littleEndian)
    }
}
