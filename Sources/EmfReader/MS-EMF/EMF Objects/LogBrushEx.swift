//
//  LogBrushEx.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.2.12 LogBrushEx Object
/// The LogBrushEx object defines the style, color, and pattern of a device-independent brush.
public struct LogBrushEx {
    public let brushStyle: BrushStyle
    public let color: ColorRef
    public let brushHatch: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// BrushStyle (4 bytes): An unsigned integer that specifies the brush style. The value MUST be an enumeration from
        /// BrushStyle enumeration ([MS-WMF] section 2.1.1.4). The style values that are supported in this structure are listed
        /// later in this section. The BS_NULL style SHOULD be used to specify a brush that has no effect.
        let brushStyleRaw: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard let brushStyle = BrushStyle(rawValue: UInt16(brushStyleRaw)) else {
            throw EmfReadError.corrupted
        }
        
        self.brushStyle = brushStyle
        
        /// Color (4 bytes): A 32-bit ColorRef object ([MS-WMF] section 2.2.2.8) that specifies a color. The interpretation of this field
        /// depends on the value of BrushStyle, as explained in the following table.
        self.color = try ColorRef(dataStream: &dataStream)
        
        /// BrushHatch (4 bytes): A 32-bit unsigned field that contains the brush hatch data. Its interpretation depends on the value
        /// of BrushStyle, as explained in the following table.
        /// The following table shows the relationship between the BrushStyle, Color, and BrushHatch fields in a LogBrushEx object.
        /// Only supported brush styles are listed.
        /// BrushStyle Color BrushHatch
        /// BS_SOLID A ColorRef object, which specifies the color of the brush. Not used and SHOULD be ignored.
        /// BS_NULL Not used and SHOULD be ignored. Not used and SHOULD be ignored.
        /// BS_HATCHED A ColorRef object, which specifies the foreground color of the hatch pattern. A value from the HatchStyle
        /// enumeration (section 2.1.17), which specifies the orientation of lines used to create the hatch.
        self.brushHatch = try dataStream.read(endianess: .littleEndian)
    }
}
