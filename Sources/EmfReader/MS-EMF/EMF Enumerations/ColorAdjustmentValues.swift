//
//  ColorAdjustmentValues.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

/// [MS-EMF] 2.1.5 ColorAdjustment Enumeration
/// The ColorAdjustment enumeration is used to specify how the output image is prepared when the stretch mode is HALFTONE.
/// typedef enum
/// {
///  CA_NEGATIVE = 0x0001,
///  CA_LOG_FILTER = 0x0002
/// } ColorAdjustment;
public struct ColorAdjustmentValues: OptionSet, DataStreamCreatable {
    public let rawValue: UInt16
    
    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }
    
    /// CA_NEGATIVE: Specifies that the negative of the original image SHOULD be displayed.
    public static let negative = ColorAdjustmentValues(rawValue: 0x0001)
    
    /// CA_LOG_FILTER: Specifies that a logarithmic process SHOULD be applied to the final density of the output colors.
    /// This will increase the color contrast when the luminance is low.
    public static let logFilter = ColorAdjustmentValues(rawValue: 0x0002)
    
    static let all: ColorAdjustmentValues = [.negative, .logFilter]
}
