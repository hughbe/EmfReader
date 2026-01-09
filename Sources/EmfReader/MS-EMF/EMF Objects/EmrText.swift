//
//  EmrText.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.2.5 EmrText Object
/// The EmrText object contains values for text output.
/// If the Options field of the EmrText object contains the ETO_PDY flag, then this buffer contains twice as many values as there are
/// characters in the output string, one horizontal and one vertical offset for each, in that order.
/// If ETO_RTLREADING is specified, characters are laid right to left instead of left to right. No other options affect the interpretation of
/// this field.
/// The size and encoding of the characters in the OutputString is determined by the type of record that contains this object, as follows:
///  EMR_EXTTEXTOUTA (section 2.3.5.7) and EMR_POLYTEXTOUTA (section 2.3.5.32) records: 8-bit ASCII characters.
///  EMR_EXTTEXTOUTW (section 2.3.5.8) and EMR_POLYTEXTOUTW (section 2.3.5.33) records: 16- bit Unicode UTF16-LE characters.
public struct EmrText {
    public let reference: PointL
    public let chars: UInt32
    public let offString: UInt32
    public let options: ExtTextOutOptions
    public let rectangle: RectL?
    public let offDx: UInt32
    public let string: String
    public let outputDx: [UInt32]?
    
    public init(dataStream: inout DataStream, recordStartPosition: Int, recordSize: UInt32, unicode: Bool) throws {
        /// Reference (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15) that specifies the coordinates of the reference point
        /// used to position the string. The reference point is defined by the last EMR_SETTEXTALIGN record (section 2.3.11.25).
        /// If no such record has been set, the default alignment is (TA_LEFT, TA_TOP), which is specified using TextAlignmentMode
        /// flags ([MS-WMF] section 2.1.2.3).
        self.reference = try PointL(dataStream: &dataStream)
        
        /// Chars (4 bytes): An unsigned integer that specifies the number of characters in the string.
        let chars: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.chars = chars
        
        /// offString (4 bytes): An unsigned integer that specifies the offset to the output string in bytes, from the start of the record
        /// in which this object is contained. This value is 8- or 16-bit aligned, according to the character format.
        let offString: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offString = offString
        
        /// Options (4 bytes): An unsigned integer that specifies how to use the rectangle specified in the Rectangle field. This field
        /// can be a combination of more than one ExtTextOutOptions enumeration (section 2.1.11) values.
        let options = try ExtTextOutOptions(dataStream: &dataStream)
        self.options = options
        
        /// Rectangle (16 bytes, optional): A RectL object ([MS-WMF] section 2.2.2.19) that defines a clipping and/or opaquing
        /// rectangle in logical units. This rectangle is applied to the text output performed by the containing record.<44>
        if !options.contains(.noRect) {
            self.rectangle = try RectL(dataStream: &dataStream)
        } else {
            self.rectangle = nil
        }
        
        /// offDx (4 bytes): An unsigned integer that specifies the offset to an intercharacter spacing array in bytes, from the start of
        /// the record in which this object is contained. This value is 32-bit aligned.
        let offDx: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard (offDx % 4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.offDx = offDx
        
        let lengthOfFixedData = dataStream.position - recordStartPosition
        
        /// StringBuffer (variable): The character string buffer.
        /// UndefinedSpace1 (variable, optional): The number of unused bytes. The OutputString field is not required to follow
        /// immediately the preceding portion of this structure.
        /// OutputString (variable): An array of characters that specify the string to output. The location of this field is specified by the
        /// value of offString in bytes from the start of this record. The number of characters is specified by the value of Chars.
        if offString != 0 && chars != 0 {
            let byteCount = unicode ? self.chars * 2 : self.chars
            guard offString >= lengthOfFixedData &&
                    offString + byteCount <= recordSize else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position = recordStartPosition + Int(offString)
            self.string = try dataStream.readString(count: Int(byteCount), encoding: unicode ? .utf16LittleEndian : .ascii) ?? ""
        } else {
            self.string = ""
        }
        
        /// DxBuffer (variable, optional): The character spacing buffer.
        /// UndefinedSpace2 (variable, optional): The number of unused bytes. The OutputDx field is not required to follow immediately
        /// the preceding portion of this structure.
        /// OutputDx (variable): An array of 32-bit unsigned integers that specify the output spacing between the origins of adjacent
        /// character cells in logical units. The location of this field is specified by the value of offDx in bytes from the start of this record.
        /// If spacing is defined, this field contains the same number of values as characters in the output string.
        if offDx != 0 {
            let length = options.contains(.pdy) ? self.string.count * 2 : self.string.count
            guard offString >= lengthOfFixedData &&
                    offString + UInt32(length) * 4 <= recordSize else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position = recordStartPosition + Int(offDx)
            var outputDx: [UInt32] = []
            outputDx.reserveCapacity(length)
            for _ in 0..<length {
                outputDx.append(try dataStream.read(endianess: .littleEndian))
            }
            
            self.outputDx = outputDx
        } else {
            self.outputDx = nil
        }
    }
}
