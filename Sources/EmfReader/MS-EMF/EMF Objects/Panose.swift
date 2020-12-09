//
//  Panose.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.21 Panose Object
/// The Panose object describes the PANOSE font-classification values for a TrueType font. These characteristics are used to associate
/// the font with other fonts of similar appearance but different names.
public struct Panose {
    public let familyType: FamilyType
    public let serifStyle: SerifType
    public let weight: Weight
    public let proportion: Proportion
    public let contrast: Contrast
    public let strokeVariation: StrokeVariation
    public let armStyle: ArmStyle
    public let letterform: Letterform
    public let midline: MidLine
    public let xHeight: XHeight
    
    public init(dataStream: inout DataStream) throws {
        /// FamilyType (1 byte): An unsigned integer that specifies the family type. This value is in the FamilyType (section 2.1.12)
        /// enumeration table.
        self.familyType = try FamilyType(dataStream: &dataStream)
        
        /// SerifStyle (1 byte): An unsigned integer that specifies the serif style. This value is in the SerifType (section 2.1.30)
        /// enumeration table.
        self.serifStyle = try SerifType(dataStream: &dataStream)
        
        /// Weight (1 byte): An unsigned integer that specifies the weight of the font. This value is in the Weight (section 2.1.34)
        /// enumeration table.
        self.weight = try Weight(dataStream: &dataStream)
        
        /// Proportion (1 byte): An unsigned integer that specifies the proportion of the font. This value is in the Proportion
        /// (section 2.1.28) enumeration table.
        self.proportion = try Proportion(dataStream: &dataStream)
        
        /// Contrast (1 byte): An unsigned integer that specifies the contrast of the font. This value is in the Contrast (section 2.1.8)
        /// enumeration table.
        self.contrast = try Contrast(dataStream: &dataStream)
        
        /// StrokeVariation (1 byte): An unsigned integer that specifies the stroke variation for the font. This value is in the
        /// StrokeVariation (section 2.1.33) enumeration table.
        self.strokeVariation = try StrokeVariation(dataStream: &dataStream)
        
        /// ArmStyle (1 byte): An unsigned integer that specifies the arm style of the font. This value is in the ArmStyle (section 2.1.3)
        /// enumeration table.
        self.armStyle = try ArmStyle(dataStream: &dataStream)
        
        /// Letterform (1 byte): An unsigned integer that specifies the letterform of the font. This value is in the Letterform (section 2.1.20)
        /// enumeration table.
        self.letterform = try Letterform(dataStream: &dataStream)
        
        /// Midline (1 byte): An unsigned integer that specifies the midline of the font. This value is in the MidLine (section 2.1.23)
        /// enumeration table.
        self.midline = try MidLine(dataStream: &dataStream)
        
        /// XHeight (1 byte): An unsigned integer that specifies the x height of the font. This value is in the XHeight (section 2.1.35)
        /// enumeration table.
        self.xHeight = try XHeight(dataStream: &dataStream)
    }
}
