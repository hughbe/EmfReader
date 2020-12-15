//
//  EMR_CREATEMONOBRUSH.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.7.5 EMR_CREATEMONOBRUSH Record
/// The EMR_CREATEMONOBRUSH record defines a monochrome pattern brush for graphics operations.
/// The pattern is specified by a monochrome DIB.
/// Fields not specified in this section are specified in section 2.3.7.
/// The monochrome pattern brush object defined by this record can be selected into the playback device context by an
/// EMR_SELECTOBJECT record (section 2.3.8.5), which specifies the pattern brush to use in subsequent graphics operations.
/// See section 2.3.7 for more object creation record types.
public struct EMR_CREATEMONOBRUSH {
    public let type: RecordType
    public let size: UInt32
    public let ihBrush: UInt32
    public let usage: DIBColors
    public let offBmi: UInt32
    public let cbBmi: UInt32
    public let offBits: UInt32
    public let cbBits: UInt32
    public let bmiSrc: [UInt8]?
    public let bitsSrc: [UInt8]?
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_CREATEMONOBRUSH. This value is 0x0000005D.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_CREATEMONOBRUSH else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes, of this record.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000020 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// ihBrush (4 bytes): An unsigned integer that specifies the index of the monochrome pattern brush object in the EMF object
        /// table (section 3.1.1.1). This index MUST be saved so that this object can be reused or modified.
        self.ihBrush = try dataStream.read(endianess: .littleEndian)
        
        /// Usage (4 bytes): An unsigned integer that specifies how to interpret values in the color table in the DIB header. This value
        /// is in the DIBColors enumeration (section 2.1.9).
        self.usage = try DIBColors(dataStream: &dataStream)
        
        /// offBmi (4 bytes): An unsigned integer that specifies the offset from the start of this record to the DIB header.
        let offBmi: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offBmi = offBmi
        
        /// cbBmi (4 bytes): An unsigned integer that specifies the size of the DIB header.
        let cbBmi: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.cbBmi = cbBmi
        
        /// offBits (4 bytes): An unsigned integer that specifies the offset from the start of this record to the DIB bits.
        let offBits: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offBits = offBits
        
        /// cbBits (4 bytes): An unsigned integer that specifies the size of the DIB bits.
        let cbBits: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.cbBits = cbBits
        
        /// BmiSrc (variable): The DIB header, which is the DibHeaderInfo field of a DeviceIndependentBitmap object.
        if offBmi != 0 && cbBmi != 0 {
            guard offBmi >= 32 &&
                    offBmi + cbBmi <= size else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position = startPosition + Int(offBmi)
            self.bmiSrc = try dataStream.readBytes(count: Int(self.cbBmi))
        } else {
            self.bmiSrc = nil
        }
        
        /// BitsSrc (variable): The DIB bits, which is the aData field of a DeviceIndependentBitmap object.
        if offBits != 0 && cbBits != 0 {
            guard offBits >= 32 &&
                    offBits + cbBits <= size else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position = startPosition + Int(self.offBits)
            self.bitsSrc = try dataStream.readBytes(count: Int(self.cbBits))
        } else {
            self.bitsSrc = nil
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
