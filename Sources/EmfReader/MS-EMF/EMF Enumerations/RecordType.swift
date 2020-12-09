//
//  RecordType.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

/// [MS-EMF] 2.1.1 RecordType Enumeration
/// The RecordType enumeration defines values that uniquely identify records in an EMF metafile. These values are specified in the
/// Type fields of EMF records (section 2.3).
/// typedef enum
/// {
///  EMR_HEADER = 0x00000001,
///  EMR_POLYBEZIER = 0x00000002,
///  EMR_POLYGON = 0x00000003,
///  EMR_POLYLINE = 0x00000004,
///  EMR_POLYBEZIERTO = 0x00000005,
///  EMR_POLYLINETO = 0x00000006,
///  EMR_POLYPOLYLINE = 0x00000007,
///  EMR_POLYPOLYGON = 0x00000008,
///  EMR_SETWINDOWEXTEX = 0x00000009,
///  EMR_SETWINDOWORGEX = 0x0000000A,
///  EMR_SETVIEWPORTEXTEX = 0x0000000B,
///  EMR_SETVIEWPORTORGEX = 0x0000000C,
///  EMR_SETBRUSHORGEX = 0x0000000D,
///  EMR_EOF = 0x0000000E,
///  EMR_SETPIXELV = 0x0000000F,
///  EMR_SETMAPPERFLAGS = 0x00000010,
///  EMR_SETMAPMODE = 0x00000011,
///  EMR_SETBKMODE = 0x00000012,
///  EMR_SETPOLYFILLMODE = 0x00000013,
///  EMR_SETROP2 = 0x00000014,
///  EMR_SETSTRETCHBLTMODE = 0x00000015,
///  EMR_SETTEXTALIGN = 0x00000016,
///  EMR_SETCOLORADJUSTMENT = 0x00000017,
///  EMR_SETTEXTCOLOR = 0x00000018,
///  EMR_SETBKCOLOR = 0x00000019,
///  EMR_OFFSETCLIPRGN = 0x0000001A,
///  EMR_MOVETOEX = 0x0000001B,
///  EMR_SETMETARGN = 0x0000001C,
///  EMR_EXCLUDECLIPRECT = 0x0000001D,
///  EMR_INTERSECTCLIPRECT = 0x0000001E,
///  EMR_SCALEVIEWPORTEXTEX = 0x0000001F,
///  EMR_SCALEWINDOWEXTEX = 0x00000020,
///  EMR_SAVEDC = 0x00000021,
///  EMR_RESTOREDC = 0x00000022,
///  EMR_SETWORLDTRANSFORM = 0x00000023,
///  EMR_MODIFYWORLDTRANSFORM = 0x00000024,
///  EMR_SELECTOBJECT = 0x00000025,
///  EMR_CREATEPEN = 0x00000026,
///  EMR_CREATEBRUSHINDIRECT = 0x00000027,
///  EMR_DELETEOBJECT = 0x00000028,
///  EMR_ANGLEARC = 0x00000029,
///  EMR_ELLIPSE = 0x0000002A,
///  EMR_RECTANGLE = 0x0000002B,
///  EMR_ROUNDRECT = 0x0000002C,
///  EMR_ARC = 0x0000002D,
///  EMR_CHORD = 0x0000002E,
///  EMR_PIE = 0x0000002F,
///  EMR_SELECTPALETTE = 0x00000030,
///  EMR_CREATEPALETTE = 0x00000031,
///  EMR_SETPALETTEENTRIES = 0x00000032,
///  EMR_RESIZEPALETTE = 0x00000033,
///  EMR_REALIZEPALETTE = 0x00000034,
///  EMR_EXTFLOODFILL = 0x00000035,
///  EMR_LINETO = 0x00000036,
///  EMR_ARCTO = 0x00000037,
///  EMR_POLYDRAW = 0x00000038,
///  EMR_SETARCDIRECTION = 0x00000039,
///  EMR_SETMITERLIMIT = 0x0000003A,
///  EMR_BEGINPATH = 0x0000003B,
///  EMR_ENDPATH = 0x0000003C,
///  EMR_CLOSEFIGURE = 0x0000003D,
///  EMR_FILLPATH = 0x0000003E,
///  EMR_STROKEANDFILLPATH = 0x0000003F,
///  EMR_STROKEPATH = 0x00000040,
///  EMR_FLATTENPATH = 0x00000041,
///  EMR_WIDENPATH = 0x00000042,
///  EMR_SELECTCLIPPATH = 0x00000043,
///  EMR_ABORTPATH = 0x00000044,
///  EMR_COMMENT = 0x00000046,
///  EMR_FILLRGN = 0x00000047,
///  EMR_FRAMERGN = 0x00000048,
///  EMR_INVERTRGN = 0x00000049,
///  EMR_PAINTRGN = 0x0000004A,
///  EMR_EXTSELECTCLIPRGN = 0x0000004B,
///  EMR_BITBLT = 0x0000004C,
///  EMR_STRETCHBLT = 0x0000004D,
///  EMR_MASKBLT = 0x0000004E,
///  EMR_PLGBLT = 0x0000004F,
///  EMR_SETDIBITSTODEVICE = 0x00000050,
///  EMR_STRETCHDIBITS = 0x00000051,
///  EMR_EXTCREATEFONTINDIRECTW = 0x00000052,
///  EMR_EXTTEXTOUTA = 0x00000053,
///  EMR_EXTTEXTOUTW = 0x00000054,
///  EMR_POLYBEZIER16 = 0x00000055,
///  EMR_POLYGON16 = 0x00000056,
///  EMR_POLYLINE16 = 0x00000057,
///  EMR_POLYBEZIERTO16 = 0x00000058,
///  EMR_POLYLINETO16 = 0x00000059,
///  EMR_POLYPOLYLINE16 = 0x0000005A,
///  EMR_POLYPOLYGON16 = 0x0000005B,
///  EMR_POLYDRAW16 = 0x0000005C,
///  EMR_CREATEMONOBRUSH = 0x0000005D,
///  EMR_CREATEDIBPATTERNBRUSHPT = 0x0000005E,
///  EMR_EXTCREATEPEN = 0x0000005F,
///  EMR_POLYTEXTOUTA = 0x00000060,
///  EMR_POLYTEXTOUTW = 0x00000061,
///  EMR_SETICMMODE = 0x00000062,
///  EMR_CREATECOLORSPACE = 0x00000063,
///  EMR_SETCOLORSPACE = 0x00000064,
///  EMR_DELETECOLORSPACE = 0x00000065,
///  EMR_GLSRECORD = 0x00000066,
///  EMR_GLSBOUNDEDRECORD = 0x00000067,
///  EMR_PIXELFORMAT = 0x00000068,
///  EMR_DRAWESCAPE = 0x00000069,
///  EMR_EXTESCAPE = 0x0000006A,
///  EMR_SMALLTEXTOUT = 0x0000006C,
///  EMR_FORCEUFIMAPPING = 0x0000006D,
///  EMR_NAMEDESCAPE = 0x0000006E,
///  EMR_COLORCORRECTPALETTE = 0x0000006F,
///  EMR_SETICMPROFILEA = 0x00000070,
///  EMR_SETICMPROFILEW = 0x00000071,
///  EMR_ALPHABLEND = 0x00000072,
///  EMR_SETLAYOUT = 0x00000073,
///  EMR_TRANSPARENTBLT = 0x00000074,
///  EMR_GRADIENTFILL = 0x00000076,
///  EMR_SETLINKEDUFIS = 0x00000077,
///  EMR_SETTEXTJUSTIFICATION = 0x00000078,
///  EMR_COLORMATCHTOTARGETW = 0x00000079,
///  EMR_CREATECOLORSPACEW = 0x0000007A
/// } RecordType;
public enum RecordType: UInt32, DataStreamCreatable {
    /// EMR_HEADER: This record defines the start of the metafile and specifies its characteristics; its contents, including the
    /// dimensions of the embedded image; the number of records in the metafile; and the resolution of the device on which the
    /// embedded image was created. These values make it possible for the metafile to be device-independent.
    case EMR_HEADER = 0x00000001

    /// EMR_POLYBEZIER: This record defines one or more Bezier curves. Cubic Bezier curves are defined using specified endpoints
    /// and control points, and are stroked with the current pen.
    case EMR_POLYBEZIER = 0x00000002

    /// EMR_POLYGON: This record defines a polygon consisting of two or more vertexes connected by straight lines. The polygon is
    /// outlined by using the current pen and filled by using the current brush and polygon fill mode. The polygon is closed automatically
    /// by drawing a line from the last vertex to the first.
    case EMR_POLYGON = 0x00000003

    /// EMR_POLYLINE: This record defines a series of line segments by connecting the points in the specified array.
    case EMR_POLYLINE = 0x00000004

    /// EMR_POLYBEZIERTO: This record defines one or more Bezier curves based upon the current drawing position.
    case EMR_POLYBEZIERTO = 0x00000005

    /// EMR_POLYLINETO: This record defines one or more straight lines based upon the current drawing position. A line is drawn from
    /// the current drawing position to the first point specified by the points field by using the current pen. For each additional line, drawing is performed from the ending point of the previous line to the next point specified by points.
    case EMR_POLYLINETO = 0x00000006

    /// EMR_POLYPOLYLINE: This record defines multiple series of connected line segments. The line segments are drawn by using the
    /// current pen. The figures formed by the segments are not filled. The current position is neither used nor updated by this record.
    case EMR_POLYPOLYLINE = 0x00000007

    /// EMR_POLYPOLYGON: This record defines a series of closed polygons. Each polygon is outlined by using the current pen and
    /// filled by using the current brush and polygon fill mode. The polygons defined by this record can overlap.
    case EMR_POLYPOLYGON = 0x00000008

    /// EMR_SETWINDOWEXTEX: This record defines the window extent.
    case EMR_SETWINDOWEXTEX = 0x00000009

    /// EMR_SETWINDOWORGEX: This record defines the window origin.
    case EMR_SETWINDOWORGEX = 0x0000000A

    /// EMR_SETVIEWPORTEXTEX: This record defines the viewport extent.
    case EMR_SETVIEWPORTEXTEX = 0x0000000B

    /// EMR_SETVIEWPORTORGEX: This record defines the viewport origin.
    case EMR_SETVIEWPORTORGEX = 0x0000000C

    /// EMR_SETBRUSHORGEX: This record defines the origin of the current brush.
    case EMR_SETBRUSHORGEX = 0x0000000D

    /// EMR_EOF: This record indicates the end of the metafile.
    case EMR_EOF = 0x0000000E

    /// EMR_SETPIXELV: This record defines the color of the pixel at the specified logical coordinates.
    case EMR_SETPIXELV = 0x0000000F

    /// EMR_SETMAPPERFLAGS: This record specifies parameters for the process of matching logical fonts to physical fonts, which
    /// is performed by the font mapper.
    case EMR_SETMAPPERFLAGS = 0x00000010

    /// EMR_SETMAPMODE: This record defines the mapping mode, which defines the unit of measure used to transform page space
    /// units into device space units, and defines the orientation of the device's X and Y axes.
    case EMR_SETMAPMODE = 0x00000011

    /// EMR_SETBKMODE: This record defines the background mix mode, which is used with text, hatched brushes, and pen styles
    /// that are not solid lines.
    case EMR_SETBKMODE = 0x00000012

    /// EMR_SETPOLYFILLMODE: This record defines polygon fill mode.
    case EMR_SETPOLYFILLMODE = 0x00000013

    /// EMR_SETROP2: This record defines binary raster operation mode.
    case EMR_SETROP2 = 0x00000014

    /// EMR_SETSTRETCHBLTMODE: This record defines bitmap stretch mode.
    case EMR_SETSTRETCHBLTMODE = 0x00000015

    /// EMR_SETTEXTALIGN: This record defines text alignment.
    case EMR_SETTEXTALIGN = 0x00000016

    /// EMR_SETCOLORADJUSTMENT: This record defines the color adjustment values using the specified values.
    case EMR_SETCOLORADJUSTMENT = 0x00000017

    /// EMR_SETTEXTCOLOR: This record defines the current text color.
    case EMR_SETTEXTCOLOR = 0x00000018

    /// EMR_SETBKCOLOR: This record defines the background color.
    case EMR_SETBKCOLOR = 0x00000019

    /// EMR_OFFSETCLIPRGN: This record redefines the current clipping region by the specified offsets.
    case EMR_OFFSETCLIPRGN = 0x0000001A

    /// EMR_MOVETOEX: This record defines coordinates of the new drawing position in logical units.
    case EMR_MOVETOEX = 0x0000001B

    /// EMR_SETMETARGN: This record intersects the current clipping region with the current metaregion and saves the combined
    /// region as the new current metaregion.
    case EMR_SETMETARGN = 0x0000001C

    /// EMR_EXCLUDECLIPRECT: This record defines a new clipping region that consists of the current clipping region intersected
    /// with the specified rectangle.
    case EMR_EXCLUDECLIPRECT = 0x0000001D

    /// EMR_INTERSECTCLIPRECT: This record defines a new clipping region from the intersection of the current clipping region and
    /// the specified rectangle.
    case EMR_INTERSECTCLIPRECT = 0x0000001E

    /// EMR_SCALEVIEWPORTEXTEX: This record redefines the viewport using the ratios formed by the specified multiplicands and
    /// divisors.
    case EMR_SCALEVIEWPORTEXTEX = 0x0000001F

    /// EMR_SCALEWINDOWEXTEX: This record redefines the window using the ratios formed by the specified multiplicands and
    /// divisors.
    case EMR_SCALEWINDOWEXTEX = 0x00000020

    /// EMR_SAVEDC: This record saves the current state of the playback device context (section 3.1) in an array of states saved by
    /// preceding EMR_SAVEDC records if any.
    case EMR_SAVEDC = 0x00000021

    /// EMR_RESTOREDC: This record restores the playback device context to the specified state, which was saved by a preceding
    /// EMR_SAVEDC record (section 2.3.11).
    case EMR_RESTOREDC = 0x00000022

    /// EMR_SETWORLDTRANSFORM: This record defines a two-dimensional linear transform between world space and page space
    /// [MSDN-WRLDPGSPC].
    case EMR_SETWORLDTRANSFORM = 0x00000023

    /// EMR_MODIFYWORLDTRANSFORM: This record redefines the world transform by using the specified mode.
    case EMR_MODIFYWORLDTRANSFORM = 0x00000024

    /// EMR_SELECTOBJECT: This record selects an object in the playback device context, which is identified by its index in the EMF
    /// object table (section 3.1.1.1).
    case EMR_SELECTOBJECT = 0x00000025

    /// EMR_CREATEPEN: This record defines a logical pen (section 2.2.19) that has the specified style, width, and color.
    case EMR_CREATEPEN = 0x00000026

    /// EMR_CREATEBRUSHINDIRECT: This record defines a logical brush for filling figures in graphics operations.
    case EMR_CREATEBRUSHINDIRECT = 0x00000027

    /// EMR_DELETEOBJECT: This record deletes a graphics object, clearing its index in the EMF object table.
    case EMR_DELETEOBJECT = 0x00000028

    /// EMR_ANGLEARC: This record defines a line segment of an arc. The line segment is drawn from the current drawing position
    /// to the beginning of the arc. The arc is drawn along the perimeter of a circle with the given radius and center. The length of the arc is defined by the given start and sweep angles.
    case EMR_ANGLEARC = 0x00000029

    /// EMR_ELLIPSE: This record defines an ellipse. The center of the ellipse is the center of the specified bounding rectangle.
    /// The ellipse is outlined by using the current pen and is filled by using the current brush.
    case EMR_ELLIPSE = 0x0000002A

    /// EMR_RECTANGLE: This record defines a rectangle. The rectangle is outlined by using the current pen and filled by using the
    /// current brush.
    case EMR_RECTANGLE = 0x0000002B

    /// EMR_ROUNDRECT: This record defines a rectangle with rounded corners. The rectangle is outlined by using the current pen
    /// and filled by using the current brush.
    case EMR_ROUNDRECT = 0x0000002C

    /// EMR_ARC: This record defines an elliptical arc.
    case EMR_ARC = 0x0000002D

    /// EMR_CHORD: This record defines a chord, which is a region bounded by the intersection of an ellipse and a line segment,
    /// called a secant. The chord is outlined by using the current pen and filled by using the current brush.
    case EMR_CHORD = 0x0000002E

    /// EMR_PIE: This record defines a pie-shaped wedge bounded by the intersection of an ellipse and two radials. The pie is
    /// outlined by using the current pen and filled by using the current brush.
    case EMR_PIE = 0x0000002F

    /// EMR_SELECTPALETTE: This record selects a LogPalette object (section 2.2.17) into the playback device context, identifying it
    /// by its index in the EMF object table.
    case EMR_SELECTPALETTE = 0x00000030

    /// EMR_CREATEPALETTE: This record defines a LogPalette object.
    case EMR_CREATEPALETTE = 0x00000031

    /// EMR_SETPALETTEENTRIES: This record defines RGB color values in a range of entries in a LogPalette object.
    case EMR_SETPALETTEENTRIES = 0x00000032

    /// EMR_RESIZEPALETTE: This record increases or decreases the size of a logical palette.
    case EMR_RESIZEPALETTE = 0x00000033

    /// EMR_REALIZEPALETTE: This record maps entries from the current logical palette to the system palette.
    case EMR_REALIZEPALETTE = 0x00000034

    /// EMR_EXTFLOODFILL: This record fills an area of the display surface with the current brush.
    case EMR_EXTFLOODFILL = 0x00000035

    /// EMR_LINETO: This record defines a line from the current drawing position up to, but not including, the specified point. It
    /// resets the current drawing position to the specified point.
    case EMR_LINETO = 0x00000036

    /// EMR_ARCTO: This record defines an elliptical arc. It resets the current position to the endpoint of the arc.
    case EMR_ARCTO = 0x00000037

    /// EMR_POLYDRAW: This record defines a set of line segments and Bezier curves.
    case EMR_POLYDRAW = 0x00000038

    /// EMR_SETARCDIRECTION: This record defines the drawing direction to be used for arc and rectangle operations.
    case EMR_SETARCDIRECTION = 0x00000039

    /// EMR_SETMITERLIMIT: This record defines the limit for the length of miter joins.
    case EMR_SETMITERLIMIT = 0x0000003A

    /// EMR_BEGINPATH: This record opens a path bracket for specifying the current path.
    case EMR_BEGINPATH = 0x0000003B

    /// EMR_ENDPATH: This record closes an open path bracket and selects the path into the playback device context.
    case EMR_ENDPATH = 0x0000003C

    /// EMR_CLOSEFIGURE: This record closes an open figure in a path.
    case EMR_CLOSEFIGURE = 0x0000003D

    /// EMR_FILLPATH: This record closes any open figures in the current path bracket and fills its interior by using the current brush
    /// and polygon-filling mode.
    case EMR_FILLPATH = 0x0000003E

    /// EMR_STROKEANDFILLPATH: This record closes any open figures in a path, strokes the outline of the path by using the current
    /// pen, and fills its interior by using the current brush.
    case EMR_STROKEANDFILLPATH = 0x0000003F

    /// EMR_STROKEPATH: This record renders the specified path by using the current pen.
    case EMR_STROKEPATH = 0x00000040

    /// EMR_FLATTENPATH: This record turns each curve in the path into a sequence of lines.
    case EMR_FLATTENPATH = 0x00000041

    /// EMR_WIDENPATH: This record redefines the current path bracket as the area that would be painted if the path were stroked
    /// using the current pen.
    case EMR_WIDENPATH = 0x00000042

    /// EMR_SELECTCLIPPATH: This record specifies a clipping region as the current clipping region combined with the current path
    /// bracket, using the specified mode.
    case EMR_SELECTCLIPPATH = 0x00000043

    /// EMR_ABORTPATH: This record aborts a path bracket or discards the path from a closed path bracket.
    case EMR_ABORTPATH = 0x00000044

    /// EMR_COMMENT: This record specifies arbitrary private data.
    case EMR_COMMENT = 0x00000046

    /// EMR_FILLRGN: This record fills the specified region by using the specified brush.
    case EMR_FILLRGN = 0x00000047

    /// EMR_FRAMERGN: This record draws a border around the specified region using the specified brush.
    case EMR_FRAMERGN = 0x00000048

    /// EMR_INVERTRGN: This record inverts the colors in the specified region.
    case EMR_INVERTRGN = 0x00000049

    /// EMR_PAINTRGN: This record paints the specified region by using the current brush.
    case EMR_PAINTRGN = 0x0000004A

    /// EMR_EXTSELECTCLIPRGN: This record combines the specified region with the current clipping region, using the specified
    /// mode.
    case EMR_EXTSELECTCLIPRGN = 0x0000004B

    /// EMR_BITBLT: This record specifies a block transfer of pixels from a source bitmap to a destination rectangle, optionally in
    /// combination with a brush pattern, according to a specified raster operation.
    case EMR_BITBLT = 0x0000004C

    /// EMR_STRETCHBLT: This record specifies a block transfer of pixels from a source bitmap to a destination rectangle, optionally
    /// in combination with a brush pattern, according to a specified raster operation, stretching or compressing the output to fit the dimensions of the destination, if necessary.
    case EMR_STRETCHBLT = 0x0000004D

    /// EMR_MASKBLT: This record specifies a block transfer of pixels from a source bitmap to a destination rectangle, optionally in
    /// combination with a brush pattern and with the application of a color mask bitmap, according to specified foreground and
    /// background raster operations.
    case EMR_MASKBLT = 0x0000004E

    /// EMR_PLGBLT: This record specifies a block transfer of pixels from a source bitmap to a destination parallelogram, with the
    /// application of a color mask bitmap.
    case EMR_PLGBLT = 0x0000004F

    /// EMR_SETDIBITSTODEVICE: This record specifies a block transfer of pixels from specified scanlines of a source bitmap to a
    /// destination rectangle.
    case EMR_SETDIBITSTODEVICE = 0x00000050

    /// EMR_STRETCHDIBITS: This record specifies a block transfer of pixels from a source bitmap to a destination rectangle,
    /// optionally in combination with a brush pattern, according to a specified raster operation, stretching or compressing the output
    /// to fit the dimensions of the destination, if necessary.
    case EMR_STRETCHDIBITS = 0x00000051

    /// EMR_EXTCREATEFONTINDIRECTW: This record defines a logical font that has the specified characteristics. The font can
    /// subsequently be selected as the current font.
    case EMR_EXTCREATEFONTINDIRECTW = 0x00000052

    /// EMR_EXTTEXTOUTA: This record draws an ASCII text string using the current font and text colors.
    case EMR_EXTTEXTOUTA = 0x00000053

    /// EMR_EXTTEXTOUTW: This record draws a Unicode text string using the current font and text colors.
    case EMR_EXTTEXTOUTW = 0x00000054

    /// EMR_POLYBEZIER16: This record defines one or more Bezier curves. The curves are drawn using the current pen.
    case EMR_POLYBEZIER16 = 0x00000055

    /// EMR_POLYGON16: This record defines a polygon consisting of two or more vertexes connected by straight lines. The polygon
    /// is outlined by using the current pen and filled by using the current brush and polygon fill mode. The polygon is closed automatically by drawing a line from the last vertex to the first.
    case EMR_POLYGON16 = 0x00000056

    /// EMR_POLYLINE16: This record defines a series of line segments by connecting the points in the specified array.
    case EMR_POLYLINE16 = 0x00000057

    /// EMR_POLYBEZIERTO16: This record defines one or more Bezier curves based on the current position.
    case EMR_POLYBEZIERTO16 = 0x00000058

    /// EMR_POLYLINETO16: This record defines one or more straight lines based upon the current position. A line is drawn from the
    /// current position to the first point specified by the Points field by using the current pen. For each additional line, drawing is
    /// performed from the ending point of the previous line to the next point specified by Points.
    case EMR_POLYLINETO16 = 0x00000059

    /// EMR_POLYPOLYLINE16: This record defines multiple series of connected line segments.
    case EMR_POLYPOLYLINE16 = 0x0000005A

    /// EMR_POLYPOLYGON16: This record defines a series of closed polygons. Each polygon is outlined by using the current pen
    /// and filled by using the current brush and polygon fill mode. The polygons specified by this record can overlap.
    case EMR_POLYPOLYGON16 = 0x0000005B

    /// EMR_POLYDRAW16: This record defines a set of line segments and Bezier curves.
    case EMR_POLYDRAW16 = 0x0000005C

    /// EMR_CREATEMONOBRUSH: This record defines a logical brush with the specified bitmap pattern. The bitmap can be a
    /// device-independent bitmap (DIB) section bitmap or it can be a devicedependent bitmap.
    case EMR_CREATEMONOBRUSH = 0x0000005D

    /// EMR_CREATEDIBPATTERNBRUSHPT: This record defines a logical brush that has the pattern specified by the DIB.
    case EMR_CREATEDIBPATTERNBRUSHPT = 0x0000005E

    /// EMR_EXTCREATEPEN: This record defines an extended logical pen (section 2.2.20) that has the specified style, width, color,
    /// and brush attributes.
    case EMR_EXTCREATEPEN = 0x0000005F

    /// EMR_POLYTEXTOUTA: This record draws one or more ASCII text strings using the current font and text colors.
    /// Note: EMR_POLYTEXTOUTA SHOULD be emulated with a series of EMR_EXTTEXTOUTW records, one per string.<3>
    case EMR_POLYTEXTOUTA = 0x00000060

    /// EMR_POLYTEXTOUTW: This record draws one or more Unicode text strings using the current font and text colors.
    /// Note: EMR_POLYTEXTOUTW SHOULD be emulated with a series of EMR_EXTTEXTOUTW records, one per string.<4>
    case EMR_POLYTEXTOUTW = 0x00000061

    /// EMR_SETICMMODE: This record specifies the mode of Image Color Management (ICM) for graphics operations.<5>
    case EMR_SETICMMODE = 0x00000062

    /// EMR_CREATECOLORSPACE: This record creates a logical color space object from a color profile with a name consisting of
    /// ASCII characters.<6>
    case EMR_CREATECOLORSPACE = 0x00000063

    /// EMR_SETCOLORSPACE: This record defines the current logical color space object for graphics operations.<7>
    case EMR_SETCOLORSPACE = 0x00000064

    /// EMR_DELETECOLORSPACE: This record deletes a logical color space object.<8>
    /// Note: An EMR_DELETEOBJECT record SHOULD be used instead of EMR_DELETECOLORSPACE to delete a logical color
    /// space object.<9>
    case EMR_DELETECOLORSPACE = 0x00000065

    /// EMR_GLSRECORD: This record specifies an OpenGL function.<10>
    case EMR_GLSRECORD = 0x00000066

    /// EMR_GLSBOUNDEDRECORD: This record specifies an OpenGL function with a bounding rectangle for output.<11>
    case EMR_GLSBOUNDEDRECORD = 0x00000067

    /// EMR_PIXELFORMAT: This record specifies the pixel format to use for graphics operations.<12>
    case EMR_PIXELFORMAT = 0x00000068

    /// EMR_DRAWESCAPE: This record passes arbitrary information to the driver. The intent is that the information results in drawing
    /// being done.
    case EMR_DRAWESCAPE = 0x00000069

    /// EMR_EXTESCAPE: This record passes arbitrary information to the driver. The intent is that the information does not result in
    /// drawing being done.
    case EMR_EXTESCAPE = 0x0000006A

    /// EMR_SMALLTEXTOUT: This record outputs a string.
    case EMR_SMALLTEXTOUT = 0x0000006C

    /// EMR_FORCEUFIMAPPING: This record forces the font mapper to match fonts based on their UniversalFontId in preference to
    /// their LogFont information.
    case EMR_FORCEUFIMAPPING = 0x0000006D

    /// EMR_NAMEDESCAPE: This record passes arbitrary information to the given named driver.
    case EMR_NAMEDESCAPE = 0x0000006E

    /// EMR_COLORCORRECTPALETTE: This record specifies how to correct the entries of a logical palette object using Windows
    /// Color System (WCS) 1.0 values.<13>
    case EMR_COLORCORRECTPALETTE = 0x0000006F

    /// EMR_SETICMPROFILEA: This record specifies a color profile in a file with a name consisting of ASCII characters, for graphics
    /// output.<14>
    case EMR_SETICMPROFILEA = 0x00000070

    /// EMR_SETICMPROFILEW: This record specifies a color profile in a file with a name consisting of Unicode characters, for
    /// graphics output.<15>
    case EMR_SETICMPROFILEW = 0x00000071

    /// EMR_ALPHABLEND: This record specifies a block transfer of pixels from a source bitmap to a destination rectangle, including
    /// alpha transparency data, according to a specified blending operation.<16>
    case EMR_ALPHABLEND = 0x00000072

    /// EMR_SETLAYOUT: This record specifies the order in which text and graphics are drawn.<17>
    case EMR_SETLAYOUT = 0x00000073

    /// EMR_TRANSPARENTBLT: This record specifies a block transfer of pixels from a source bitmap to a destination rectangle,
    /// treating a specified color as transparent, stretching or compressing the output to fit the dimensions of the destination, if
    /// necessary.<18>
    case EMR_TRANSPARENTBLT = 0x00000074

    /// EMR_GRADIENTFILL: This record specifies filling rectangles or triangles with gradients of color.<19>
    case EMR_GRADIENTFILL = 0x00000076

    /// EMR_SETLINKEDUFIS: This record sets the UniversalFontIds (section 2.2.27) of linked fonts to use during character lookup.
    case EMR_SETLINKEDUFIS = 0x00000077

    /// EMR_SETTEXTJUSTIFICATION: This record specifies the amount of extra space to add to break characters for justification
    /// purposes.<20>
    case EMR_SETTEXTJUSTIFICATION = 0x00000078

    /// EMR_COLORMATCHTOTARGETW: This record specifies whether to perform color matching with a color profile that is specified
    /// in a file with a name consisting of Unicode characters.<21>
    case EMR_COLORMATCHTOTARGETW = 0x00000079

    /// EMR_CREATECOLORSPACEW: This record creates a logical color space object from a color profile with a name consisting
    /// of Unicode characters.<22>
    case EMR_CREATECOLORSPACEW = 0x0000007A
}
