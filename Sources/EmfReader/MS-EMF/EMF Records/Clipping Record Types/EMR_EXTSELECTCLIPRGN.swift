//
//  EMR_EXTSELECTCLIPRGN.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.2.2 EMR_EXTSELECTCLIPRGN Record
/// The EMR_EXTSELECTCLIPRGN record combines the specified region with the current clipping region using the specified mode.
/// Fields not specified in this section are specified in section 2.3.2.
/// See section 2.3.7 for more object creation record types.
public struct EMR_EXTSELECTCLIPRGN {
    public let type: RecordType
    public let size: UInt32
    public let rgnDataSize: UInt32
    public let regionMode: RegionMode
    public let rgnData: RegionData?
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_EXTSELECTCLIPRGN. This value is 0x0000004B.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_EXTSELECTCLIPRGN else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size in bytes of this record in the metafile. This value MUST be a
        /// multiple of 4 bytes.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 16 && (size % 4) == 0 else {
            throw EmfReadError.corrupted
        }
        
        self.size = size
        
        /// RgnDataSize (4 bytes): An unsigned integer that specifies the size of the RgnData field in bytes.
        self.rgnDataSize = try dataStream.read(endianess: .littleEndian)
        
        /// RegionMode (4 bytes): An unsigned integer that specifies the way to use the region. This value is in the RegionMode
        /// (section 2.1.29) enumeration.
        self.regionMode = try RegionMode(dataStream: &dataStream)
        
        if dataStream.position - startPosition == self.size {
            self.rgnData = nil
            return
        }
        
        let startPosition2 = dataStream.position
        
        /// RgnData (variable): An array of bytes that specifies a RegionData object (section 2.2.24) in logical units. If RegionMode is
        /// RGN_COPY, this data can be omitted and the clipping region SHOULD be set to the default clipping region.
        self.rgnData = try RegionData(dataStream: &dataStream)

        guard dataStream.position - startPosition2 == self.rgnDataSize else {
            throw EmfReadError.corrupted
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
