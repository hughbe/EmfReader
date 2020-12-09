//
//  LogFontExDv.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.15 LogFontExDv Object
/// The LogFontExDv object specifies the design vector for an extended logical font.
public struct LogFontExDv {
    public let logFontEx: LogFontEx
    public let designVector: DesignVector
    
    public init(dataStream: inout DataStream) throws {
        /// LogFontEx (348 bytes): A LogFontEx object (section 2.2.14) that specifies the extended attributes of the logical font.
        self.logFontEx = try LogFontEx(dataStream: &dataStream)
        
        /// DesignVector (variable): A DesignVector object (section 2.2.3). This field MUST NOT be longer than 72 bytes.
        self.designVector = try DesignVector(dataStream: &dataStream)
    }
}
