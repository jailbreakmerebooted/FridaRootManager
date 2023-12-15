import SwiftUI

struct RootView: View {
    @AppStorage("expm") var exploit_mode: Int = 0
    @AppStorage("bsl") var bsm: String = ""
    @AppStorage("csuser") var cuser = ""
    @AppStorage("fropa") var fropacity: Double = 0.8
    @AppStorage("img1") var image1: String = "frida"
    @AppStorage("dm") var debug_mode: Bool = false
    @AppStorage("zup") var zebra: Bool = true
    @AppStorage("sup") var sileo: Bool = true
    @State var isbootstrapping: Bool = false
    @State var isstrapped: Bool = false
    var body: some View {
        TabView {
            Home(cuser: $cuser, exploit_mode: $exploit_mode, bsm: $bsm, isstrapped: $isstrapped, fropacity: $fropacity, image1: $image1, debug_mode: $debug_mode, zebra: $zebra, sileo: $sileo)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                if isstrapped == true {
                    Terminal(bsm: $bsm, image1: $image1, fropacity: $fropacity, cuser: $cuser)
                        .tabItem {
                            Label("Terminal", systemImage: "terminal")
                        }
                    PackageManager(bsm: $bsm, fropacity: $fropacity, image1: $image1)
                        .tabItem {
                            Label("Packages", systemImage: "archivebox")
                        }
                }
            File_Manager(fd: "/",cuser: $cuser, exploit_mode: $exploit_mode, fropacity: $fropacity, image1: $image1, bsm: $bsm)
                    .tabItem {
                        Label("File Manager", systemImage: "folder")
                    }
            settings(exploit_mode: $exploit_mode, bsm: $bsm, fropacity: $fropacity, image1: $image1, debug_mode: $debug_mode, zebra: $zebra, sileo: $sileo)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
