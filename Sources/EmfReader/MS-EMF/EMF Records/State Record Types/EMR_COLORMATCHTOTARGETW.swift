//
//  EMR_COLORMATCHTOTARGETW.swift
//
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream
import MetafileReader

/// [MS-EMF] 2.3.11.1 EMR_COLORMATCHTOTARGETW Record
/// The EMR_COLORMATCHTOTARGETW record specifies whether to perform color matching with a color profile that is specified in a
/// file with a name consisting of Unicode characters.<80>
/// An EMR_COLORMATCHTOTARGETW record can be used to control whether to apply the current color transform to subsequent
/// graphics operations. If the dwAction field value is CS_ENABLE, color mapping is enabled, and the current color transform SHOULD
/// be applied. If dwAction is set to CS_DISABLE, the color transform SHOULD NOT be applied.
/// Before applying the current color transform, WCS SHOULD be enabled in the playback device context.<81>
/// While color mapping to the target is enabled by a dwAction value of CS_ENABLE, changes to the color space or color gamut mapping
/// are not applied. However, those changes MUST take effect when color mapping to the target is disabled.
/// The dwAction field SHOULD NOT be set to CS_DELETE_TRANSFORM unless color management has already been enabled with an
/// EMR_SETICMMODE record (section 2.3.11.14).
/// See section 2.3.11 for more state record types.
public struct EMR_COLORMATCHTOTARGETW {
    public let type: RecordType
    public let size: UInt32
    public let dwAction: ColorSpace
    public let dwFlags: ColorMatchToTarget
    public let cbName: UInt32
    public let cbData: UInt32
    public let data: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (4 bytes): An unsigned integer that identifies this record type as EMR_COLORMATCHTOTARGETW. This value is 0x00000079.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == RecordType.EMR_COLORMATCHTOTARGETW else {
            throw EmfReadError.corrupted
        }
        
        /// Size (4 bytes): An unsigned integer that specifies the size of this record in bytes.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size >= 24 else {
            throw EmfReadError.corrupted
        }
        
        /// dwAction (4 bytes): An unsigned integer that specifies a value from the ColorSpace enumeration (section 2.1.7).
        self.dwAction = try ColorSpace(dataStream: &dataStream)
        
        /// dwFlags (4 bytes): An unsigned integer that specifies a value from the ColorMatchToTarget enumeration (section 2.1.6).
        self.dwFlags = try ColorMatchToTarget(dataStream: &dataStream)
        
        /// cbName (4 bytes): An unsigned integer that specifies the number of bytes in the Unicode UTF16-LE name of the target
        /// color profile.
        self.cbName = try dataStream.read(endianess: .littleEndian)
        
        /// cbData (4 bytes): An unsigned integer that specifies the size of the raw data of the target color profile in the Data field.
        self.cbData = try dataStream.read(endianess: .littleEndian)
        guard 24 + self.cbName + self.cbData <= self.size else {
            throw EmfReadError.corrupted
        }
        
        /// Data (variable): An array of size (cbName + cbData) bytes, which specifies the UTF16-LE name and raw data of the target
        /// color profile.
        self.data = try dataStream.readBytes(count: Int(self.cbName + cbData))
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == self.size else {
            throw EmfReadError.corrupted
        }
    }
}
