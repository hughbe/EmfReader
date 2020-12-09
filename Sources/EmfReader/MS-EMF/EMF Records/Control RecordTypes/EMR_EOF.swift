//
//  EMR_EOF.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.4.1 EMR_EOF Record
/// The EMR_EOF record indicates the end of the metafile and specifies a palette.
/// Fields not specified in this section are specified in section 2.3.4.
public struct EMR_EOF {
    public let type: UInt32
    public let size: UInt32
    public let nPalEntries: UInt32
    public let offPalEntries: UInt32
    public let paletteEntries: [LogPaletteEntry]?
    public let sizeLast: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_EOF. This value is 0x0000000E.
        self.type = try dataStream.read(endianess: .littleEndian)
        guard self.type == RecordType.EMR_EOF.rawValue else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 16 && (size % 4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// nPalEntries (4 bytes): An unsigned integer that specifies the number of palette entries.
        let nPalEntries: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.nPalEntries = nPalEntries
        
        /// offPalEntries (4 bytes): An unsigned integer that specifies the offset to the palette entries from the start of this record.
        let offPalEntries: UInt32 = try dataStream.read(endianess: .littleEndian)
        self.offPalEntries = offPalEntries
        
        /// PaletteBuffer (variable, optional): An array of bytes that contains palette data, which is not required to be contiguous with
        /// the fixed-length portion of the EMR_EOF record. Thus, fields in this buffer that are labeled "UndefinedSpace" are optional
        /// and MUST be ignored.
        /// PaletteEntries (variable): An array of LogPaletteEntry objects (section 2.2.18) that specifies the palette data.
        if offPalEntries != 0 && nPalEntries != 0 {
            guard offPalEntries >= 16 &&
                    offPalEntries + nPalEntries <= size else {
                throw EmfReadError.corrupted
            }

            dataStream.position = startPosition + Int(offPalEntries)
            var paletteEntries: [LogPaletteEntry] = []
            paletteEntries.reserveCapacity(Int(self.nPalEntries))
            for _ in 0..<self.nPalEntries {
                paletteEntries.append(try LogPaletteEntry(dataStream: &dataStream))
            }
            
            self.paletteEntries = paletteEntries
        } else {
            self.paletteEntries = nil
        }
        
        /// SizeLast (4 bytes): An unsigned integer that MUST be the same as Size and MUST be the last field of the record and
        /// hence the metafile. LogPaletteEntry objects, if they exist, MUST precede this field.
        self.sizeLast = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
