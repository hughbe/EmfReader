//
//  EMR_SETLAYOUT.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.11.17 EMR_SETLAYOUT Record
/// The EMR_SETLAYOUT record specifies the order in which text and graphics are drawn.<87>
/// See section 2.3.11 for more state record types.
public struct EMR_SETLAYOUT {
    public let type: RecordType
    public let size: UInt32
    public let layoutMode: Layout
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_SETLAYOUT. This value is 0x00000073.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_SETLAYOUT else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes. This value is 0x0000000C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfReadError.corrupted
        }
        
        /// LayoutMode (4 bytes): An unsigned integer that specifies the layout mode as follows:
        self.layoutMode = try Layout(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }

    /// LayoutMode (4 bytes): An unsigned integer that specifies the layout mode as follows:
    public enum Layout: UInt32, DataStreamCreatable {
        /// LAYOUT_LTR 0x00000000 Sets the default horizontal layout to be left-to-right. This is the default mode for English and
        /// European locales.
        case ltr = 0x00000000
        
        /// LAYOUT_RTL 0x00000001 Sets the default horizontal layout to be right-to-left. This mode is required for some languages,
        /// including Arabic and Hebrew.
        case rtl = 0x00000001
        
        /// LAYOUT_BITMAPORIENTATIONPRESERVED 0x00000008 Disables mirroring of bitmaps that are drawn by bitmap records
        /// (section 2.3.1) when the layout mode is right-to-left.
        case bitmapOrientationPreserved = 0x00000008
    }
}
