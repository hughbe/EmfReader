//
//  PixelFormatDescriptor.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

/// [MS-EMF] 2.2.22 PixelFormatDescriptor Object
/// The PixelFormatDescriptor object specifies the pixel format of a drawing surface.
/// The PixelFormatDescriptor object is used in EMR_HEADER records (section 2.3.4.2) to specify the pixel format of the output surface.
public struct PixelFormatDescriptor {
    public let nSize: UInt16
    public let nVersion: UInt16
    public let dwFlags: UInt32
    public let iPixelType: PixelType
    public let cColorBits: UInt8
    public let cRedBits: UInt8
    public let cRedShift: UInt8
    public let cGreenBits: UInt8
    public let cGreenShift: UInt8
    public let cBlueBits: UInt8
    public let cBlueShift: UInt8
    public let cAlphaBits: UInt8
    public let cAlphaShift: UInt8
    public let cAccumBits: UInt8
    public let cAccumRedBits: UInt8
    public let cAccumGreenBits: UInt8
    public let cAccumBlueBits: UInt8
    public let cAccumAlphaBits: UInt8
    public let cDepthBits: UInt8
    public let cStencilBits: UInt8
    public let cAuxBuffers: UInt8
    public let iLayerType: UInt8
    public let bReserved: UInt8
    public let dwLayerMask: UInt8
    public let dwVisibleMask: UInt8
    public let dwDamageMask: UInt8
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// nSize (2 bytes): An unsigned integer that specifies the size in bytes, of this data structure.
        self.nSize = try dataStream.read(endianess: .littleEndian)
        guard self.nSize == 0x00000028 else {
            throw EmfReadError.corrupted
        }
        
        /// nVersion (2 bytes): An unsigned integer that MUST be set to 0x0001.
        self.nVersion = try dataStream.read(endianess: .littleEndian)
        guard self.nVersion == 0x0001 else {
            throw EmfReadError.corrupted
        }
        
        /// dwFlags (4 bytes): A set of bit flags that specify properties of the pixel buffer that is used for output to the drawing surface.
        /// These properties are not all mutually exclusive; combinations of flags are allowed, except where noted otherwise.
        /// D PFD_DOUBLEBUFFER The pixel buffer is double-buffered. This flag and PFD_SUPPORT_GDI MUST NOT both be set.
        /// S PFD_STEREO The pixel buffer MAY be stereoscopic; that is, it MAY specify a color plane that is used to create the
        /// illusion of depth in an image.<48>
        /// W PFD_DRAW_TO_WINDOW The pixel buffer can draw to a window or device surface.
        /// M PFD_DRAW_TO_BITMAP The pixel buffer can draw to a memory bitmap.
        /// G PFD_SUPPORT_GDI This flag SHOULD be clear, but it MAY be set. <49> The PFD_SUPPORT_GDI flag and
        /// PFD_DOUBLEBUFFER MUST NOT both be set.
        /// SO PFD_SUPPORT_OPENGL The pixel buffer supports OpenGL [OPENGL] drawing.
        /// F PFD_GENERIC_FORMAT The pixel format is natively supported by the operating system; this is known as the "generic"
        /// implementation.<50> If clear, the pixel format is supported by a device driver or hardware.
        /// P PFD_NEED_PALETTE The buffer uses RGBA pixels on a palette-managed device. A LogPalette object (section 2.2.17)
        /// is required to achieve the best results for this pixel type. Colors in the palette SHOULD be specified according to the values
        /// of the cRedBits, cRedShift, cGreenBits, cGreenShift, cBlueBits, and cBlueShift fields.
        /// SP PFD_NEED_SYSTEM_PALETTE The output device supports one hardware palette in 256-color mode only. For such
        /// systems to use hardware acceleration, the hardware palette MUST be in a fixed order (for example, 3-3-2) when in RGBA
        /// mode, or MUST match the LogPalette object when in color table mode.
        /// SE PFD_SWAP_EXCHANGE The contents of the back buffer have been exchanged with the contents of the front buffer in
        /// a double-buffered color plane.
        /// SC PFD_SWAP_COPY The contents of the back buffer have been copied to the front buffer in a double-buffered color
        /// plane. The contents of the back buffer have not been affected.
        /// SL PFD_SWAP_LAYER_BUFFERS A device can swap individual color planes with pixel formats that include double-buffered
        /// overlay or underlay color planes. Otherwise all color planes are swapped together as a group.
        /// A PFD_GENERIC_ACCELERATED The pixel format is supported by a device driver that accelerates the generic
        /// implementation. If this flag is clear and the
        /// PFD_GENERIC_FORMAT flag is set, the pixel format is supported by the generic implementation only.
        /// DS PFD_SUPPORT_DIRECTDRAW The pixel buffer supports DirectDraw drawing, which allows applications to have
        /// low-level control of the output drawing surface.
        /// DA PFD_DIRECT3D_ACCELERATED The pixel buffer supports Direct3D drawing, which accellerated rendering in three
        /// dimensions.
        /// C PFD_SUPPORT_COMPOSITION The pixel buffer supports compositing, which indicates that source pixels MAY
        /// overwrite or be combined with background pixels.<51>
        /// DP PFD_DEPTH_DONTCARE The pixel buffer is not required to include a color plane for depth effects.
        /// DD PFD_DOUBLEBUFFER_DONTCARE The pixel buffer can be either single or double buffered.
        /// SD PFD_STEREO_DONTCARE The pixel buffer MAY be either monoscopic or stereoscopic.
        self.dwFlags = try dataStream.read(endianess: .littleEndian)
        
        /// iPixelType (1 byte): The type of pixel data.
        self.iPixelType = try PixelType(dataStream: &dataStream)
        
        /// cColorBits (1 byte): The number of bits per pixel for RGBA pixel types, excluding the alpha bitplanes. For color table
        /// pixels, it is the size of each color table index.
        self.cColorBits = try dataStream.read()

        /// cRedBits (1 byte): Specifies the number of red bitplanes in each RGBA color buffer.
        self.cRedBits = try dataStream.read()
        
        /// cRedShift (1 byte): Specifies the shift count in bits for red bitplanes in each RGBA color buffer.
        self.cRedShift = try dataStream.read()
        
        /// cGreenBits (1 byte): Specifies the number of green bitplanes in each RGBA color buffer.
        self.cGreenBits = try dataStream.read()
        
        /// cGreenShift (1 byte): Specifies the shift count for green bitplanes in each RGBA color buffer.
        self.cGreenShift = try dataStream.read()
        
        /// cBlueBits (1 byte): Specifies the number of blue bitplanes in each RGBA color buffer.
        self.cBlueBits = try dataStream.read()
        
        /// cBlueShift (1 byte): Specifies the shift count for blue bitplanes in each RGBA color buffer.
        self.cBlueShift = try dataStream.read()
        
        /// cAlphaBits (1 byte): Specifies the number of alpha bitplanes in each RGBA color buffer.<52>
        self.cAlphaBits = try dataStream.read()
        
        /// cAlphaShift (1 byte): Specifies the shift count for alpha bitplanes in each RGBA color buffer.<53>
        self.cAlphaShift = try dataStream.read()
        
        /// cAccumBits (1 byte): Specifies the total number of bitplanes in the accumulation buffer.
        self.cAccumBits = try dataStream.read()
        
        /// cAccumRedBits (1 byte): Specifies the number of red bitplanes in the accumulation buffer.
        self.cAccumRedBits = try dataStream.read()
        
        /// cAccumGreenBits (1 byte): Specifies the number of green bitplanes in the accumulation buffer.
        self.cAccumGreenBits = try dataStream.read()
        
        /// cAccumBlueBits (1 byte): Specifies the number of blue bitplanes in the accumulation buffer.
        self.cAccumBlueBits = try dataStream.read()
        
        /// cAccumAlphaBits (1 byte): Specifies the number of alpha bitplanes in the accumulation buffer.<54>
        self.cAccumAlphaBits = try dataStream.read()
        
        /// cDepthBits (1 byte): Specifies the depth of the depth (z-axis) buffer.
        self.cDepthBits = try dataStream.read()
        
        /// cStencilBits (1 byte): Specifies the depth of the stencil buffer.
        self.cStencilBits = try dataStream.read()
        
        /// cAuxBuffers (1 byte): Specifies the number of auxiliary buffers. Auxiliary buffers are not supported.
        self.cAuxBuffers = try dataStream.read()
        
        /// iLayerType (1 byte): This field MAY be ignored.
        self.iLayerType = try dataStream.read()
     
        /// bReserved (1 byte): Specifies the number of overlay and underlay planes. Bits 0 through 3 specify up to 15 overlay
        /// planes and bits 4 through 7 specify up to 15 underlay planes.
        self.bReserved = try dataStream.read()
        
        /// dwLayerMask (4 bytes): This field MAY be ignored.
        self.dwLayerMask = try dataStream.read()
        
        /// dwVisibleMask (4 bytes): Specifies the transparent color or index of an underlay plane. When the pixel type is RGBA,
        /// dwVisibleMask is a transparent RGB color value. When the pixel type is color index, it is a transparent index value.
        self.dwVisibleMask = try dataStream.read(endianess: .littleEndian)
        
        /// dwDamageMask (4 bytes): This field SHOULD be ignored.
        self.dwDamageMask = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == self.nSize else {
            throw EmfReadError.corrupted
        }
    }
    
    /// iPixelType (1 byte): The type of pixel data.
    public enum PixelType: UInt8, DataStreamCreatable {
        /// PFD_TYPE_RGBA 0x00 The pixel format is RGBA.
        case rgba = 0x00
        
        /// PFD_TYPE_COLORINDEX 0x01 Each pixel is an index in a color table.
        case colorIndex = 0x01
    }
}
