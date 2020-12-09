//
//  EMR_SETMAPMODE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.11.19 EMR_SETMAPMODE Record
/// The EMR_SETMAPMODE record specifies the current mapping mode, which specifies the unit of measure used to transform page
/// space units into device space units, and also specifies the orientation of the device's x-axis and y-axis.
/// See section 2.3.11 for more state record types.
public struct EMR_SETMAPMODE {
    public let type: RecordType
    public let size: UInt32
    public let mapMode: MapMode
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETMAPMODE. This value is 0x00000011.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETMAPMODE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes. This value is 0x0000000C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// MapMode (4 bytes): An unsigned integer from the MapMode enumeration (section 2.1.21).
        /// MM_TEXT mode allows applications to work in device pixels, whose size varies from device to device.
        /// The MM_HIENGLISH, MM_HIMETRIC, MM_LOENGLISH, MM_LOMETRIC, and MM_TWIPS modes are useful for
        /// applications drawing in physically meaningful units such as inches or millimeters.
        /// MM_ISOTROPIC mode ensures a 1:1 aspect ratio.
        /// MM_ANISOTROPIC mode allows the x-coordinates and y-coordinates to be adjusted independently.
        self.mapMode = try MapMode(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
