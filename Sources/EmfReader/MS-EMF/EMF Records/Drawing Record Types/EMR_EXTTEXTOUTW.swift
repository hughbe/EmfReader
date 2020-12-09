//
//  EMR_EXTTEXTOUTW.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.8 EMR_EXTTEXTOUTW Record
/// The EMR_EXTTEXTOUTW record draws a Unicode text string using the current font and text colors.
/// Fields not specified in this section are specified in section 2.3.5.
/// The font and text colors used for output are specified by properties in the current state of EMF metafile playback (section 3.1).
/// A rectangle for clipping and/or opaquing can be defined in the EmrText object that is specified in the aEmrText field.
/// See section 2.3.5 for more drawing record types.
public struct EMR_EXTTEXTOUTW {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let iGraphicsMode: GraphicsMode
    public let exScale: Float
    public let eyScale: Float
    public let wEmrText: EmrText
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_EXTTEXTOUTW. This value is 0x00000054.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_EXTTEXTOUTW else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 28 && (size %  4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19). It is not used and MUST be ignored on receipt.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// iGraphicsMode (4 bytes): An unsigned integer that specifies the current graphics mode from the GraphicsMode enumeratio
        /// (section 2.1.16).
        self.iGraphicsMode = try GraphicsMode(dataStream: &dataStream)
        
        /// exScale (4 bytes): A FLOAT value that specifies the scale factor to apply along the X axis to convert from page space units
        /// to .01mm units. This is used only if the graphics mode specified by iGraphicsMode is GM_COMPATIBLE.
        self.exScale = try dataStream.readFloat(endianess: .littleEndian)
        
        /// eyScale (4 bytes): A FLOAT value that specifies the scale factor to apply along the Y axis to convert from page space units
        /// to .01mm units. This is used only if the graphics mode specified by iGraphicsMode is GM_COMPATIBLE.
        self.eyScale = try dataStream.readFloat(endianess: .littleEndian)
        
        /// wEmrText (variable): An EmrText object (section 2.2.5) that specifies the output string in Unicode UTF16-LE characters, with
        /// text attributes and spacing values.
        self.wEmrText = try EmrText(dataStream: &dataStream,
                                    recordStartPosition: startPosition,
                                    recordSize: self.size,
                                    unicode: true)
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
