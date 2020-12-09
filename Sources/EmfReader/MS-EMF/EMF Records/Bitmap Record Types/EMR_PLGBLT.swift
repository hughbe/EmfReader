//
//  EMR_PLGBLT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.1.4 EMR_PLGBLT Record
/// The EMR_PLGBLT record specifies a block transfer of pixels from a source bitmap to a destination parallelogram, with the application
/// of a color mask bitmap.
/// Fields not specified in this section are specified in section 2.3.1.
/// The mask bitmap MUST be monochrome; that is, each pixel value MUST be zero or one. A pixel value of one in the mask indicates
/// that the color of the corresponding pixel in the source bitmap SHOULD be copied to the destination. A value of zero in the mask
/// indicates that the destination pixel color SHOULD NOT be changed. If the mask rectangle is smaller than the source and destination
/// rectangles, the mask pattern MUST be replicated as necessary.
/// See section 2.3.1 for more bitmap record types.
public struct EMR_PLGBLT {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let aptlDest: [PointL]
    public let xSrc: Int32
    public let ySrc: Int32
    public let cxSrc: Int32
    public let cySrc: Int32
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
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_PLGBLT. This value is 0x0000004F.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_PLGBLT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 128 && (size %  4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the destination bounding rectangle in logical
        /// coordinates. If the intersection of this rectangle with the current clipping regions (section 3.1.1.2.1) in the playback device
        /// context (section 3.1) is empty, this record has no effect.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// aptlDest (24 bytes): An array of three PointL objects ([MS-WMF] section 2.2.2.15) that specifies three corners a
        /// parallelogram destination area for the block transfer.
        /// The upper-left corner of the source rectangle is mapped to the first point in this array, the upperright corner to the second
        /// point, and the lower-left corner to the third point. The lower-right corner of the source rectangle is mapped to the implicit
        /// fourth point in the parallelogram, which is computed from the first three points (A, B, and C) by treating them as vectors.
        /// D = B + C A
        self.aptlDest = [
            try PointL(dataStream: &dataStream),
            try PointL(dataStream: &dataStream),
            try PointL(dataStream: &dataStream)
       ]
        
        /// xSrc (4 bytes): A signed integer that specifies the logical x-coordinate of the upper-left corner of the source rectangle.
        self.xSrc = try dataStream.read(endianess: .littleEndian)
        
        /// ySrc (4 bytes): A signed integer that specifies the logical y-coordinate of the upper-left corner of the source rectangle.
        self.ySrc = try dataStream.read(endianess: .littleEndian)
        
        /// cxSrc (4 bytes): A signed integer that specifies the logical width of the source rectangle.
        self.cxSrc = try dataStream.read(endianess: .littleEndian)
        
        /// cySrc (4 bytes): A signed integer that specifies the logical height of the source rectangle.
        self.cySrc = try dataStream.read(endianess: .littleEndian)
        
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
            guard offBmiSrc >= 128 &&
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
            guard offBitsSrc >= 128 &&
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
            guard offBmiMask >= 128 &&
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
            guard offBitsMask >= 128 &&
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
