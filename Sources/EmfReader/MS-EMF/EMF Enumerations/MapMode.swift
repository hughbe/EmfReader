//
//  MapMode.swift
//  
//
//  Created by Hugh Bellamy on 04/12/2020.
//

/// [MS-EMF] 2.1.21 MapMode Enumeration
/// The MapMode enumeration is used to define the unit of measure for transforming page space units into device space units and for
/// defining the orientation of the drawing axes.
/// typedef enum
/// {
///  MM_TEXT = 0x01,
///  MM_LOMETRIC = 0x02,
///  MM_HIMETRIC = 0x03,
///  MM_LOENGLISH = 0x04,
///  MM_HIENGLISH = 0x05,
///  MM_TWIPS = 0x06,
///  MM_ISOTROPIC = 0x07,
///  MM_ANISOTROPIC = 0x08
/// } MapMode;
public enum MapMode: UInt32, DataStreamCreatable {
    /// MM_TEXT: Each logical unit is mapped to one device pixel. Positive x is to the right; positive y is down.
    case text = 0x01
    
    /// MM_LOMETRIC: Each logical unit is mapped to 0.1 millimeter. Positive x is to the right; positive y is up.
    case loMetric = 0x02
    
    /// MM_HIMETRIC: Each logical unit is mapped to 0.01 millimeter. Positive x is to the right; positive y is up.
    case hiMetric = 0x03
    
    /// MM_LOENGLISH: Each logical unit is mapped to 0.01 inch. Positive x is to the right; positive y is up.
    case loEnglish = 0x04
    
    /// MM_HIENGLISH: Each logical unit is mapped to 0.001 inch. Positive x is to the right; positive y is up.
    case hiEnglish = 0x05
    
    /// MM_TWIPS: Each logical unit is mapped to one-twentieth of a printer's point (1/1440 inch, also called a "twip"). Positive x is to
    /// the right; positive y is up.
    case twips = 0x06
    
    /// MM_ISOTROPIC: Logical units are isotropic; that is, they are mapped to arbitrary units with equally scaled axes. Thus, one
    /// unit along the x-axis is equal to one unit along the y-axis. The EMR_SETWINDOWEXTEX (section 2.3.11.30) and
    /// EMR_SETVIEWPORTEXTEX (section 2.3.11.28) records are used to specify the units and the orientation of the axes.
    /// Adjustments MUST be made as necessary to ensure that the x and y units remain the same size.
    /// For example, when the window extent is set, the viewport MUST be adjusted to keep the units isotropic.
    case isotropic = 0x07
    
    /// MM_ANISOTROPIC: Logical units are anisotropic; that is, they are mapped to arbitrary units with arbitrarily scaled axes.
    /// The EMR_SETWINDOWEXTEX and EMR_SETVIEWPORTEXTEX records are used to specify the units, orientation, and scaling
    /// of the axes.
    case anisotropic = 0x08
}
