import XCTest
@testable import EmfReader

final class DumpFileTests: XCTestCase {
    func testDumpEmf() throws {
        /// Not witnessed:
        /// - EMR_MASKBLT
        /// - EMR_PLGBLT
        /// - EMR_DRAWESCAPE
        /// - EMR_NAMEDESCAPE
        /// - EMR_CREATECOLORSPACE
        /// - EMR_COLORCORRECTPALETTE
        /// - EMR_DELETECOLORSPACE
        /// - EMR_RESIZEPALETTE
        /// - EMR_SETPALETTEENTRIES
        /// - EMR_GLSBOUNDEDRECORD
        /// - EMR_GLSRECORD
        /// - EMR_COLORMATCHTOTARGETW
        /// - EMR_INVERTRGN
        /// - EMR_PIXELFORMAT
        /// - EMR_SCALEVIEWPORTEXTEX
        /// - EMR_SCALEWINDOWEXTEX
        /// - EMR_SETICMPROFILEA
        /// - EMR_SETICMPROFILEW
        /// - EMR_SETMAPPERFLAGS
        
        var files: [(String, String)] = []
        files.append(("aspose_File1", "emf"))
        files.append(("aspose_missing-font", "emf"))
        files.append(("aspose_Picture1", "emf"))
        files.append(("aspose_Picture2", "emf"))
        files.append(("aspose_SmoothingTest", "emf"))
        files.append(("aspose_test", "emf"))
        files.append(("aspose_TextHintTest", "emf"))
        files.append(("NicheRecords", "emf"))
        files.append(("EMFSpool_0000", "emf"))
        files.append(("EMFSpool_0001", "emf"))
        files.append(("EMFSpool_0002", "emf"))
        files.append(("EMFSpool_0003", "emf"))
        files.append(("EMFSpool_0004", "emf"))
        files.append(("EMFSpool_0005", "emf"))
        files.append(("EMFSpool_0006", "emf"))
        files.append(("EMFSpool_0007", "emf"))
        files.append(("EMFSpool_0008", "emf"))
        files.append(("EMFSpool_0009", "emf"))
        files.append(("EMFSpool_0010", "emf"))
        files.append(("EMFSpool_0011", "emf"))
        files.append(("EMFSpool_0012", "emf"))
        files.append(("EMFSpool_0013", "emf"))
        files.append(("EMFSpool_0014", "emf"))
        files.append(("EMFSpool_0015", "emf"))
        files.append(("EMFSpool_0016", "emf"))
        files.append(("EMFSpool_0017", "emf"))
        files.append(("EMFSpool_0018", "emf"))
        files.append(("EMFSpool_0019", "emf"))
        files.append(("EMFSpool_0020", "emf"))
        files.append(("EMFSpool_0021", "emf"))
        files.append(("LibreOffice_1", "emf"))
        files.append(("LibreOffice_20000532000076E3000072DCFAEC1969", "emf"))
        files.append(("LibreOffice_37281_reduced", "emf"))
        files.append(("LibreOffice_60638_shape2", "emf"))
        files.append(("LibreOffice_DrawLineWithTexture", "emf"))
        files.append(("LibreOffice_TextureBrush", "emf"))
        files.append(("LibreOffice_TileImage", "emf"))
        files.append(("LibreOffice_bug3", "emf"))
        files.append(("LibreOffice_bug3a", "EMF"))
        files.append(("LibreOffice_bug3d", "EMF"))
        files.append(("LibreOffice_emf", "emf"))
        files.append(("LibreOffice_fdo48916", "emf"))
        files.append(("LibreOffice_image004", "emf"))
        files.append(("LibreOffice_image1 (1)", "emf"))
        files.append(("LibreOffice_image1 (2)", "emf"))
        files.append(("LibreOffice_image1", "emf"))
        files.append(("LibreOffice_image15", "emf"))
        files.append(("LibreOffice_image21", "emf"))
        files.append(("LibreOffice_image3", "emf"))
        files.append(("LibreOffice_landscape", "emf"))
        files.append(("LibreOffice_rotimage2", "emf"))
        files.append(("LibreOffice_sign with bold border", "emf"))
        files.append(("LibreOffice_tdf104771-no-text", "emf"))
        files.append(("LibreOffice_tdf115148-extracted", "emf"))
        files.append(("LibreOffice_test-bug-70710", "emf"))
        files.append(("LibreOffice_test", "emf"))
        files.append(("LibreOffice_test_libuemf_p_ref", "emf"))
        files.append(("LibreOffice_test_libuemf_ref30", "emf"))
        files.append(("LibreOffice_computer_mail", "emf"))
        files.append(("LibreOffice_ETO_PDY", "emf"))
        files.append(("LibreOffice_image1", "emf"))
        files.append(("LibreOffice_line_styles", "emf"))
        files.append(("LibreOffice_sine_wave", "emf"))
        files.append(("LibreOffice_TextMapMode", "emf"))
        files.append(("LibreOffice_TestDrawLine", "emf"))
        files.append(("LibreOffice_fdo79679-2", "emf"))
        files.append(("LibreOffice_tdf39894", "emf"))
        files.append(("LibreOffice_TestDrawString", "emf"))
        files.append(("LibreOffice_test_mm_hienglish_ref", "emf"))
        files.append(("LibreOffice_TestDrawStringTransparent", "emf"))
        files.append(("LibreOffice_test_mm_himetric_ref", "emf"))
        files.append(("LibreOffice_TestLinearGradient", "emf"))
        files.append(("WMFPreview_bird", "emf"))
        files.append(("image-type_test-2", "emf"))
        files.append(("image-type_test-3", "emf"))
        files.append(("image-type_test-emf-plus", "emf"))
        files.append(("image-type_test", "emf"))
        files.append(("libyal_Memo", "emf"))
        files.append(("libgdiplus_test", "emf"))
        files.append(("online_example", "emf"))
        files.append(("test-000", "emf"))
        files.append(("test-001", "emf"))
        files.append(("test-002", "emf"))
        files.append(("test-003", "emf"))
        files.append(("test-004", "emf"))
        files.append(("test-005", "emf"))
        files.append(("test-006", "emf"))
        files.append(("test-007", "emf"))
        files.append(("test-008", "emf"))
        files.append(("test-009", "emf"))
        files.append(("test-010", "emf"))
        files.append(("test-011", "emf"))
        files.append(("test-012", "emf"))
        files.append(("test-013", "emf"))
        files.append(("test-014", "emf"))
        files.append(("test-015", "emf"))
        files.append(("test-016", "emf"))
        files.append(("test-017", "emf"))
        files.append(("test-018", "emf"))
        files.append(("test-019", "emf"))
        files.append(("test-020", "emf"))
        files.append(("test-021", "emf"))
        files.append(("test-022", "emf"))
        files.append(("test-023", "emf"))
        files.append(("test-024", "emf"))
        files.append(("test-025", "emf"))
        files.append(("test-026", "emf"))
        files.append(("test-027", "emf"))
        files.append(("test-028", "emf"))
        files.append(("test-029", "emf"))
        files.append(("test-030", "emf"))
        files.append(("test-031", "emf"))
        files.append(("test-032", "emf"))
        files.append(("test-033", "emf"))
        files.append(("test-034", "emf"))
        files.append(("test-035", "emf"))
        files.append(("test-036", "emf"))
        files.append(("test-037", "emf"))
        files.append(("test-038", "emf"))
        files.append(("test-039", "emf"))
        files.append(("test-040", "emf"))
        files.append(("test-041", "emf"))
        files.append(("test-042", "emf"))
        files.append(("test-043", "emf"))
        files.append(("test-044", "emf"))
        files.append(("test-045", "emf"))
        files.append(("test-046", "emf"))
        files.append(("test-047", "emf"))
        files.append(("test-048", "emf"))
        files.append(("test-049", "emf"))
        files.append(("test-050", "emf"))
        files.append(("test-051", "emf"))
        files.append(("test-052", "emf"))
        files.append(("test-053", "emf"))
        files.append(("test-054", "emf"))
        files.append(("test-055", "emf"))
        files.append(("test-056", "emf"))
        files.append(("test-057", "emf"))
        files.append(("test-058", "emf"))
        files.append(("test-059", "emf"))
        files.append(("test-060", "emf"))
        files.append(("test-061", "emf"))
        files.append(("test-062", "emf"))
        files.append(("test-063", "emf"))
        files.append(("test-064", "emf"))
        files.append(("test-065", "emf"))
        files.append(("test-066", "emf"))
        files.append(("test-067", "emf"))
        files.append(("test-068", "emf"))
        files.append(("test-069", "emf"))
        files.append(("test-070", "emf"))
        files.append(("test-071", "emf"))
        files.append(("test-072", "emf"))
        files.append(("test-073", "emf"))
        files.append(("test-074", "emf"))
        files.append(("test-075", "emf"))
        files.append(("test-076", "emf"))
        files.append(("test-077", "emf"))
        files.append(("test-078", "emf"))
        files.append(("test-079", "emf"))
        files.append(("test-080", "emf"))
        files.append(("test-081", "emf"))
        files.append(("test-082", "emf"))
        files.append(("test-083", "emf"))
        files.append(("test-084", "emf"))
        files.append(("test-085", "emf"))
        files.append(("test-086", "emf"))
        files.append(("test-087", "emf"))
        files.append(("test-088", "emf"))
        files.append(("test-089", "emf"))
        files.append(("test-090", "emf"))
        files.append(("test-091", "emf"))
        files.append(("test-092", "emf"))
        files.append(("test-093", "emf"))
        files.append(("test-094", "emf"))
        files.append(("test-095", "emf"))
        files.append(("test-096", "emf"))
        files.append(("test-097", "emf"))
        files.append(("test-098", "emf"))
        files.append(("test-099", "emf"))
        files.append(("test-100", "emf"))
        files.append(("test-101", "emf"))
        files.append(("test-102", "emf"))
        files.append(("test-103", "emf"))
        files.append(("test-104", "emf"))
        files.append(("test-105", "emf"))
        files.append(("test-106", "emf"))
        files.append(("test-107", "emf"))
        files.append(("test-108", "emf"))
        files.append(("test-109", "emf"))
        files.append(("test-110", "emf"))
        files.append(("test-111", "emf"))
        files.append(("test-112", "emf"))
        files.append(("test-113", "emf"))
        files.append(("test-114", "emf"))
        files.append(("test-115", "emf"))
        files.append(("test-116", "emf"))
        files.append(("test-117", "emf"))
        files.append(("test-118", "emf"))
        files.append(("test-119", "emf"))
        files.append(("test-120", "emf"))
        files.append(("test-121", "emf"))
        files.append(("test-122", "emf"))
        files.append(("test-123", "emf"))
        files.append(("test-124", "emf"))
        files.append(("test-125", "emf"))
        files.append(("test-126", "emf"))
        files.append(("test-127", "emf"))
        files.append(("test-128", "emf"))
        files.append(("test-129", "emf"))
        files.append(("test-130", "emf"))
        files.append(("test-131", "emf"))
        files.append(("test-132", "emf"))
        files.append(("test-133", "emf"))
        files.append(("test-134", "emf"))
        files.append(("test-135", "emf"))
        files.append(("test-136", "emf"))
        files.append(("test-137", "emf"))
        files.append(("test-138", "emf"))
        files.append(("test-139", "emf"))
        files.append(("test-140", "emf"))
        files.append(("test-141", "emf"))
        files.append(("test-142", "emf"))
        files.append(("test-143", "emf"))
        files.append(("test-144", "emf"))
        files.append(("test-145", "emf"))
        files.append(("test-146", "emf"))
        files.append(("test-147", "emf"))
        files.append(("test-148", "emf"))
        files.append(("test-149", "emf"))
        files.append(("test-150", "emf"))
        files.append(("test-152", "emf"))
        files.append(("test-153", "emf"))
        files.append(("test-154", "emf"))
        files.append(("test-155", "emf"))
        files.append(("test-156", "emf"))
        files.append(("test-157", "emf"))
        files.append(("test-158", "emf"))
        files.append(("test-159", "emf"))
        files.append(("test-160", "emf"))
        files.append(("test-161", "emf"))
        files.append(("test-162", "emf"))
        files.append(("test-163", "emf"))
        files.append(("test-164", "emf"))
        files.append(("test-165", "emf"))
        files.append(("test-166", "emf"))
        files.append(("test-167", "emf"))
        files.append(("test-168", "emf"))
        files.append(("test-169", "emf"))
        files.append(("test-170", "emf"))
        files.append(("test-171", "emf"))
        files.append(("test-172", "emf"))
        files.append(("test-173", "emf"))
        files.append(("test-174", "emf"))
        files.append(("test-175", "emf"))
        files.append(("test-176", "emf"))
        files.append(("test-177", "emf"))
        files.append(("test-178", "emf"))
        files.append(("test-179", "emf"))
        files.append(("test-180", "emf"))
        files.append(("test-181", "emf"))
        files.append(("test-182", "emf"))
        files.append(("test-183", "emf"))
        files.append(("test-184", "emf"))
        files.append(("test-185", "emf"))
        files.append(("test-186", "emf"))
        files.append(("runtime-assets_milkmateya01", "emf"))
        for (name, fileExtension) in files {
            let data = try getData(name: name, fileExtension: fileExtension)
            let file = try EmfFile(data: data)
            try file.enumerateRecords { record in
                if case .stretchDIBits = record {
                    print("EMR_STRETCHDIBITS")
                } else {
                    print(record)
                }

                return .continue
            }
        }
    }

    static var allTests = [
        ("testDumpEmf", testDumpEmf),
    ]
}
