//
//  EMR_SMALLTEXTOUT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.37 EMR_SMALLTEXTOUT Record
/// The EMR_SMALLTEXTOUT record outputs a string.
/// If ETO_SMALL_CHARS is set in the fuOptions field, TextString contains 8-bit codes for characters, derived from the low bytes of
/// Unicode UTF16-LE character codes, in which the high byte is assumed to be 0.
/// If ETO_NO_RECT is set in the fuOptions field, the Bounds field is not included in the record.
/// See section 2.3.5 for more drawing record types.
public struct EMR_SMALLTEXTOUT {
    public let type: RecordType
    public let size: UInt32
    public let x: Int32
    public let y: Int32
    public let cChars: UInt32
    public let fuOptions: ExtTextOutOptions
    public let iGraphicsMode: GraphicsMode
    public let exScale: Float
    public let eyScale: Float
    public let bounds: RectL?
    public let textString: String
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SMALLTEXTOUT. This value is 0x0000006C.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SMALLTEXTOUT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 36 && (size %  4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// x (4 bytes): A signed integer specifying the x-coordinate of where to place the string.
        self.x = try dataStream.read(endianess: .littleEndian)
        
        /// y (4 bytes): A signed integer specifying the y-coordinate of where to place the string.
        self.y = try dataStream.read(endianess: .littleEndian)
        
        /// cChars (4 bytes): An unsigned integer specifying the number of 16-bit characters in the string. The string is NOT
        /// null-terminated.
        self.cChars = try dataStream.read(endianess: .littleEndian)
        
        /// fuOptions (4 bytes): An unsigned integer specifying the text output options to use. These options are specified by one or a
        /// combination of values from the ExtTextOutOptions enumeration (section 2.1.11).
        self.fuOptions = try ExtTextOutOptions(dataStream: &dataStream)
        let hasRectangle = !self.fuOptions.contains(.noRect)
        let wideString = !self.fuOptions.contains(.smallChars)
        guard 36 + (wideString ? 2 * self.cChars : self.cChars) + (hasRectangle ? 16 : 0) <= size else {
            throw EmfReadError.corrupted
        }
        
        /// iGraphicsMode (4 bytes): An unsigned integer specifying the graphics mode, from the GraphicsMode enumeration
        /// (section 2.1.16).
        self.iGraphicsMode = try GraphicsMode(dataStream: &dataStream)
        
        /// exScale (4 bytes): A FLOAT value that specifies how much to scale the text in the x-direction.
        self.exScale = try dataStream.readFloat(endianess: .littleEndian)
        
        /// eyScale (4 bytes): A FLOAT value that specifies how much to scale the text in the y-direction.
        self.eyScale = try dataStream.readFloat(endianess: .littleEndian)
        
        /// Bounds (16 bytes, optional): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the bounding rectangle in logical
        /// units.
        if hasRectangle {
            self.bounds = try RectL(dataStream: &dataStream)
        } else {
            self.bounds = nil
        }
        
        /// TextString (variable): A string that contains the text string to draw, in either 8-bit or 16-bit character codes, according to the
        /// value of the fuOptions field.
        if wideString {
            self.textString = try dataStream.readString(count: Int(self.cChars) * 2, encoding: .utf16LittleEndian)!
        } else {
            self.textString = try dataStream.readString(count: Int(self.cChars), encoding: .ascii)!
        }
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
