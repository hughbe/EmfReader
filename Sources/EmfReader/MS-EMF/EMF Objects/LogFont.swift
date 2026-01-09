//
//  LogFont.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.2.13 LogFont Object
/// The LogFont object specifies the basic attributes of a logical font.
public struct LogFont {
    public let height: Int32
    public let width: Int32
    public let escapement: Int32
    public let orientation: Int32
    public let weight: Int32
    public let italic: UInt8
    public let underline: UInt8
    public let strikeOut: UInt8
    public let charSet: UInt8
    public let outPrecision: OutPrecision
    public let clipPrecision: ClipPrecision
    public let quality: UInt8
    public let pitchAndFamily: PitchAndFamily
    public let facename: String
    
    public init(dataStream: inout DataStream) throws {
        /// Height (4 bytes): A signed integer that specifies the height of the font's character cell in logical units. The character height
        /// value, also known as the em size, is the character cell height value minus the internal leading value. The font mapper
        /// SHOULD interpret the value specified in the Height field in the following manner.
        /// Value Meaning
        /// 0x00000000 < value The font mapper transforms this value into device units and matches
        /// it against the cell height of the available fonts.
        /// 0x00000000 The font mapper uses a default height value when it searches for a match.
        /// value < 0x00000000 The font mapper transforms this value into device units and
        /// matches its absolute value against the character height of the available fonts.
        /// For all height comparisons, the font mapper SHOULD look for the largest font that
        /// does not exceed the requested size.
        self.height = try dataStream.read(endianess: .littleEndian)
        
        /// Width (4 bytes): A signed integer that specifies the average width of characters in the font in logical units. If the Width
        /// field value is zero, an appropriate value SHOULD<46> be calculated from other values in this object to find a font that
        /// has the typographer's intended aspect ratio.
        self.width = try dataStream.read(endianess: .littleEndian)
        
        /// Escapement (4 bytes): A signed integer that specifies the angle, in tenths of degrees, between the escapement vector
        /// and the x-axis of the device. The escapement vector is parallel to the baseline of a row of text.
        /// When the graphics mode is set to GM_ADVANCED, the escapement angle of the string can be specified independently
        /// of the orientation angle of the string's characters. Graphics modes are specified in section 2.1.16
        self.escapement = try dataStream.read(endianess: .littleEndian)
        
        /// Orientation (4 bytes): A signed integer that specifies the angle, in tenths of degrees, between each character's baseline
        /// and the x-axis of the device.
        self.orientation = try dataStream.read(endianess: .littleEndian)
        
        /// Weight (4 bytes): A signed integer that specifies the weight of the font in the range zero through 1000. For example, 400
        /// is normal and 700 is bold. If this value is zero, a default weight can be used.<47>
        self.weight = try dataStream.read(endianess: .littleEndian)
        
        /// Italic (1 byte): An unsigned integer that specifies an italic font if set to 0x01; otherwise, it MUST be set to 0x00.
        self.italic = try dataStream.read()
        
        /// Underline (1 byte): An unsigned integer that specifies an underlined font if set to 0x01; otherwise, it MUST be set to 0x00.
        self.underline = try dataStream.read()
        
        /// StrikeOut (1 byte): An unsigned integer that specifies a strikeout font if set to 0x01; otherwise, it MUST be set to 0x00.
        self.strikeOut = try dataStream.read()
        
        /// CharSet (1 byte): An unsigned integer that specifies the set of character glyphs. It MUST be a value in the CharacterSet
        /// enumeration ([MS-WMF] section 2.1.1.5). If the character set is unknown, metafile processing SHOULD NOT attempt
        /// to translate or interpret strings that are rendered with that font.
        /// If a typeface name is specified in the Facename field, the CharSet field value MUST match the character set of that typeface.
        self.charSet = try dataStream.read()
        
        /// OutPrecision (1 byte): An unsigned integer that specifies the output precision. The output precision defines how closely
        /// the font is required to match the requested height, width, character orientation, escapement, pitch, and font type. It MUST
        /// be a value from the OutPrecision enumeration ([MS-WMF] section 2.1.1.21). Applications can use the output precision
        /// to control how the font mapper chooses a font when the operating system contains more than one font with a specified
        /// name. For example, if an operating system contains a font named Symbol in rasterized and TrueType forms, an output
        /// precision value of OUT_TT_PRECIS forces the font mapper to choose the TrueType version. A value of
        /// OUT_TT_ONLY_PRECIS forces the font mapper to choose a TrueType font, even if it is necessary to substitute a TrueType
        /// font with another name.
        guard let outPrecision = OutPrecision(rawValue: try dataStream.read()) else {
            throw EmfReadError.corrupted
        }
        
        self.outPrecision = outPrecision
        
        /// ClipPrecision (1 byte): An unsigned integer that specifies the clipping precision. The clipping precision defines how to
        /// clip characters that are partially outside the clipping region. It can be one or more of the ClipPrecision Flags ([MS-WMF]
        /// section 2.1.2.1).
        self.clipPrecision = ClipPrecision(rawValue: try dataStream.read())
        
        /// Quality (1 byte): An unsigned integer that specifies the output quality. The output quality defines how closely to attempt to
        /// match the logical-font attributes to those of an actual physical font. It MUST be one of the values in the FontQuality
        /// enumeration ([MS-WMF] section 2.1.1.10).
        self.quality = try dataStream.read()
        
        /// PitchAndFamily (1 byte): A PitchAndFamily object ([MS-WMF] section 2.2.2.14) that specifies the pitch and family of the
        /// font. Font families describe the look of a font in a general way. They are intended for specifying a font when the specified
        /// typeface is not available.
        self.pitchAndFamily = try PitchAndFamily(dataStream: &dataStream)
        
        /// Facename (64 bytes): A string of no more than 32 Unicode characters that specifies the typeface name of the font. If the
        /// length of this string is less than 32 characters, a terminating NULL MUST be present, after which the remainder of this
        /// field MUST be ignored.
        self.facename = try dataStream.readString(count: 64, encoding: .utf16LittleEndian)?.trimmingCharacters(in: ["\0"]) ?? ""
    }
}
