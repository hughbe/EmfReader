//
//  EMR_ALPHABLEND.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.1.1 EMR_ALPHABLEND Record
/// The EMR_ALPHABLEND record specifies a block transfer of pixels from a source bitmap to a destination rectangle, including alpha
/// transparency data, according to a specified blending operation.<56>
/// Fields not specified in this section are specified in section 2.3.1
/// See section 2.3.1 for more bitmap record types.
public struct EMR_ALPHABLEND {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let xDest: Int32
    public let yDest: Int32
    public let cxDest: Int32
    public let cyDest: Int32
    public let blendOperation: UInt8
    public let blendFlags: UInt8
    public let srcConstantAlpha: UInt8
    public let alphaFormat: UInt8
    public let xSrc: UInt32
    public let ySrc: UInt32
    public let xformSrc: XForm
    public let bkColorSrc: ColorRef
    public let usageSrc: DIBColors
    public let offBmiSrc: UInt32
    public let cbBmiSrc: UInt32
    public let offBitsSrc: UInt32
    public let cbBitsSrc: UInt32
    public let cxSrc: Int32
    public let cySrc: Int32
    public let bmiSrc: [UInt8]?
    public let bitsSrc: [UInt8]?
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_ALPHABLEND. This value is 0x00000072.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_ALPHABLEND else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 108 && (size %  4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the destination bounding rectangle in logical
        /// coordinates. If the intersection of this rectangle with the current clipping regions (section 3.1.1.2.1) in the playback device
        /// context (section 3.1) is empty, this record has no effect.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// xDest (4 bytes): A signed integer that specifies the logical x-coordinate of the upper-left corner of the destination rectangle.
        self.xDest = try dataStream.read(endianess: .littleEndian)
        
        /// yDest (4 bytes): A signed integer that specifies the logical y-coordinate of the upper-left corner of the destination rectangle.
        self.yDest = try dataStream.read(endianess: .littleEndian)
        
        /// cxDest (4 bytes): A signed integer that specifies the logical width of the destination rectangle.
        /// This value MUST be greater than zero.
        self.cxDest = try dataStream.read(endianess: .littleEndian)
        guard self.cxDest > 0 else {
            throw EmfReadError.corrupted
        }
        
        /// cyDest (4 bytes): A signed integer that specifies the logical height of the destination rectangle.
        /// This value MUST be greater than zero.
        self.cyDest = try dataStream.read(endianess: .littleEndian)
        guard self.cyDest > 0 else {
            throw EmfReadError.corrupted
        }
        
        /// BLENDFUNCTION (4 bytes): A structure that specifies the blending operations for source and destination bitmaps.
        /// BlendOperation (1 byte): The blend operation code. The only source and destination blend operation that has been defined
        /// is 0x00, which specifies that the source bitmap MUST be combined with the destination bitmap based on the alpha
        /// transparency values of the source pixels. See the following equations for details.
        self.blendOperation = try dataStream.read()
        
        /// BlendFlags (1 byte): This value is 0x00 and MUST be ignored.
        self.blendFlags = try dataStream.read()
        
        /// SrcConstantAlpha (1 byte): An unsigned integer that specifies alpha transparency, which determines the blend of the
        /// source and destination bitmaps. This value MUST be used on the entire source bitmap. The minimum alpha transparency
        /// value, zero, corresponds to completely transparent; the maximum value, 0xFF, corresponds to completely opaque. In
        /// effect, a value of 0xFF specifies that the per-pixel alpha values determine the blend of the source and destination bitmaps.
        /// See the equations later in this section for details.
        self.srcConstantAlpha = try dataStream.read()
        
        /// AlphaFormat (1 byte): A structure that specifies how source and destination pixels are interpreted with respect to alpha
        /// transparency.
        /// Value Meaning
        /// 0x00 The pixels in the source bitmap do not specify alpha transparency. In this case, the SrcConstantAlpha value determines
        /// the blend of the source and destination bitmaps.
        /// Note that in the following equations SrcConstantAlpha is divided by 255, which produces a value in the range 0 to 1.
        /// AC_SRC_ALPHA 0x01 Indicates that the source bitmap is 32 bits-per-pixel and specifies an alpha transparency value for
        /// each pixel.
        self.alphaFormat = try dataStream.read()
        
        /// xSrc (4 bytes): A signed integer that specifies the logical x-coordinate of the upper-left corner of the source rectangle.
        self.xSrc = try dataStream.read(endianess: .littleEndian)
        
        /// ySrc (4 bytes): A signed integer that specifies the logical y-coordinate of the upper-left corner of the source rectangle.
        self.ySrc = try dataStream.read(endianess: .littleEndian)
        
        /// XformSrc (24 bytes): An XForm object (section 2.2.28) that specifies a world-space to pagespace transform to apply to the
        /// source bitmap.
        self.xformSrc = try XForm(dataStream: &dataStream)
        
        /// BkColorSrc (4 bytes): A ColorRef object ([MS-WMF] section 2.2.2.8) that specifies the background color of the source
        /// bitmap.
        self.bkColorSrc = try ColorRef(dataStream: &dataStream)
        
        /// UsageSrc (4 bytes): An unsigned integer that specifies how to interpret values in the color table in the source bitmap header.
        /// This value is in the DIBColors enumeration (section 2.1.9).
        self.usageSrc = try DIBColors(dataStream: &dataStream)
        
        /// offBmiSrc (4 bytes): An unsigned integer that specifies the offset in bytes from the start of this record to the source bitmap
        /// header in the BitmapBuffer field.
        let offBmiSrc: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offBmiSrc = offBmiSrc
        
        /// cbBmiSrc (4 bytes): An unsigned integer that specifies the size in bytes of the source bitmap header.
        let cbBmiSrc: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.cbBmiSrc = cbBmiSrc
        
        /// offBitsSrc (4 bytes): An unsigned integer that specifies the offset in bytes from the start of this record to the source bitmap
        /// bits in the BitmapBuffer field.
        let offBitsSrc: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offBitsSrc = offBitsSrc
        
        /// cbBitsSrc (4 bytes): An unsigned integer that specifies the size in bytes of the source bitmap bits.
        let cbBitsSrc: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.cbBitsSrc = cbBitsSrc
        
        /// cxSrc (4 bytes): A signed integer that specifies the logical width of the source rectangle.
        /// This value MUST be greater than zero.
        self.cxSrc = try dataStream.read(endianess: .littleEndian)
        guard self.cxSrc > 0 else {
            throw EmfReadError.corrupted
        }
        
        /// cySrc (4 bytes): A signed integer that specifies the logical height of the source rectangle.
        /// This value MUST be greater than zero.
        self.cySrc = try dataStream.read(endianess: .littleEndian)
        guard self.cySrc > 0 else {
            throw EmfReadError.corrupted
        }
        
        /// BmiSrc (variable): The source bitmap header.
        if offBmiSrc != 0 && cbBmiSrc != 0 {
            guard offBmiSrc >= 108 &&
                    offBmiSrc + cbBmiSrc <= size else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position = startPosition + Int(offBmiSrc)
            self.bmiSrc = try dataStream.readBytes(count: Int(self.cbBmiSrc))
        } else {
            self.bmiSrc = nil
        }
        
        /// BitsSrc (variable): The source bitmap bits.
        if offBitsSrc != 0 && cbBitsSrc != 0 {
            guard offBitsSrc >= 108 &&
                    offBitsSrc + cbBitsSrc <= size else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position = startPosition + Int(self.offBitsSrc)
            self.bitsSrc = try dataStream.readBytes(count: Int(self.cbBitsSrc))
        } else {
            self.bitsSrc = nil
        }
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
