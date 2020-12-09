//
//  RegionMode.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

/// [MS-EMF] 2.1.29 RegionMode Enumeration
/// The RegionMode enumeration defines values that are used with EMR_SELECTCLIPPATH and EMR_EXTSELECTCLIPRGN, specifying
/// the current path bracket or a new region that is being combined with the current clipping region.
/// typedef enum
/// {
///  RGN_AND = 0x01,
///  RGN_OR = 0x02,
///  RGN_XOR = 0x03,
///  RGN_DIFF = 0x04,
///  RGN_COPY = 0x05
/// } RegionMode;
public enum RegionMode: UInt32, DataStreamCreatable {
    /// RGN_AND: The new clipping region includes the intersection (overlapping areas) of the current clipping region and the current
    /// path bracket (or new region).
    case and = 0x01
    
    /// RGN_OR: The new clipping region includes the union (combined areas) of the current clipping region and the current path
    /// bracket (or new region).
    case or = 0x02
    
    /// RGN_XOR: The new clipping region includes the union of the current clipping region and the current path bracket (or new region)
    /// but without the overlapping areas.
    case xor = 0x03
    
    /// RGN_DIFF: The new clipping region includes the areas of the current clipping region with those of the current path bracket
    /// (or new region) excluded.
    case diff = 0x04
    
    /// RGN_COPY: The new clipping region is the current path bracket (or the new region).
    case copy = 0x05
}
