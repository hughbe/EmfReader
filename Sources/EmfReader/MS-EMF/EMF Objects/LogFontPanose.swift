//
//  LogFontPanose.swift
//
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.16 LogFontPanose Object
/// The LogFontPanose object specifies the PANOSE characteristics of a logical font.
public struct LogFontPanose {
    public let logFont: LogFont
    public let fullName: String
    public let style: String
    public let version: UInt32
    public let styleSize: UInt32
    public let match: UInt32
    public let reserved: UInt32
    public let vendorId: UInt32
    public let culture: UInt32
    public let panose: Panose
    public let padding: UInt16
    
    public init(dataStream: inout DataStream) throws {
        /// LogFont (92 bytes): A LogFont (section 2.2.13) object that specifies the basic attributes of the logical font.
        self.logFont = try LogFont(dataStream: &dataStream)
        
        /// FullName (128 bytes): A string of 64 Unicode characters that defines the font's full name. If the length of this string is less
        /// than 64 characters, a terminating NULL MUST be present, after which the remainder of this field MUST be ignored.
        self.fullName = try dataStream.readString(count: 128, encoding: .utf16LittleEndian)?.trimmingCharacters(in: ["\0"]) ?? ""
        
        /// Style (64 bytes): A string of 32 Unicode characters that defines the font's style. If the length of this string is less than
        /// 32 characters, a terminating NULL MUST be present, after which the remainder of this field MUST be ignored.
        self.style = try dataStream.readString(count: 64, encoding: .utf16LittleEndian)?.trimmingCharacters(in: ["\0"]) ?? ""

        /// Version (4 bytes): This field MUST be ignored.
        self.version = try dataStream.read(endianess: .littleEndian)
        
        /// StyleSize (4 bytes): An unsigned integer that specifies the point size at which font hinting is performed. If set to zero,
        /// font hinting is performed at the point size corresponding to the Height field in the LogFont object in the LogFont field.
        self.styleSize = try dataStream.read(endianess: .littleEndian)
        
        /// Match (4 bytes): This field MUST be ignored.
        self.match = try dataStream.read(endianess: .littleEndian)
        
        /// Reserved (4 bytes): An unsigned integer that MUST be set to zero and MUST be ignored.
        self.reserved = try dataStream.read(endianess: .littleEndian)
        
        /// VendorId (4 bytes): This field MUST be ignored.
        self.vendorId = try dataStream.read(endianess: .littleEndian)
        
        /// Culture (4 bytes): An unsigned integer that MUST be set to zero and MUST be ignored.
        self.culture = try dataStream.read(endianess: .littleEndian)
        
        /// Panose (10 bytes): A Panose object (section 2.2.21) that specifies the PANOSE characteristics of the logical font.
        /// If all fields of this object are zero, it MUST be ignored.
        self.panose = try Panose(dataStream: &dataStream)
        
        /// Padding (2 bytes): A field that exists only to ensure 32-bit alignment of this structure. It MUST be ignored.
        self.padding = try dataStream.read(endianess: .littleEndian)
    }
}
