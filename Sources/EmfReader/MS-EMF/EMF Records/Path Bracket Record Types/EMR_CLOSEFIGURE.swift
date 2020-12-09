//
//  EMR_CLOSEFIGURE.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.3.10 Path Bracket Record Types
/// EMR_CLOSEFIGURE This record closes the figure in path bracket construction.
/// Processing the EMR_CLOSEFIGURE record closes the figure by drawing a line from the current drawing position to the first point
/// of the figure, and then it connects the lines by using the current line join. If the figure is closed by processing an EMR_LINETO record
/// (section 2.3.5.13) instead of this record, the current line cap is used to create the corner instead of the line join. The line parameters
/// are specified by the PenStyle field in the current LogPen (section 2.2.19) and LogPenEx (section 2.2.20) objects.
/// The EMR_CLOSEFIGURE record SHOULD be used only if there is an open figure in the path bracket. A figure in a path is open
/// unless it is explicitly closed by processing this record. A figure can be open even if the current point is the same as the starting point.
/// After processing the EMR_CLOSEFIGURE record, adding a line or curve to the path bracket starts a new figure.
public struct EMR_CLOSEFIGURE {
    public let type: RecordType
    public let size: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_CLOSEFIGURE. This value is 0x0000003D.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_CLOSEFIGURE else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of the record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000008 else {
            throw EmfReadError.corrupted
        }
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
