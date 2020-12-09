//
//  ExtTextOutOptions.swift
//
//
//  Created by Hugh Bellamy on 30/11/2020.
//

/// [MS-EMF] 2.1.11 ExtTextOutOptions Enumeration
/// The ExtTextOutOptions enumeration specifies parameters that control various aspects of the output of text by
/// EMR_SMALLTEXTOUT (section 2.3.5.37) records and in EmrText objects.
/// typedef enum
/// {
///  ETO_OPAQUE = 0x00000002,
///  ETO_CLIPPED = 0x00000004,
///  ETO_GLYPH_INDEX = 0x00000010,
///  ETO_RTLREADING = 0x00000080,
///  ETO_NO_RECT = 0x00000100,
///  ETO_SMALL_CHARS = 0x00000200,
///  ETO_NUMERICSLOCAL = 0x00000400,
///  ETO_NUMERICSLATIN = 0x00000800,
///  ETO_IGNORELANGUAGE = 0x00001000,
///  ETO_PDY = 0x00002000,
///  ETO_REVERSE_INDEX_MAP = 0x00010000
/// } ExtTextOutOptions;
public struct ExtTextOutOptions: OptionSet, DataStreamCreatable {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    /// ETO_OPAQUE: This bit indicates that the current background color SHOULD be used to fill the rectangle.
    public static let opaque = ExtTextOutOptions(rawValue: 0x00000002)
    
    /// ETO_CLIPPED: This bit indicates that the text SHOULD be clipped to the rectangle.
    public static let clipped = ExtTextOutOptions(rawValue: 0x00000004)
    
    /// ETO_GLYPH_INDEX: This bit indicates that the codes for characters in an output text string are indexes of the character
    /// glyphs in a TrueType font. Glyph indexes are font-specific, so to display the correct characters on playback, the font that is
    /// used MUST be identical to the font used to generate the indexes.<23>
    public static let glyphIndex = ExtTextOutOptions(rawValue: 0x00000010)
    
    /// ETO_RTLREADING: This bit indicates that the text MUST be laid out in right-to-left reading order, instead of the default
    /// left-to-right order. This SHOULD be applied only when the font selected into the playback device context is either Hebrew
    /// or Arabic.<24>
    public static let rtlLeading = ExtTextOutOptions(rawValue: 0x00000080)
    
    /// ETO_NO_RECT: This bit indicates that the record does not specify a bounding rectangle for the text output.
    public static let noRect = ExtTextOutOptions(rawValue: 0x00000100)
    
    /// ETO_SMALL_CHARS: This bit indicates that the codes for characters in an output text string are 8 bits, derived from the low
    /// bytes of Unicode UTF16-LE character codes, in which the high byte is assumed to be 0.
    public static let smallChars = ExtTextOutOptions(rawValue: 0x00000200)
    
    /// ETO_NUMERICSLOCAL: This bit indicates that to display numbers, digits appropriate to the locale SHOULD be used.<25>
    public static let numericsLocal = ExtTextOutOptions(rawValue: 0x00000400)
    
    /// ETO_NUMERICSLATIN: This bit indicates that to display numbers, European digits SHOULD be used.<26>
    public static let numericsLatin = ExtTextOutOptions(rawValue: 0x00000800)
    
    /// ETO_IGNORELANGUAGE: This bit indicates that no special operating system processing for glyph placement is performed on
    /// right-to-left strings; that is, all glyph positioning SHOULD be taken care of by drawing and state records in the metafile.<27>
    public static let ignoreLanguage = ExtTextOutOptions(rawValue: 0x00001000)

    /// ETO_PDY: This bit indicates that both horizontal and vertical character displacement values SHOULD be provided.<28>
    public static let pdy = ExtTextOutOptions(rawValue: 0x00002000)
    
    /// ETO_REVERSE_INDEX_MAP: This bit is reserved and SHOULD NOT be used.<29>
    public static let reverseIndexMap = ExtTextOutOptions(rawValue: 0x00010000)
    
    public static let all: ExtTextOutOptions = [
        .opaque,
        .clipped,
        .glyphIndex,
        .rtlLeading,
        .noRect,
        .smallChars,
        .numericsLocal,
        .numericsLatin,
        .pdy,
        .reverseIndexMap
    ]
}
