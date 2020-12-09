//
//  GraphicsMode.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.16 GraphicsMode Enumeration
/// The GraphicsMode enumeration is used to specify how to interpret shape data such as rectangle coordinates.
/// typedef enum
/// {
///  GM_COMPATIBLE = 0x00000001,
///  GM_ADVANCED = 0x00000002
/// } GraphicsMode;
public enum GraphicsMode: UInt32, DataStreamCreatable {
    /// GM_COMPATIBLE: TrueType text MUST be written from left to right and right side up, even if the rest of the graphics are
    /// rotated about the x-axis or y-axis because of the current world-to-device transform. Only the height of the text SHOULD be
    /// scaled.<30>
    /// Arcs MUST be drawn using the current arc direction, but they MUST NOT reflect the current worldto-device transform, which
    /// might require a rotation along the x-axis or y-axis.
    /// The world-to-device transform is modified by changing the window and viewport extents and origins, using the
    /// EMR_SETWINDOWEXTEX (section 2.3.11.30) and EMR_SETVIEWPORTEXTEX (section 2.3.11.28) records, and the
    /// EMR_SETWINDOWORGEX (section 2.3.11.31) and EMR_SETVIEWPORTORGEX (section 2.3.11.29) records, respectively.
    /// The world-to-device transform can be changed by EMR_MODIFYWORLDTRANSFORM (section 2.3.12.1) and
    /// EMR_SETWORLDTRANSFORM (section 2.3.12.2) records.
    /// In GM_COMPATIBLE graphics mode, bottom and rightmost edges MUST be excluded when rectangles are drawn.
    case compatible = 0x00000001
    
    /// GM_ADVANCED: TrueType text output SHOULD<31> fully conform to the current world-to-device transform.
    /// Arcs MUST be drawn in the counterclockwise direction in world space; however, both arc control points and the arcs
    /// themselves MUST reflect the current world-to-device transform.
    /// The world-to-device transform can be modified directly by EMR_MODIFYWORLDTRANSFORM and
    /// EMR_SETWORLDTRANSFORM records, or indirectly by changing the window and viewport extents and origins, using the
    /// EMR_SETWINDOWEXTEX and EMR_SETVIEWPORTEXTEX records, and the EMR_SETWINDOWORGEX and
    /// EMR_SETVIEWPORTORGEX records, respectively.
    /// In GM_ADVANCED graphics mode, bottom and rightmost edges MUST be included when rectangles are drawn.
    case advanced = 0x00000002
}
