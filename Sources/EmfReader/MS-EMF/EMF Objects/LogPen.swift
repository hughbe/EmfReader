//
//  LogPen.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.2.19 LogPen Object
/// The LogPen object defines the style, width, and color of a logical pen.
public struct LogPen {
    public let penStyle: PenStyle
    public let width: PointL
    public let colorRef: ColorRef
    
    public init(dataStream: inout DataStream) throws {
        /// PenStyle (4 bytes): An unsigned integer that specifies a value from the PenStyle enumeration (section 2.1.25).
        self.penStyle = try PenStyle(dataStream: &dataStream)
        
        /// Width (8 bytes): A PointL object ([MS-WMF] section 2.2.2.15) that specifies the width of the pen by the value of its x field.
        /// The value of its y field MUST be ignored.
        /// If the pen type in the PenStyle field is PS_GEOMETRIC, this value is the width in logical units; otherwise, the width is
        /// specified in device units. If the pen type in the PenStyle field is PS_COSMETIC, this value MUST be 0x00000001.
        self.width = try PointL(dataStream: &dataStream)
        
        /// ColorRef (4 bytes): A ColorRef object ([MS-WMF] section 2.2.2.8) that specifies the pen color value.
        self.colorRef = try ColorRef(dataStream: &dataStream)
    }
}
