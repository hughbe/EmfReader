//
//  EMR_SETICMMODE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.11.14 EMR_SETICMMODE Record
/// The EMR_SETICMMODE record specifies the mode of Image Color Management (ICM) for graphics operations.<84>
/// When ICM mode is enabled in the playback device context, colors specified in EMF records SHOULD be color matched, whereas the
/// default color profile SHOULD be used when a bit-block transfer is performed. If the default color profile is not desired, ICM mode
/// SHOULD be turned off before performing the bit-block transfer.
/// See section 2.3.11 for more state record types.
public struct EMR_SETICMMODE {
    public let type: RecordType
    public let size: UInt32
    public let icmMode: ICMMode
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETICMMODE. This value is 0x00000062.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETICMMODE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes. This value is 0x0000000C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// ICMMode (4 bytes): An unsigned integer that specifies whether to enable or disable ICM, from the ICMMode enumeration
        /// (section 2.1.18).
        self.icmMode = try ICMMode(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
