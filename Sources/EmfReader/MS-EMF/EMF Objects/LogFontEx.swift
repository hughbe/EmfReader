//
//  LogFontEx.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.14 LogFontEx Object
/// The LogFontEx object specifies the extended attributes of a logical font.
public struct LogFontEx {
    public let logFont: LogFont
    public let fullName: String
    public let style: String
    public let script: String
    
    public init(dataStream: inout DataStream) throws {
        /// LogFont (92 bytes): A LogFont (section 2.2.13) object that specifies the basic attributes of the logical font.
        self.logFont = try LogFont(dataStream: &dataStream)
        
        /// FullName (128 bytes): A string of 64 Unicode characters that contains the font's full name. If the length of this string is less
        /// than 64 characters, a terminating NULL MUST be present, after which the remainder of this field MUST be ignored.
        self.fullName = try dataStream.readString(count: 128, encoding: .utf16LittleEndian)!.trimmingCharacters(in: ["\0"])
        
        /// Style (64 bytes): A string of 32 Unicode characters that defines the font's style. If the length of this string is less than 32
        /// characters, a terminating NULL MUST be present, after which the remainder of this field MUST be ignored.
        self.style = try dataStream.readString(count: 64, encoding: .utf16LittleEndian)!.trimmingCharacters(in: ["\0"])

        /// Script (64 bytes): A string of 32 Unicode characters that defines the character set of the font. If the length of this string is
        /// less than 32 characters, a terminating NULL MUST be present, after which the remainder of this field MUST be ignored.
        self.script = try dataStream.readString(count: 64, encoding: .utf16LittleEndian)!.trimmingCharacters(in: ["\0"])
    }
}
