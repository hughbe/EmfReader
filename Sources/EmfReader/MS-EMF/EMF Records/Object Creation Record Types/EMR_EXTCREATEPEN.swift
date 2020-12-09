//
//  EMR_EXTCREATEPEN.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.7.9 EMR_EXTCREATEPEN Record
/// The EMR_EXTCREATEPEN record defines an extended logical pen for graphics operations. An optional DIB can be specified to use
/// as the line style.
/// Fields not specified in this section are specified in section 2.3.7.
/// The extended logical pen object defined by this record can be selected into the playback device context by an EMR_SELECTOBJECT
/// record (section 2.3.8.5), which specifies the logical pen to use in subsequent graphics operations.
/// See section 2.3.7 for more object creation record types.
public struct EMR_EXTCREATEPEN {
    public let type: RecordType
    public let size: UInt32
    public let ihPen: UInt32
    public let offBmi: UInt32
    public let cbBmi: UInt32
    public let offBits: UInt32
    public let cbBits: UInt32
    public let elp: LogPenEx
    public let bmiSrc: [UInt8]?
    public let bitsSrc: [UInt8]?
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_EXTCREATEPEN. This value is 0x0000005F.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_EXTCREATEPEN else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes, of this record.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 52 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// ihPen (4 bytes): An unsigned integer that specifies the index of the extended logical pen object in the EMF object table
        /// (section 3.1.1.1). This index MUST be saved so that this object can be reused or modified.
        self.ihPen = try dataStream.read(endianess: .littleEndian)
        
        /// offBmi (4 bytes): An unsigned integer that specifies the offset from the start of this record to the DIB header if the record
        /// contains a DIB.
        let offBmi: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offBmi = offBmi
        
        /// cbBmi (4 bytes): An unsigned integer that specifies the size of the DIB header if the record contains a DIB.
        let cbBmi: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.cbBmi = cbBmi
        
        /// offBits (4 bytes): An unsigned integer that specifies the offset from the start of this record to the bits if the record contains
        /// a DIB.
        let offBits: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offBits = offBits
        
        /// cbBits (4 bytes): An unsigned integer that specifies the size of the DIB bits if the record contains a DIB.
        let cbBits: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.cbBits = cbBits
        
        /// elp (variable): A LogPenEx object (section 2.2.20) that specifies an extended logical pen with attributes including an optional
        /// line style array.
        self.elp = try LogPenEx(dataStream: &dataStream, startPosition: startPosition, size: self.size)
        
        /// BmiSrc (variable): The DIB header, which is the DibHeaderInfo field of a DeviceIndependentBitmap object.
        if offBmi != 0 && cbBmi != 0 {
            guard offBmi >= 52 &&
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
            guard offBits >= 52 &&
                    offBits + cbBits <= size else {
                throw EmfReadError.corrupted
            }
            
            dataStream.position = startPosition + Int(self.offBits)
            self.bitsSrc = try dataStream.readBytes(count: Int(self.cbBits))
        } else {
            self.bitsSrc = nil
        }
        
        /// Seen garbage at the end.
        try dataStream.readRestOfRecord(startPosition: startPosition, size: self.size)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
