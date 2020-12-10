//
//  EmfFile.swift
//  
//
//  Created by Hugh Bellamy on 30/11/2020.
//

import DataStream
import Foundation

/// [MS-EMF] 1.3.1 Metafile Structure
/// An EMF metafile begins with a EMR_HEADER record (section 2.3.4.2), which includes the metafile version, its size, the resolution
/// of the device on which the picture was created, and it ends with an EMR_EOF record (section 2.3.4.1). Between them are records
/// that specify the rendering of the image.
/// The following diagram depicts the structures of different versions of EMF metafiles, which are:
///  Original: The original version of EMF defined a file container for the device-independent specification of images.<1>
///  Extension 1: The second version and first extension added a pixel format record and support for OpenGL commands, enhancing
/// the device independence and flexibility of EMF.
///  Extension 2: The third version and second extension added the capability to measure distances on device surfaces by using the
/// Metric system, enhancing the accuracy and scalability of EMF.
/// EMF metafiles can be considered to have three parts:
///  EMF header: An EMR_HEADER record (section 2.3.4.2), possibly with extensions. It contains information concerning the structure
/// and contents of the metafile, including an optional description string and pixel format descriptor.
///  EMF records: A sequence of drawing orders, property settings, and object definitions (section 2.3). At least one record is present,
/// not counting the header and end-of-file.
///  EMF end-of-file: The EMR_EOF record (section 2.3.4.1), which is the last record in the EMF metafile.
/// EMF records are contiguous because the information that is available for traversing the metafile from record to record depends on it.
/// From any given EMF record, except EMR_EOF, the length of that record can be used to move to the next record in the metafile.
public struct EmfFile {
    public let header: EMR_HEADER
    private let data: DataStream
    
    public init(data: Data) throws {
        var dataStream = DataStream(data)
        try self.init(dataStream: &dataStream)
    }
    
    public init(dataStream: inout DataStream) throws {
        self.header = try EMR_HEADER(dataStream: &dataStream)
        self.data = DataStream(slicing: dataStream, startIndex: dataStream.position, count: min(dataStream.remainingCount, Int(header.emfHeader.bytes)))
    }
    
    public func enumerateRecords(proc: (EmfRecord) throws -> MetafileEnumerationStatus) throws {
        var dataStream = self.data
        while dataStream.position < dataStream.count {
            let record = try EmfRecord(dataStream: &dataStream)
            if case .eof = record {
                break
            }

            let result = try proc(record)
            if result == .break {
                break
            }
        }
    }
    
    public enum MetafileEnumerationStatus {
        case `continue`
        case `break`
    }
}
