//
//  RegionData.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMF] 2.2.24 RegionData Object
/// The RegionData object specifies data that defines a region, which is made of non-overlapping rectangles.
public struct RegionData {
    public let regionDataHeader: RegionDataHeader
    public let data: [RectL]
    
    public init(dataStream: inout DataStream) throws {
        /// RegionDataHeader (32 bytes): A 256-bit RegionDataHeader object (section 2.2.25) that defines the contents of the Data field.
        self.regionDataHeader = try RegionDataHeader(dataStream: &dataStream)
        
        let startPosition = dataStream.position
        
        /// Data (variable): An array of RectL objects ([MS-WMF] section 2.2.2.19); the objects are merged to create the region.
        var data: [RectL] = []
        data.reserveCapacity(Int(self.regionDataHeader.countRects))
        for _ in 0..<self.regionDataHeader.countRects {
            data.append(try RectL(dataStream: &dataStream))
        }
        
        self.data = data
        
        guard dataStream.position - startPosition == self.regionDataHeader.rgnSize else {
            throw EmfReadError.corrupted
        }
    }
}
