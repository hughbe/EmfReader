//
//  EMR_MASKBLT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.1.3 EMR_MASKBLT Record
/// The EMR_MASKBLT record specifies a block transfer of pixels from a source bitmap to a destination rectangle, optionally in
/// combination with a brush pattern and with the application of a color mask bitmap, according to specified foreground and background
/// raster operations.
/// Fields not specified in this section are specified in section 2.3.1.
/// The mask bitmap MUST be monochrome; that is, each pixel value MUST be zero or one. A pixel value of one in the mask indicates
/// that the color of the corresponding pixel in the source bitmap SHOULD be copied to the destination. A value of zero in the mask
/// indicates that the destination pixel color SHOULD NOT be changed. If the mask rectangle is smaller than the source and destination
/// rectangles, the mask pattern MUST be replicated as necessary.
/// See section 2.3.1 for more bitmap record types.
public struct EMR_MASKBLT {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let xDest: Int32
    public let yDest: Int32
    public let cxDest: Int32
    public let cyDest: Int32
    public let reserved: UInt16
    public let backgroundROP3: UInt8
    public let foregroundROP3: UInt8
    public let xSrc: UInt32
    public let ySrc: UInt32
    public let xformSrc: XForm
    public let bkColorSrc: ColorRef
    public let usageSrc: DIBColors
    public let offBmiSrc: UInt32
    public let cbBmiSrc: UInt32
    public let offBitsSrc: UInt32
    public let cbBitsSrc: UInt32
    public let xMask: Int32
    public let yMask: Int32
    public let usageMask: DIBColors
    public let offBmiMask: UInt32
    public let cbBmiMask: UInt32
    public let offBitsMask: UInt32
    public let cbBitsMask: UInt32
    public let bmiSrc: [UInt8]?
    public let bitsSrc: [UInt8]?
    public let bmiMask: [UInt8]?
    public let bitsMask: [UInt8]?
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_MASKBLT. This value is 0x0000004E.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_MASKBLT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000080 && size % 4 == 0 else {
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
        
        /// cxDest (4 bytes): A signed integer that specifies the logical width of the source and destination rectangles.
        self.cxDest = try dataStream.read(endianess: .littleEndian)
        
        /// cyDest (4 bytes): A signed integer that specifies the logical height of the source and destination rectangles.
        self.cyDest = try dataStream.read(endianess: .littleEndian)
        
        /// Reserved (2 bytes): This field SHOULD be 0x0000 and MUST be ignored.<57>
        self.reserved = try dataStream.read(endianess: .littleEndian)
        
        /// BackgroundROP3 (1 byte): The unsigned, most-significant 8 bits of a 24-bit ternary raster operation value from the
        /// Ternary Raster Operation enumeration ([MS-WMF] section 2.1.1.31).
        /// This code defines how to combine the background color data of the source and destination bitmaps and brush pattern.
        self.backgroundROP3 = try dataStream.read()
        
        /// ForegroundROP3 (1 byte): The unsigned, most-significant 8 bits of a 24-bit ternary raster operation value from the Ternary
        /// Raster Operation enumeration. This code defines how to combine the foreground color data of the source and destination
        /// bitmaps and brush pattern.
        self.foregroundROP3 = try dataStream.read()
        
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
        
        /// offBmiSrc (4 bytes): An unsigned integer that specifies the offset in bytes, from the start of this record to the source bitmap
        /// header in the BitmapBuffer field.
        let offBmiSrc: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offBmiSrc = offBmiSrc
        
        /// cbBmiSrc (4 bytes): An unsigned integer that specifies the size in bytes of the source bitmap header.
        let cbBmiSrc: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.cbBmiSrc = cbBmiSrc
        
        /// offBitsSrc (4 bytes): An unsigned integer that specifies the offset in bytes, from the start of this record to the source bitmap
        /// bits in the BitmapBuffer field.
        let offBitsSrc: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offBitsSrc = offBitsSrc
        
        /// cbBitsSrc (4 bytes): An unsigned integer that specifies the size in bytes, of the source bitmap bits.
        let cbBitsSrc: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.cbBitsSrc = cbBitsSrc
        
        /// xMask (4 bytes): A signed integer that specifies the logical x-coordinate of the upper-left corner of the mask bitmap.
        self.xMask = try dataStream.read(endianess: .littleEndian)
        
        /// yMask (4 bytes): A signed integer that specifies the logical y-coordinate of the upper-left corner of the mask bitmap.
        self.yMask = try dataStream.read(endianess: .littleEndian)
        
        /// UsageMask (4 bytes): An unsigned integer that specifies how to interpret values in the color table in the mask bitmap header.
        /// This value is in the DIBColors enumeration.
        self.usageMask = try DIBColors(dataStream: &dataStream)
        
        /// offBmiMask (4 bytes): An unsigned integer that specifies the offset in bytes, from the start of this record to the mask bitmap
        /// header in the BitmapBuffer field.
        let offBmiMask: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offBmiMask = offBmiMask
        
        /// cbBmiMask (4 bytes): An unsigned integer that specifies the size in bytes, of the mask bitmap header.
        let cbBmiMask: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.cbBmiMask = cbBmiMask
        
        /// offBitsMask (4 bytes): An unsigned integer that specifies the offset in bytes, from the start of this record to the mask bitmap
        /// bits in the BitmapBuffer field.
        let offBitsMask: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offBitsMask = offBitsMask
        
        /// cbBitsMask (4 bytes): An unsigned integer that specifies the size in bytes, of the mask bitmap bits.
        let cbBitsMask: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.cbBitsMask = cbBitsMask
        
        /// BmiSrc (variable): The source bitmap header.
        if offBmiSrc != 0 && cbBmiSrc != 0 {
            guard offBmiSrc >= 0x00000080 &&
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
            guard offBitsSrc >= 0x00000080 &&
                    offBitsSrc + cbBitsSrc <= size else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position = startPosition + Int(self.offBitsSrc)
            self.bitsSrc = try dataStream.readBytes(count: Int(self.cbBitsSrc))
        } else {
            self.bitsSrc = nil
        }

        /// BmiMask (variable): The mask bitmap header.
        if offBmiMask != 0 && cbBmiMask != 0 {
            guard offBmiMask >= 0x00000080 &&
                    offBmiMask + cbBmiMask <= size else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position = startPosition + Int(offBmiMask)
            self.bmiMask = try dataStream.readBytes(count: Int(self.cbBmiMask))
        } else {
            self.bmiMask = nil
        }
        
        /// BitsMask (variable): The mask bitmap bits.
        if offBitsMask != 0 && cbBitsMask != 0 {
            guard offBitsMask >= 0x00000080 &&
                    offBitsMask + cbBitsMask <= size else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position = startPosition + Int(self.offBitsMask)
            self.bitsMask = try dataStream.readBytes(count: Int(self.cbBitsMask))
        } else {
            self.bitsMask = nil
        }
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
