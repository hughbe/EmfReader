//
//  Point28_4.swift
//  
//
//  Created by Hugh Bellamy on 09/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.23 Point28_4 Object
/// The Point28_4 object represents the location of a point on a device surface with coordinates in 28.4 bit FIX notation.
public struct Point28_4 {
    public let x: BitFIX28_4
    public let y: BitFIX28_4
    
    public init(dataStream: inout DataStream) throws {
        /// x (4 bytes): A BitFIX28_4 object (section 2.2.1) that represents the horizontal coordinate of the point.
        self.x = try BitFIX28_4(dataStream: &dataStream)
        
        /// y (4 bytes): A BitFIX28_4 object that represents the vertical coordinate of the point.
        self.y = try BitFIX28_4(dataStream: &dataStream)
    }
}
