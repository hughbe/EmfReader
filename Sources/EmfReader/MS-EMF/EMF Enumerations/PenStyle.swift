//
//  PenStyle.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.1.25 PenStyle Enumeration
/// The PenStyle enumeration defines the attributes of pens that can be used in graphics operations. A pen style is a combination of
/// pen type, line style, line cap, and line join.
/// typedef enum
/// {
///  PS_COSMETIC = 0x00000000,
///  PS_ENDCAP_ROUND = 0x00000000,
///  PS_JOIN_ROUND = 0x00000000,
///  PS_SOLID = 0x00000000,
///  PS_DASH = 0x00000001,
///  PS_DOT = 0x00000002,
///  PS_DASHDOT = 0x00000003,
///  PS_DASHDOTDOT = 0x00000004,
///  PS_NULL = 0x00000005,
///  PS_INSIDEFRAME = 0x00000006,
///  PS_USERSTYLE = 0x00000007,
///  PS_ALTERNATE = 0x00000008,
///  PS_ENDCAP_SQUARE = 0x00000100,
///  PS_ENDCAP_FLAT = 0x00000200,
///  PS_JOIN_BEVEL = 0x00001000,
///  PS_JOIN_MITER = 0x00002000,
///  PS_GEOMETRIC = 0x00010000
/// } PenStyle;
public struct PenStyle {
    public let style: Style
    public let endCap: EndCap
    public let join: Join
    public let type: PenType
    
    public init(dataStream: inout DataStream) throws {
        try self.init(rawValue: try dataStream.read(endianess: .littleEndian))
    }
    
    public init(rawValue: UInt32) throws {
        guard let style = Style(rawValue: rawValue & 0x0000000F) else {
            throw EmfReadError.corrupted
        }
        
        self.style = style
        
        guard let endCap = EndCap(rawValue: rawValue & 0x00000F00) else {
            throw EmfReadError.corrupted
        }
        
        self.endCap = endCap
        
        guard let join = Join(rawValue: rawValue & 0x0000F000) else {
            throw EmfReadError.corrupted
        }
        
        self.join = join
        
        guard let type = PenType(rawValue: rawValue & 0x000F0000) else {
            throw EmfReadError.corrupted
        }
        
        self.type = type
    }
    
    public enum Style: UInt32 {
        /// PS_SOLID: A line style that is a solid color.
        case solid = 0x00000000
        
        /// PS_DASH: A line style that is dashed.
        case dash = 0x00000001
        
        /// PS_DOT: A line style that is dotted.
        case dot = 0x00000002
        
        /// PS_DASHDOT: A line style that consists of alternating dashes and dots.
        case dashDot = 0x00000003
        
        /// PS_DASHDOTDOT: A line style that consists of dashes and double dots.
        case dashDotDot = 0x00000004
        
        /// PS_NULL: A line style that is invisible.
        case null = 0x00000005
        
        /// PS_INSIDEFRAME: A line style that is a solid color. When this style is specified in a drawing record that takes a bounding
        /// rectangle, the dimensions of the figure are shrunk so that it fits entirely in the bounding rectangle, considering the width
        /// of the pen.
        case insideFrame =  0x00000006
        
        /// PS_USERSTYLE: A line style that is defined by a styling array, which specifies the lengths of dashes and gaps in the line.
        case userStyle = 0x00000007

        /// PS_ALTERNATE: A line style in which every other pixel is set. This style is applicable only to a pen type of PS_COSMETIC.
        case alternate = 0x00000008
    }
    
    public enum EndCap: UInt32 {
        /// PS_ENDCAP_ROUND: A line cap that specifies round ends.
        case round = 0x000000000

        /// PS_ENDCAP_SQUARE: A line cap that specifies square ends.
        case square = 0x00000100
        
        /// PS_ENDCAP_FLAT: A line cap that specifies flat ends.
        case flat = 0x00000200
    }
    
    public enum Join: UInt32 {
        /// PS_JOIN_ROUND: A line join that specifies round joins.
        case round = 0x00000000
        
        /// PS_JOIN_BEVEL: A line join that specifies beveled joins.
        case bevel = 0x00001000
        
        /// PS_JOIN_MITER: A line join that specifies mitered joins when the lengths of the joins are within the current miter length limit.
        /// If the lengths of the joins exceed the miter limit, beveled joins are specified.
        /// The miter length limit is a metafile state property that is set by the EMR_SETMITERLIMIT record (section 2.3.11.21). join is
        /// beveled when it would exceed the limit.
        case miter = 0x00002000
    }

    public enum PenType: UInt32 {
        /// PS_COSMETIC: A pen type that specifies a line with a width of one logical unit and a style that is a solid color.
        case cosmetic = 0x00000000
        
        /// PS_GEOMETRIC: A pen type that specifies a line with a width that is measured in logical units and a style that can contain
        /// any of the attributes of a brush.
        case geometric = 0x00010000
    }
}

