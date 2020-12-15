//
//  EMR_SETLINKEDUFIS.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.11.18 EMR_SETLINKEDUFIS Record
/// The EMR_SETLINKEDUFIS record sets the UniversalFontIds (section 2.2.27) of linked fonts to use during character lookup.
/// See section 2.3.11 for more state record types.
public struct EMR_SETLINKEDUFIS {
    public let type: RecordType
    public let size: UInt32
    public let uNumLinkedUFI: UInt32
    public let ufis: [UniversalFontId]
    public let reserved: UInt64
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETLINKEDUFIS. This value is 0x00000077.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETLINKEDUFIS else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000014 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size

        /// uNumLinkedUFI (4 bytes): An unsigned integer specifying the number of UFIs to follow.
        let uNumLinkedUFI: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard uNumLinkedUFI < 0x1FFFFFFD &&
                20 + uNumLinkedUFI * 8 <= size else {
            throw EmfReadError.corrupted
        }
        
        self.uNumLinkedUFI = uNumLinkedUFI
        
        /// ufis (variable): An array of uNumLinkedUFI elements of type UniversalFontId (section 2.2.27), which specifies the identifiers
        /// of the linked fonts.
        var ufis: [UniversalFontId] = []
        ufis.reserveCapacity(Int(self.uNumLinkedUFI))
        for _ in 0..<self.uNumLinkedUFI {
            ufis.append(try UniversalFontId(dataStream: &dataStream))
        }
        
        self.ufis = ufis
        
        /// Reserved (8 bytes): This field is reserved and MUST be ignored.
        self.reserved = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
