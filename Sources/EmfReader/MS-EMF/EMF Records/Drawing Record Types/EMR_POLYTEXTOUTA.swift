//
//  EMR_POLYTEXTOUTA.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.5.32 EMR_POLYTEXTOUTA Record
/// The EMR_POLYTEXTOUTA record draws one or more ASCII text strings using the current font and text colors.
/// Fields not specified in this section are specified in section 2.3.5.
/// The font and text colors used for output are specified by properties in the current state of EMF metafile playback (section 3.1).
/// EMR_POLYTEXTOUTA SHOULD<70> be emulated with a series of EMR_EXTTEXTOUTW records (section 2.3.5.7), one per string.
/// This requires the ASCII text string in each EmrText object to be converted to Unicode UTF16-LE encoding.
/// See section 2.3.5 for more drawing record types.
public struct EMR_POLYTEXTOUTA {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let iGraphicsMode: GraphicsMode
    public let exScale: Float
    public let eyScale: Float
    public let cStrings: UInt32
    public let aEmrText: [EmrText]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_POLYTEXTOUTA. This value is 0x00000060.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_POLYTEXTOUTA else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 32 && (size %  4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19), which is not used and MUST be ignored on receipt.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// GraphicsMode (4 bytes): An unsigned integer that specifies the current graphics mode, from the GraphicsMode enumeration
        /// (section 2.1.16).
        self.iGraphicsMode = try GraphicsMode(dataStream: &dataStream)
        
        /// exScale (4 bytes): A FLOAT value that specifies the X scale from page units to .01mm units if graphics mode is
        /// GM_COMPATIBLE.
        self.exScale = try dataStream.readFloat(endianess: .littleEndian)
        
        /// eyScale (4 bytes): A FLOAT value that specifies the Y scale from page units to .01mm units if graphics mode is
        /// GM_COMPATIBLE.
        self.eyScale = try dataStream.readFloat(endianess: .littleEndian)
        
        /// cStrings (4 bytes): An unsigned integer that specifies the number of EmrText objects.
        self.cStrings = try dataStream.read(endianess: .littleEndian)
        
        /// aEmrText (variable): An array of EmrText objects (section 2.2.5) that specify the output strings in 8-bit ASCII characters,
        /// with text attributes, and spacing values. The number of EmrText objects is specified by cStrings.
        var aEmrText: [EmrText] = []
        aEmrText.reserveCapacity(Int(self.cStrings))
        for _ in 0..<self.cStrings {
            aEmrText.append(try EmrText(dataStream: &dataStream,
                                        recordStartPosition: startPosition,
                                        recordSize: self.size,
                                        unicode: false))
        }
        
        self.aEmrText = aEmrText
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
 
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
