//
//  EmfRecord.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

public enum EmfRecord {
    case polyBezier(_: EMR_POLYBEZIER)
    case polygon(_: EMR_POLYGON)
    case polyLine(_: EMR_POLYLINE)
    case polyBezierTo(_: EMR_POLYBEZIERTO)
    case polyLineTo(_: EMR_POLYLINETO)
    case polyPolyLine(_: EMR_POLYPOLYLINE)
    case polyPolygon(_: EMR_POLYPOLYGON)
    case setWindowExtEx(_: EMR_SETWINDOWEXTEX)
    case setWindowOrgEx(_: EMR_SETWINDOWORGEX)
    case setViewportExtEx(_: EMR_SETVIEWPORTEXTEX)
    case setViewportOrgEx(_: EMR_SETVIEWPORTORGEX)
    case setBrushOrgEx(_: EMR_SETBRUSHORGEX)
    case eof(_: EMR_EOF)
    case setPixelV(_: EMR_SETPIXELV)
    case setMapperFlags(_: EMR_SETMAPPERFLAGS)
    case setMapMode(_: EMR_SETMAPMODE)
    case setBkMode(_: EMR_SETBKMODE)
    case setPolyFillMode(_: EMR_SETPOLYFILLMODE)
    case setRop2(_: EMR_SETROP2)
    case setStretchBltMode(_: EMR_SETSTRETCHBLTMODE)
    case setTextAlign(_: EMR_SETTEXTALIGN)
    case setColorAdjustment(_: EMR_SETCOLORADJUSTMENT)
    case setTextColor(_: EMR_SETTEXTCOLOR)
    case setBkColor(_: EMR_SETBKCOLOR)
    case offsetClipRgn(_: EMR_OFFSETCLIPRGN)
    case moveToEx(_: EMR_MOVETOEX)
    case setMetaRgn(_: EMR_SETMETARGN)
    case excludeClipRect(_: EMR_EXCLUDECLIPRECT)
    case intersectClipRect(_: EMR_INTERSECTCLIPRECT)
    case scaleVieportExtEx(_: EMR_SCALEVIEWPORTEXTEX)
    case scaleWindowExtEx(_: EMR_SCALEWINDOWEXTEX)
    case saveDC(_: EMR_SAVEDC)
    case restoreDC(_: EMR_RESTOREDC)
    case setWorldTransform(_: EMR_SETWORLDTRANSFORM)
    case modifyWorldTransform(_: EMR_MODIFYWORLDTRANSFORM)
    case selectObject(_: EMR_SELECTOBJECT)
    case createPen(_: EMR_CREATEPEN)
    case createBrushIndirect(_: EMR_CREATEBRUSHINDIRECT)
    case deleteObject(_: EMR_DELETEOBJECT)
    case angleArc(_: EMR_ANGLEARC)
    case ellipse(_: EMR_ELLIPSE)
    case rectangle(_: EMR_RECTANGLE)
    case roundRect(_: EMR_ROUNDRECT)
    case arc(_: EMR_ARC)
    case chord(_: EMR_CHORD)
    case pie(_: EMR_PIE)
    case selectPalette(_: EMR_SELECTPALETTE)
    case createPalette(_: EMR_CREATEPALETTE)
    case extFloodFill(_: EMR_EXTFLOODFILL)
    case lineTo(_: EMR_LINETO)
    case resizePalette(_: EMR_RESIZEPALETTE)
    case setPaletteEntries(_: EMR_SETPALETTEENTRIES)
    case realizePalette(_: EMR_REALIZEPALETTE)
    case arcTo(_: EMR_ARCTO)
    case polyDraw(_: EMR_POLYDRAW)
    case setArcDirection(_: EMR_SETARCDIRECTION)
    case setMiterLimit(_: EMR_SETMITERLIMIT)
    case beginPath(_: EMR_BEGINPATH)
    case endPath(_: EMR_ENDPATH)
    case closeFigure(_: EMR_CLOSEFIGURE)
    case fillPath(_: EMR_FILLPATH)
    case strokeAndFillPath(_: EMR_STROKEANDFILLPATH)
    case strokePath(_: EMR_STROKEPATH)
    case flattenPath(_: EMR_FLATTENPATH)
    case widenPath(_: EMR_WIDENPATH)
    case selectClipPath(_: EMR_SELECTCLIPPATH)
    case abortPath(_: EMR_ABORTPATH)
    case comment(_: CommentRecord)
    case fillRgn(_: EMR_FILLRGN)
    case frameRgn(_: EMR_FRAMERGN)
    case invertRgn(_: EMR_INVERTRGN)
    case paintRgn(_: EMR_PAINTRGN)
    case extSelectClipRgn(_: EMR_EXTSELECTCLIPRGN)
    case bitBlt(_: EMR_BITBLT)
    case stretchBlt(_: EMR_STRETCHBLT)
    case maskBlt(_: EMR_MASKBLT)
    case plgBlt(_: EMR_PLGBLT)
    case setBitsToDevice(_: EMR_SETDIBITSTODEVICE)
    case stretchDIBits(_: EMR_STRETCHDIBITS)
    case extCreateFontIndirectW(_: EMR_EXTCREATEFONTINDIRECTW)
    case extTextOutA(_: EMR_EXTTEXTOUTA)
    case extTextOutW(_: EMR_EXTTEXTOUTW)
    case polyBezier16(_: EMR_POLYBEZIER16)
    case polygon16(_: EMR_POLYGON16)
    case polyLine16(_: EMR_POLYLINE16)
    case polyBezierTo16(_: EMR_POLYBEZIERTO16)
    case polyLineTo16(_: EMR_POLYLINETO16)
    case polyPolyLine16(_: EMR_POLYPOLYLINE16)
    case polyPolygon16(_: EMR_POLYPOLYGON16)
    case polyDraw16(_: EMR_POLYDRAW16)
    case createMonoBrush(_: EMR_CREATEMONOBRUSH)
    case createDIBPatternBrushPt(_: EMR_CREATEDIBPATTERNBRUSHPT)
    case extCreatePen(_: EMR_EXTCREATEPEN)
    case polyTextOutA(_: EMR_POLYTEXTOUTA)
    case polyTextOutW(_: EMR_POLYTEXTOUTW)
    case setICMMode(_: EMR_SETICMMODE)
    case createColorSpace(_: EMR_CREATECOLORSPACE)
    case setColorSpace(_: EMR_SETCOLORSPACE)
    case deleteColorSpace(_: EMR_DELETECOLORSPACE)
    case glsRecord(_: EMR_GLSRECORD)
    case glsBoundedRecord(_: EMR_GLSBOUNDEDRECORD)
    case pixelFormat(_: EMR_PIXELFORMAT)
    case drawEscape(_: EMR_DRAWESCAPE)
    case extEscape(_: EMR_EXTESCAPE)
    case smallTextOut(_: EMR_SMALLTEXTOUT)
    case forceUFIMapping(_: EMR_FORCEUFIMAPPING)
    case namedEscape(_: EMR_NAMEDESCAPE)
    case colorCorrectPalette(_: EMR_COLORCORRECTPALETTE)
    case setICMProfileA(_: EMR_SETICMPROFILEA)
    case setICMProfileW(_: EMR_SETICMPROFILEW)
    case alphaBlend(_: EMR_ALPHABLEND)
    case setLayout(_: EMR_SETLAYOUT)
    case transparentBlt(_: EMR_TRANSPARENTBLT)
    case gradientFill(_: EMR_GRADIENTFILL)
    case setLinkedUFIs(_: EMR_SETLINKEDUFIS)
    case setTextJustification(_: EMR_SETTEXTJUSTIFICATION)
    case colorMatchToTargetW(_: EMR_COLORMATCHTOTARGETW)
    case createColorSpaceW(_: EMR_CREATECOLORSPACEW)
    
    public init(dataStream: inout DataStream) throws {
        let position = dataStream.position
        let type = try RecordType(dataStream: &dataStream)
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 8 && size % 4 == 0 else {
            throw EmfReadError.corrupted
        }
        
        dataStream.position = position
        
        switch type {
        case .EMR_HEADER:
            throw EmfReadError.corrupted
        case .EMR_POLYBEZIER:
            self = .polyBezier(try EMR_POLYBEZIER(dataStream: &dataStream))
        case .EMR_POLYGON:
            self = .polygon(try EMR_POLYGON(dataStream: &dataStream))
        case .EMR_POLYLINE:
            self = .polyLine(try EMR_POLYLINE(dataStream: &dataStream))
        case .EMR_POLYBEZIERTO:
            self = .polyBezierTo(try EMR_POLYBEZIERTO(dataStream: &dataStream))
        case .EMR_POLYLINETO:
            self = .polyLineTo(try EMR_POLYLINETO(dataStream: &dataStream))
        case .EMR_POLYPOLYLINE:
            self = .polyPolyLine(try EMR_POLYPOLYLINE(dataStream: &dataStream))
        case .EMR_POLYPOLYGON:
            self = .polyPolygon(try EMR_POLYPOLYGON(dataStream: &dataStream))
        case .EMR_SETWINDOWEXTEX:
            self = .setWindowExtEx(try EMR_SETWINDOWEXTEX(dataStream: &dataStream))
        case .EMR_SETWINDOWORGEX:
            self = .setWindowOrgEx(try EMR_SETWINDOWORGEX(dataStream: &dataStream))
        case .EMR_SETVIEWPORTEXTEX:
            self = .setViewportExtEx(try EMR_SETVIEWPORTEXTEX(dataStream: &dataStream))
        case .EMR_SETVIEWPORTORGEX:
            self = .setViewportOrgEx(try EMR_SETVIEWPORTORGEX(dataStream: &dataStream))
        case .EMR_SETBRUSHORGEX:
            self = .setBrushOrgEx(try EMR_SETBRUSHORGEX(dataStream: &dataStream))
        case .EMR_EOF:
            self = .eof(try EMR_EOF(dataStream: &dataStream))
        case .EMR_SETPIXELV:
            self = .setPixelV(try EMR_SETPIXELV(dataStream: &dataStream))
        case .EMR_SETMAPPERFLAGS:
            self = .setMapperFlags(try EMR_SETMAPPERFLAGS(dataStream: &dataStream))
        case .EMR_SETMAPMODE:
            self = .setMapMode(try EMR_SETMAPMODE(dataStream: &dataStream))
        case .EMR_SETBKMODE:
            self = .setBkMode(try EMR_SETBKMODE(dataStream: &dataStream))
        case .EMR_SETPOLYFILLMODE:
            self = .setPolyFillMode(try EMR_SETPOLYFILLMODE(dataStream: &dataStream))
        case .EMR_SETROP2:
            self = .setRop2(try EMR_SETROP2(dataStream: &dataStream))
        case .EMR_SETSTRETCHBLTMODE:
            self = .setStretchBltMode(try EMR_SETSTRETCHBLTMODE(dataStream: &dataStream))
        case .EMR_SETTEXTALIGN:
            self = .setTextAlign(try EMR_SETTEXTALIGN(dataStream: &dataStream))
        case .EMR_SETCOLORADJUSTMENT:
            self = .setColorAdjustment(try EMR_SETCOLORADJUSTMENT(dataStream: &dataStream))
        case .EMR_SETTEXTCOLOR:
            self = .setTextColor(try EMR_SETTEXTCOLOR(dataStream: &dataStream))
        case .EMR_SETBKCOLOR:
            self = .setBkColor(try EMR_SETBKCOLOR(dataStream: &dataStream))
        case .EMR_OFFSETCLIPRGN:
            self = .offsetClipRgn(try EMR_OFFSETCLIPRGN(dataStream: &dataStream))
        case .EMR_MOVETOEX:
            self = .moveToEx(try EMR_MOVETOEX(dataStream: &dataStream))
        case .EMR_SETMETARGN:
            self = .setMetaRgn(try EMR_SETMETARGN(dataStream: &dataStream))
        case .EMR_EXCLUDECLIPRECT:
            self = .excludeClipRect(try EMR_EXCLUDECLIPRECT(dataStream: &dataStream))
        case .EMR_INTERSECTCLIPRECT:
            self = .intersectClipRect(try EMR_INTERSECTCLIPRECT(dataStream: &dataStream))
        case .EMR_SCALEVIEWPORTEXTEX:
            self = .scaleVieportExtEx(try EMR_SCALEVIEWPORTEXTEX(dataStream: &dataStream))
        case .EMR_SCALEWINDOWEXTEX:
            self = .scaleWindowExtEx(try EMR_SCALEWINDOWEXTEX(dataStream: &dataStream))
        case .EMR_SAVEDC:
            self = .saveDC(try EMR_SAVEDC(dataStream: &dataStream))
        case .EMR_RESTOREDC:
            self = .restoreDC(try EMR_RESTOREDC(dataStream: &dataStream))
        case .EMR_SETWORLDTRANSFORM:
            self = .setWorldTransform(try EMR_SETWORLDTRANSFORM(dataStream: &dataStream))
        case .EMR_MODIFYWORLDTRANSFORM:
            self = .modifyWorldTransform(try EMR_MODIFYWORLDTRANSFORM(dataStream: &dataStream))
        case .EMR_SELECTOBJECT:
            self = .selectObject(try EMR_SELECTOBJECT(dataStream: &dataStream))
        case .EMR_CREATEPEN:
            self = .createPen(try EMR_CREATEPEN(dataStream: &dataStream))
        case .EMR_CREATEBRUSHINDIRECT:
            self = .createBrushIndirect(try EMR_CREATEBRUSHINDIRECT(dataStream: &dataStream))
        case .EMR_DELETEOBJECT:
            self = .deleteObject(try EMR_DELETEOBJECT(dataStream: &dataStream))
        case .EMR_ANGLEARC:
            self = .angleArc(try EMR_ANGLEARC(dataStream: &dataStream))
        case .EMR_ELLIPSE:
            self = .ellipse(try EMR_ELLIPSE(dataStream: &dataStream))
        case .EMR_RECTANGLE:
            self = .rectangle(try EMR_RECTANGLE(dataStream: &dataStream))
        case .EMR_ROUNDRECT:
            self = .roundRect(try EMR_ROUNDRECT(dataStream: &dataStream))
        case .EMR_ARC:
            self = .arc(try EMR_ARC(dataStream: &dataStream))
        case .EMR_CHORD:
            self = .chord(try EMR_CHORD(dataStream: &dataStream))
        case .EMR_PIE:
            self = .pie(try EMR_PIE(dataStream: &dataStream))
        case .EMR_SELECTPALETTE:
            self = .selectPalette(try EMR_SELECTPALETTE(dataStream: &dataStream))
        case .EMR_CREATEPALETTE:
            self = .createPalette(try EMR_CREATEPALETTE(dataStream: &dataStream))
        case .EMR_SETPALETTEENTRIES:
            self = .setPaletteEntries(try EMR_SETPALETTEENTRIES(dataStream: &dataStream))
        case .EMR_RESIZEPALETTE:
            self = .resizePalette(try EMR_RESIZEPALETTE(dataStream: &dataStream))
        case .EMR_REALIZEPALETTE:
            self = .realizePalette(try EMR_REALIZEPALETTE(dataStream: &dataStream))
        case .EMR_EXTFLOODFILL:
            self = .extFloodFill(try EMR_EXTFLOODFILL(dataStream: &dataStream))
        case .EMR_LINETO:
            self = .lineTo(try EMR_LINETO(dataStream: &dataStream))
        case .EMR_ARCTO:
            self = .arcTo(try EMR_ARCTO(dataStream: &dataStream))
        case .EMR_POLYDRAW:
            self = .polyDraw(try EMR_POLYDRAW(dataStream: &dataStream))
        case .EMR_SETARCDIRECTION:
            self = .setArcDirection(try EMR_SETARCDIRECTION(dataStream: &dataStream))
        case .EMR_SETMITERLIMIT:
            self = .setMiterLimit(try EMR_SETMITERLIMIT(dataStream: &dataStream))
        case .EMR_BEGINPATH:
            self = .beginPath(try EMR_BEGINPATH(dataStream: &dataStream))
        case .EMR_ENDPATH:
            self = .endPath(try EMR_ENDPATH(dataStream: &dataStream))
        case .EMR_CLOSEFIGURE:
            self = .closeFigure(try EMR_CLOSEFIGURE(dataStream: &dataStream))
        case .EMR_FILLPATH:
            self = .fillPath(try EMR_FILLPATH(dataStream: &dataStream))
        case .EMR_STROKEANDFILLPATH:
            self = .strokeAndFillPath(try EMR_STROKEANDFILLPATH(dataStream: &dataStream))
        case .EMR_STROKEPATH:
            self = .strokePath(try EMR_STROKEPATH(dataStream: &dataStream))
        case .EMR_FLATTENPATH:
            self = .flattenPath(try EMR_FLATTENPATH(dataStream: &dataStream))
        case .EMR_WIDENPATH:
            self = .widenPath(try EMR_WIDENPATH(dataStream: &dataStream))
        case .EMR_SELECTCLIPPATH:
            self = .selectClipPath(try EMR_SELECTCLIPPATH(dataStream: &dataStream))
        case .EMR_ABORTPATH:
            self = .abortPath(try EMR_ABORTPATH(dataStream: &dataStream))
        case .EMR_COMMENT:
            self = .comment(try CommentRecord(dataStream: &dataStream))
        case .EMR_FILLRGN:
            self = .fillRgn(try EMR_FILLRGN(dataStream: &dataStream))
        case .EMR_FRAMERGN:
            self = .frameRgn(try EMR_FRAMERGN(dataStream: &dataStream))
        case .EMR_INVERTRGN:
            self = .invertRgn(try EMR_INVERTRGN(dataStream: &dataStream))
        case .EMR_PAINTRGN:
            self = .paintRgn(try EMR_PAINTRGN(dataStream: &dataStream))
        case .EMR_EXTSELECTCLIPRGN:
            self = .extSelectClipRgn(try EMR_EXTSELECTCLIPRGN(dataStream: &dataStream))
        case .EMR_BITBLT:
            self = .bitBlt(try EMR_BITBLT(dataStream: &dataStream))
        case .EMR_STRETCHBLT:
            self = .stretchBlt(try EMR_STRETCHBLT(dataStream: &dataStream))
        case .EMR_MASKBLT:
            self = .maskBlt(try EMR_MASKBLT(dataStream: &dataStream))
        case .EMR_PLGBLT:
            self = .plgBlt(try EMR_PLGBLT(dataStream: &dataStream))
        case .EMR_SETDIBITSTODEVICE:
            self = .setBitsToDevice(try EMR_SETDIBITSTODEVICE(dataStream: &dataStream))
        case .EMR_STRETCHDIBITS:
            self = .stretchDIBits(try EMR_STRETCHDIBITS(dataStream: &dataStream))
        case .EMR_EXTCREATEFONTINDIRECTW:
            self = .extCreateFontIndirectW(try EMR_EXTCREATEFONTINDIRECTW(dataStream: &dataStream))
        case .EMR_EXTTEXTOUTA:
            self = .extTextOutA(try EMR_EXTTEXTOUTA(dataStream: &dataStream))
        case .EMR_EXTTEXTOUTW:
            self = .extTextOutW(try EMR_EXTTEXTOUTW(dataStream: &dataStream))
        case .EMR_POLYBEZIER16:
            self = .polyBezier16(try EMR_POLYBEZIER16(dataStream: &dataStream))
        case .EMR_POLYGON16:
            self = .polygon16(try EMR_POLYGON16(dataStream: &dataStream))
        case .EMR_POLYLINE16:
            self = .polyLine16(try EMR_POLYLINE16(dataStream: &dataStream))
        case .EMR_POLYBEZIERTO16:
            self = .polyBezierTo16(try EMR_POLYBEZIERTO16(dataStream: &dataStream))
        case .EMR_POLYLINETO16:
            self = .polyLineTo16(try EMR_POLYLINETO16(dataStream: &dataStream))
        case .EMR_POLYPOLYLINE16:
            self = .polyPolyLine16(try EMR_POLYPOLYLINE16(dataStream: &dataStream))
        case .EMR_POLYPOLYGON16:
            self = .polyPolygon16(try EMR_POLYPOLYGON16(dataStream: &dataStream))
        case .EMR_POLYDRAW16:
            self = .polyDraw16(try EMR_POLYDRAW16(dataStream: &dataStream))
        case .EMR_CREATEMONOBRUSH:
            self = .createMonoBrush(try EMR_CREATEMONOBRUSH(dataStream: &dataStream))
        case .EMR_CREATEDIBPATTERNBRUSHPT:
            self = .createDIBPatternBrushPt(try EMR_CREATEDIBPATTERNBRUSHPT(dataStream: &dataStream))
        case .EMR_EXTCREATEPEN:
            self = .extCreatePen(try EMR_EXTCREATEPEN(dataStream: &dataStream))
        case .EMR_POLYTEXTOUTA:
            self = .polyTextOutA(try EMR_POLYTEXTOUTA(dataStream: &dataStream))
        case .EMR_POLYTEXTOUTW:
            self = .polyTextOutW(try EMR_POLYTEXTOUTW(dataStream: &dataStream))
        case .EMR_SETICMMODE:
            self = .setICMMode(try EMR_SETICMMODE(dataStream: &dataStream))
        case .EMR_CREATECOLORSPACE:
            self = .createColorSpace(try EMR_CREATECOLORSPACE(dataStream: &dataStream))
        case .EMR_SETCOLORSPACE:
            self = .setColorSpace(try EMR_SETCOLORSPACE(dataStream: &dataStream))
        case .EMR_DELETECOLORSPACE:
            self = .deleteColorSpace(try EMR_DELETECOLORSPACE(dataStream: &dataStream))
        case .EMR_GLSRECORD:
            self = .glsRecord(try EMR_GLSRECORD(dataStream: &dataStream))
        case .EMR_GLSBOUNDEDRECORD:
            self = .glsBoundedRecord(try EMR_GLSBOUNDEDRECORD(dataStream: &dataStream))
        case .EMR_PIXELFORMAT:
            self = .pixelFormat(try EMR_PIXELFORMAT(dataStream: &dataStream))
        case .EMR_DRAWESCAPE:
            self = .drawEscape(try EMR_DRAWESCAPE(dataStream: &dataStream))
        case .EMR_EXTESCAPE:
            self = .extEscape(try EMR_EXTESCAPE(dataStream: &dataStream))
        case .EMR_SMALLTEXTOUT:
            self = .smallTextOut(try EMR_SMALLTEXTOUT(dataStream: &dataStream))
        case .EMR_FORCEUFIMAPPING:
            self = .forceUFIMapping(try EMR_FORCEUFIMAPPING(dataStream: &dataStream))
        case .EMR_NAMEDESCAPE:
            self = .namedEscape(try EMR_NAMEDESCAPE(dataStream: &dataStream))
        case .EMR_COLORCORRECTPALETTE:
            self = .colorCorrectPalette(try EMR_COLORCORRECTPALETTE(dataStream: &dataStream))
        case .EMR_SETICMPROFILEA:
            self = .setICMProfileA(try EMR_SETICMPROFILEA(dataStream: &dataStream))
        case .EMR_SETICMPROFILEW:
            self = .setICMProfileW(try EMR_SETICMPROFILEW(dataStream: &dataStream))
        case .EMR_ALPHABLEND:
            self = .alphaBlend(try EMR_ALPHABLEND(dataStream: &dataStream))
        case .EMR_SETLAYOUT:
            self = .setLayout(try EMR_SETLAYOUT(dataStream: &dataStream))
        case .EMR_TRANSPARENTBLT:
            self = .transparentBlt(try EMR_TRANSPARENTBLT(dataStream: &dataStream))
        case .EMR_GRADIENTFILL:
            self = .gradientFill(try EMR_GRADIENTFILL(dataStream: &dataStream))
        case .EMR_SETLINKEDUFIS:
            self = .setLinkedUFIs(try EMR_SETLINKEDUFIS(dataStream: &dataStream))
        case .EMR_SETTEXTJUSTIFICATION:
            self = .setTextJustification(try EMR_SETTEXTJUSTIFICATION(dataStream: &dataStream))
        case .EMR_COLORMATCHTOTARGETW:
            self = .colorMatchToTargetW(try EMR_COLORMATCHTOTARGETW(dataStream: &dataStream))
        case .EMR_CREATECOLORSPACEW:
            self = .createColorSpaceW(try EMR_CREATECOLORSPACEW(dataStream: &dataStream))
        }
        
        guard dataStream.position - position == size else {
            throw EmfReadError.corrupted
        }
    }
}
