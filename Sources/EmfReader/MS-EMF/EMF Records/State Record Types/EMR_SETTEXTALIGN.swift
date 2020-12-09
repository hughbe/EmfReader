//
//  EMR_SETTEXTALIGN.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.11.25 EMR_SETTEXTALIGN Record
/// The EMR_SETTEXTALIGN record specifies text alignment for text drawing.
/// The EMR_SMALLTEXTOUT, EMR_EXTTEXTOUTA, and EMR_EXTTEXTOUTW records (section 2.3.5) use text alignment values to
/// position a string of text on the output medium. The values specify the relationship between a reference point and a rectangle that
/// bounds the text. The reference point is either the current drawing position or a point passed to a text output record.
/// The rectangle that bounds the text is formed by the character cells in the text string.
/// See section 2.3.11 for more state record types.
public struct EMR_SETTEXTALIGN {
    public let type: RecordType
    public let size: UInt32
    public let textAlignmentMode: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETTEXTALIGN. This value is 0x00000016.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETTEXTALIGN else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// TextAlignmentMode (4 bytes): An unsigned integer that specifies text alignment by using a mask of text alignment flags.
        /// These are either TextAlignmentMode flags ([MS-WMF] section 2.1.2.3) for text with a horizontal baseline, or
        /// VerticalTextAlignmentMode flags ([MS-WMF] section 2.1.2.4) for text with a vertical baseline. Only one value can be
        /// chosen from those that affect horizontal and vertical alignment.
        self.textAlignmentMode = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
