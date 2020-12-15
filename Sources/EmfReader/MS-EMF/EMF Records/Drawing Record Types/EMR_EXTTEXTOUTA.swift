//
//  EMR_EXTTEXTOUTA.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.5.7 EMR_EXTTEXTOUTA Record
/// The EMR_EXTTEXTOUTA record draws an ASCII text string using the current font and text colors.
/// Fields not specified in this section are specified in section 2.3.5.
/// The font and text colors used for output are specified by the state of the current graphics environment (section 3.1.1.2). A rectangle
/// for clipping and/or opaquing can be defined in the EmrText object in the aEmrText field.
/// This record SHOULD<64> be emulated with an EMR_EXTTEXTOUTW record (section 2.3.5.8), which requires the ASCII text string
/// in the EmrText object to be converted to Unicode UTF16-LE encoding.
/// See section 2.3.5 for more drawing record types.
public struct EMR_EXTTEXTOUTA {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let iGraphicsMode: GraphicsMode
    public let exScale: Float
    public let eyScale: Float
    public let aEmrText: EmrText
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_EXTTEXTOUTA. This value is 0x00000053.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_EXTTEXTOUTA else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x0000003C && size % 4 == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19), which is not used and MUST be ignored on receipt.
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
        
        /// aEmrText (variable): An EmrText object (section 2.2.5) that specifies the output string in 8-bit ASCII characters, text
        /// attributes, and spacing values.
        self.aEmrText = try EmrText(dataStream: &dataStream,
                                    recordStartPosition: startPosition,
                                    recordSize: self.size,
                                    unicode: false)
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
 
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
