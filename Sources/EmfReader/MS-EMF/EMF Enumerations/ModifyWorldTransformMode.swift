//
//  ModifyWorldTransformMode.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.24 ModifyWorldTransformMode Enumeration
/// The ModifyWorldTransformMode enumeration defines modes for changing the world-space to page-space transform that is currently
/// defined in the playback device context.
/// typedef enum
/// {
///  MWT_IDENTITY = 0x01,
///  MWT_LEFTMULTIPLY = 0x02,
///  MWT_RIGHTMULTIPLY = 0x03,
///  MWT_SET = 0x04
/// } ModifyWorldTransformMode;
/// The transform data is specified as an XForm object (section 2.2.28).
/// For more information concerning transforms and coordinate spaces, see [MSDN-WRLDPGSPC].
public enum ModifyWorldTransformMode: UInt32, DataStreamCreatable {
    /// MWT_IDENTITY: Reset the current transform using the identity matrix. In this mode, the specified transform data is ignored.
    case identify = 0x01
    
    /// MWT_LEFTMULTIPLY: Multiply the current transform. In this mode, the specified transform data is the left multiplicand, and the
    /// current transform is the right multiplicand.
    case leftMultiply = 0x02
    
    /// MWT_RIGHTMULTIPLY: Multiply the current transform. In this mode, the specified transform data is the right multiplicand, and
    /// the current transform is the left multiplicand.
    case rightMultiply = 0x03
    
    /// MWT_SET: Set the current transform to the specified transform data.
    case set = 0x04
}
