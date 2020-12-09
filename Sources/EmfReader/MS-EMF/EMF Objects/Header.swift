//
//  Header.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.2.9 Header Object
/// The Header object defines the EMF metafile header. It specifies properties of the device on which the image in the metafile was created.
public struct Header {
    public let bounds: RectL
    public let frame: RectL
    public let recordSignature: FormatSignature
    public let version: UInt32
    public let bytes: UInt32
    public let records: UInt32
    public let handles: UInt16
    public let reserved: UInt16
    public let nDescription: UInt32
    public let offDescription: UInt32
    public let nPalEntries: UInt32
    public let device: SizeL
    public let millimeters: SizeL
    
    public init(dataStream: inout DataStream) throws {
        /// Bounds (16 bytes): A RectL object ([MS-WMF] section 2.2.2.19) that specifies the rectangular inclusive-inclusive bounds
        /// in logical units of the smallest rectangle that can be drawn around the image stored in the metafile.
        self.bounds = try RectL(dataStream: &dataStream)
        
        /// Frame (16 bytes): A RectL object that specifies the rectangular inclusive-inclusive dimensions, in .01 millimeter units, of a
        /// rectangle that surrounds the image stored in the metafile.
        self.frame = try RectL(dataStream: &dataStream)
        
        /// RecordSignature (4 bytes): An unsigned integer that specifies the record signature. This MUST be ENHMETA_SIGNATURE,
        /// from the FormatSignature enumeration (section 2.1.14).
        self.recordSignature = try FormatSignature(dataStream: &dataStream)
        guard self.recordSignature == .ENHMETA_SIGNATURE else {
            throw MetafileReadError.corrupted
        }
        
        /// Version (4 bytes): An unsigned integer that specifies the EMF version for interoperability. This MAY be 0x00010000.
        self.version = try dataStream.read(endianess: .littleEndian)
        
        /// Bytes (4 bytes): An unsigned integer that specifies the size of the metafile in bytes.
        self.bytes = try dataStream.read(endianess: .littleEndian)
        guard (self.bytes % 4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        /// Records (4 bytes): An unsigned integer that specifies the number of records in the metafile.
        self.records = try dataStream.read(endianess: .littleEndian)
        
        /// Handles (2 bytes): An unsigned integer that specifies the number of graphics objects that are used during the processing
        /// of the metafile.
        self.handles = try dataStream.read(endianess: .littleEndian)
        guard self.handles != 0 else {
            throw MetafileReadError.corrupted
        }
        
        /// Reserved (2 bytes): An unsigned integer that MUST be 0x0000 and MUST be ignored.
        self.reserved = try dataStream.read(endianess: .littleEndian)
        
        /// nDescription (4 bytes): An unsigned integer that specifies the number of characters in the array that contains the
        /// description of the metafile's contents. This is zero if there is no description string.
        self.nDescription = try dataStream.read(endianess: .littleEndian)
        
        /// offDescription (4 bytes): An unsigned integer that specifies the offset from the beginning of this record to the array that
        /// contains the description of the metafile's contents.
        self.offDescription = try dataStream.read(endianess: .littleEndian)
    
        /// nPalEntries (4 bytes): An unsigned integer that specifies the number of entries in the metafile palette. The palette is located
        /// in the EMR_EOF record.
        self.nPalEntries = try dataStream.read(endianess: .littleEndian)
        
        /// Device (8 bytes): A SizeL object ([MS-WMF] section 2.2.2.22) that specifies the size of the reference device, in pixels.
        self.device = try SizeL(dataStream: &dataStream)
        
        /// Millimeters (8 bytes): A SizeL object that specifies the size of the reference device, in millimeters
        self.millimeters = try SizeL(dataStream: &dataStream)
    }
}
