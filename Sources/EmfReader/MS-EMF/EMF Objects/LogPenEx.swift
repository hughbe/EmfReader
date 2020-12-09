//
//  LogPenEx.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.2.20 LogPenEx Object
/// The LogPenEx object specifies the style, width, and color of an extended logical pen.
/// The first entry in the StyleEntry array specifies the length of the first dash. The second entry specifies the length of the first gap.
/// Thereafter, lengths of dashes and gaps alternate.
/// If the pen type in the PenStyle field is PS_GEOMETRIC, lengths are specified in logical units; otherwise, they are specified in device units.
/// The LogPenEx object includes the specification of brush attributes, so it can be used to draw lines that consist of custom or predefined
/// patterns. The following table shows the relationship between the BrushStyle, ColorRef, and BrushHatch fields in this object.
/// Only supported brush styles are listed. BrushStyle ColorRef BrushHatch
/// BS_SOLID A ColorRef object that specifies the color of lines drawn by the pen. Not used and is ignored.
/// BS_NULL Not used and is ignored. Not used and is ignored.
/// BS_HATCHED A ColorRef object that specifies the foreground color of the hatch pattern. A value from the HatchStyle enumeration
/// (section 2.1.17) that specifies the orientation of lines used to create the hatch. If PS_GEOMETRIC is not set in the PenStyle field,
/// this field MUST be either HS_SOLIDTEXTCLR (0x0008) or HS_SOLIDBKCLR (0x000A).
/// BS_PATTERN The low-order 16-bits is a value from the ColorUsage enumeration ([MS-WMF] section 2.1.1.6). Not used and is ignored.
/// BS_DIBPATTERN The low-order 16 bits is a value from the ColorUsage enumeration. Not used and is ignored.
/// BS_DIBPATTERNPT The low-order word is be a value from the ColorUsage enumeration. Not used and is ignored.
public struct LogPenEx {
    public let penStyle: PenStyle
    public let width: UInt32
    public let brushStyle: BrushStyle
    public let colorRef: ColorRef
    public let brushHatch: UInt32
    public let numStyleEntries: UInt32
    public let styleEntry: [UInt32]
    
    public init(dataStream: inout DataStream, startPosition: Int, size: UInt32) throws {
        /// PenStyle (4 bytes): An unsigned integer that specifies the pen style. This value is defined from the PenStyle enumeration
        /// (section 2.1.25).
        /// The pen style is a combination of pen type, line style, line cap, and line join.
        self.penStyle = try PenStyle(dataStream: &dataStream)
        
        /// Width (4 bytes): An unsigned integer that specifies the width of the line drawn by the pen. If the pen type in the PenStyle
        /// field is PS_GEOMETRIC, this value is the width in logical units; otherwise, the width is specified in device units. If the
        /// pen type in the PenStyle field is PS_COSMETIC, this value MUST be 0x00000001.
        self.width = try dataStream.read(endianess: .littleEndian)
        
        /// BrushStyle (4 bytes): An unsigned integer that specifies a brush style for the pen from the BrushStyle enumeration
        /// ([MS-WMF] section 2.1.1.4).
        /// If the pen type in the PenStyle field is PS_GEOMETRIC, this value is either BS_SOLID or BS_HATCHED. The value of this
        /// field can be BS_NULL, but only if the line style specified in PenStyle is PS_NULL. The BS_NULL style SHOULD be used to
        /// specify a brush that has no effect.
        let brushStyleRaw: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard let brushStyle = BrushStyle(rawValue: UInt16(brushStyleRaw)) else {
            throw EmfReadError.corrupted
        }
        
        self.brushStyle = brushStyle
        
        /// ColorRef (4 bytes): A ColorRef object ([MS-WMF] section 2.2.2.8). The interpretation of this field depends on the BrushStyle
        /// value, as shown in the table later in this section.
        self.colorRef = try ColorRef(dataStream: &dataStream)
        
        /// BrushHatch (4 bytes): The brush hatch pattern. The definition of this field depends on the BrushStyle value, as shown in the
        /// table later in this section.
        self.brushHatch = try dataStream.read(endianess: .littleEndian)
        
        /// NumStyleEntries (4 bytes): The number of elements in the array specified in the StyleEntry field. This value SHOULD be
        /// zero if PenStyle does not specify PS_USERSTYLE.
        self.numStyleEntries = try dataStream.read(endianess: .littleEndian)

        /// StyleEntry (variable, optional): An array of 32-bit unsigned integers that defines the lengths of dashes and gaps in the
        /// line drawn by this pen when the value of PenStyle is PS_USERSTYLE. The array contains the number of entries specified
        /// by NumStyleEntries, but it is used as if it repeated indefinitely.
        if dataStream.position - startPosition == size {
            self.styleEntry = []
            return
        }
            
        let styleEntryCount = max(self.numStyleEntries, 1)
        var styleEntry: [UInt32] = []
        styleEntry.reserveCapacity(Int(styleEntryCount))
        for _ in 0..<styleEntryCount {
            styleEntry.append(try dataStream.read(endianess: .littleEndian))
        }
        
        self.styleEntry = styleEntry
    }
}
