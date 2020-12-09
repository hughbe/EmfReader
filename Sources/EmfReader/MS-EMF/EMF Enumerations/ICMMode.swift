//
//  ICMMode.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

/// [MS-EMF] 2.1.18 ICMMode Enumeration
/// The ICMMode enumeration defines values that specify when to turn on and off Image Color Management (ICM).<32>
/// typedef enum
/// {
///  ICM_OFF = 0x01,
///  ICM_ON = 0x02,
///  ICM_QUERY = 0x03,
///  ICM_DONE_OUTSIDEDC = 0x04
/// } ICMMode;
public enum ICMMode: UInt32, DataStreamCreatable {
    /// ICM_OFF: Turns off ICM; turns on old-style color correction of halftones.
    case off = 0x01
    
    /// ICM_ON: Turns on ICM; turns off old-style color correction of halftones.
    case on = 0x02
    
    /// ICM_QUERY: Queries the current state of color management.
    case query = 0x03
    
    /// ICM_DONE_OUTSIDEDC: Turns off both ICM and old-style color correction of halftones.
    case doneOutsideDC = 0x04
}
