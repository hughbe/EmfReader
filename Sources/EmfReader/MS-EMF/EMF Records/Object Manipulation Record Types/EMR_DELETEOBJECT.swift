//
//  EMR_DELETEOBJECT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.3.8.3 EMR_DELETEOBJECT Record
/// The EMR_DELETEOBJECT record deletes a graphics object, which is specified by its index in the EMF object table (section 3.1.1.1).
/// The object specified by this record MUST be deleted from the EMF object table. If the deleted object is currently selected into the
/// playback device context, the default object MUST be restored.
/// See section 2.3.8 for more object manipulation record types.
public struct EMR_DELETEOBJECT {
    public let type: RecordType
    public let size: UInt32
    public let ihObject: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_DELETEOBJECT. This value is 0x00000028.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_DELETEOBJECT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// ihObject (4 bytes): An unsigned integer that specifies the index of a graphics object in the EMF object table.
        /// This value MUST NOT be 0, which is a reserved index that refers to the EMF metafile itself; and it MUST NOT be the
        /// index of a stock object, which cannot be deleted. Stock object indexes are specified in the StockObject (section 2.1.31)
        /// enumeration.
        let ihObject: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard ihObject != 0 && StockObject(rawValue: ihObject) == nil else {
            throw EmfReadError.corrupted
        }
        
        self.ihObject = ihObject
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
