//
//  EMR_STRETCHDIBITS.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.1.7 EMR_STRETCHDIBITS Record
/// The EMR_STRETCHDIBITS record specifies a block transfer of pixels from a source bitmap to a destination rectangle, optionally in
/// combination with a brush pattern, according to a specified raster operation, stretching or compressing the output to fit the
/// dimensions of the destination, if necessary.
/// Fields not specified in this section are specified in section 2.3.1.
/// This record supports source images in JPEG and PNG formats. The Compression field in the source bitmap header specifies the
/// image format.
/// If the signs of the source and destination height and width fields differ, this record specifies a mirrorimage copy of the source bitmap
/// to the destination. That is, if cxSrc and cxDest have different signs, a mirror image of the source bitmap along the x-axis is specified.
/// If cySrc and cyDest have different signs, a mirror image of the source bitmap along the y-axis is specified.
/// See section 2.3.1 for more bitmap record types.
public struct EMR_STRETCHDIBITS {
    public let type: RecordType
    public let size: UInt32
    public let bounds: RectL
    public let xDest: Int32
    public let yDest: Int32
    public let xSrc: Int32
    public let ySrc: Int32
    public let cxSrc: Int32
    public let cySrc: Int32
    public let offBmiSrc: UInt32
    public let cbBmiSrc: UInt32
    public let offBitsSrc: UInt32
    public let cbBitsSrc: UInt32
    public let usageSrc: DIBColors
    public let bitBltRasterOperation: UInt32
    public let cxDest: UInt32
    public let cyDest: UInt32
    public let bmiSrc: [UInt8]?
    public let bitsSrc: [UInt8]?
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_STRETCHDIBITS. This value is 0x00000051.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_STRETCHDIBITS else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000050 && size % 4 == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the destination bounding rectangle in
        /// logical coordinates. If the intersection of this rectangle with the current clipping regions (section 3.1.1.2.1) in the playback
        /// device context (section 3.1) is empty, this record has no effect.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// xDest (4 bytes): A signed integer that specifies the logical x-coordinate of the upper-left corner of the destination rectangle.
        self.xDest = try dataStream.read(endianess: .littleEndian)
        
        /// yDest (4 bytes): A signed integer that specifies the logical y-coordinate of the upper-left corner of the destination rectangle.
        self.yDest = try dataStream.read(endianess: .littleEndian)
        
        /// xSrc (4 bytes): A signed integer that specifies the x-coordinate in pixels of the upper-left corner of the source rectangle.
        self.xSrc = try dataStream.read(endianess: .littleEndian)
        
        /// ySrc (4 bytes): A signed integer that specifies the y-coordinate in pixels of the upper-left corner of the source rectangle.
        self.ySrc = try dataStream.read(endianess: .littleEndian)
        
        /// cxSrc (4 bytes): A signed integer that specifies the width in pixels of the source rectangle.
        self.cxSrc = try dataStream.read(endianess: .littleEndian)
        
        /// cySrc (4 bytes): A signed integer that specifies the height in pixels of the source rectangle.
        self.cySrc = try dataStream.read(endianess: .littleEndian)
        
        /// offBmiSrc (4 bytes): An unsigned integer that specifies the offset in bytes from the start of this record to the source bitmap
        /// header.
        let offBmiSrc: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offBmiSrc = offBmiSrc
        
        /// cbBmiSrc (4 bytes): An unsigned integer that specifies the size in bytes, of the source bitmap header.
        let cbBmiSrc: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.cbBmiSrc = cbBmiSrc
        
        /// offBitsSrc (4 bytes): An unsigned integer that specifies the offset in bytes, from the start of this record to the source bitmap
        /// bits.
        let offBitsSrc: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offBitsSrc = offBitsSrc
        
        /// cbBitsSrc (4 bytes): An unsigned integer that specifies the size in bytes, of the source bitmap bits.
        let cbBitsSrc: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.cbBitsSrc = cbBitsSrc

        /// UsageSrc (4 bytes): An unsigned integer that specifies how to interpret values in the color table in the source bitmap header.
        /// This value is in the DIBColors enumeration (section 2.1.9).
        self.usageSrc = try DIBColors(dataStream: &dataStream)
        
        /// BitBltRasterOperation (4 bytes): An unsigned integer that specifies a raster operation code. These codes define how the
        /// color data of the source rectangle is to be combined with the color data of the destination rectangle and optionally a
        /// brush pattern, to achieve the final color.
        /// This value is in the Ternary Raster Operation enumeration ([MS-WMF] section 2.1.1.31).
        self.bitBltRasterOperation = try dataStream.read(endianess: .littleEndian)
        
        /// cxDest (4 bytes): A signed integer that specifies the logical width of the destination rectangle.
        self.cxDest = try dataStream.read(endianess: .littleEndian)
        
        /// cyDest (4 bytes): A signed integer that specifies the logical height of the destination rectangle.
        self.cyDest = try dataStream.read(endianess: .littleEndian)
        
        /// BmiSrc (variable): The source bitmap header.
        if offBmiSrc != 0 && cbBmiSrc != 0 {
            guard offBmiSrc >= 0x00000050 &&
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
            guard offBitsSrc >= 0x00000050 &&
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
