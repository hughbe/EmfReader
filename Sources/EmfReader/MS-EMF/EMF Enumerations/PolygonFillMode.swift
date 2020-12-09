//
//  PolygonFillMode.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

/// [MS-EMF] 2.1.27 PolygonFillMode Enumeration
/// The PolygonFillMode enumeration defines values that specify how to calculate the region of a polygon that is to be filled.
/// typedef enum
/// {
///  ALTERNATE = 0x01,
///  WINDING = 0x02
/// } PolygonFillMode;
public enum PolygonFillMode: UInt32, DataStreamCreatable {
    /// ALTERNATE: Selects alternate mode (fills the area between odd-numbered and even-numbered polygon sides on each scan line).
    case alternate = 0x01
    
    /// WINDING: Selects winding mode (fills any region with a nonzero winding value).
    case winding = 0x02
}
