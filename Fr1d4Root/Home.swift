import SwiftUI
import MacDirtyCow
import Foundation
import ZIPFoundation
import ZipArchive
import Darwin.POSIX.spawn
import NSTaskBridge


struct Home: View {
    @ViewBuilder func Line2(_ str: String) -> some View {
        HStack {
            Text(str)
                .font(.system(size: 7, design: .monospaced))
            Spacer()
        }
    }
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    let consoleInstance = Console2()
    @State private var valmsg: String = "not set"
    @State private var progress: Double = 0.0
    @Binding var cuser: String
    @ObservedObject var c = Console2.shared
    @State var ldid = ""
    @State var ldidthispath = ""
    @State var color1: Color = Color.blue
    @State private var button1text: String = "Bootstrap Device"
    @State private var colorstat1: Color = Color.blue
    @State private var msgbox: String = "true"
    @State private var s: Bool = true
    @State private var TrollStore_UUID: String = ""
    @State private var run_protection: Bool = false
    @State private var info1: Bool = false
    @State private var info2: Bool = false
    @State private var almdc: Bool = false
    @State private var lollol: Bool = false
    @State private var roothash: String = ""
    @State private var hide_button: Bool = false
    let segments = ["Normal", "MDC", "TrollStore"]
    let segments2 = ["/var", "/var/mobile"]
    @Binding var exploit_mode: Int
    @State var isbootstrapping: Bool = false
    @AppStorage("bsmp") var exec_location_pre: Int = 0
    @Binding var bsm: String
    @State private var folderName: String = ""
    @Binding var isstrapped: Bool
    @Binding var fropacity: Double
    @Binding var image1: String
    @Binding var debug_mode: Bool
    @Binding var zebra: Bool
    @Binding var sileo: Bool
    @State private var locui: Bool = false
    let url = Bundle.main.url(forResource: "frida", withExtension: "zip")
    let pbs = Bundle.main.url(forResource: "frida", withExtension: "tar")
    let pbbs = Bundle.main.url(forResource: "usr", withExtension: "zip")
    let sl = Bundle.main.url(forResource: "sileo", withExtension: "zip")
    let zl = Bundle.main.url(forResource: "zebra", withExtension: "zip")
    var body: some View {
            NavigationView {
                ZStack {
                    Image(image1)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 10)
                    List {
                        Section {
                            if !isbootstrapping {
                                VStack {
                                    // apply all tweaks button
                                    HStack {
                                        Button("Semi-Jailbreak") {
                                            
                                        }
                                        .buttonStyle(TintedButton(color: colorstat1, fullwidth: true))
                                    }
                                    HStack {
                                        Button("Refresh") {
                                        }
                                        .buttonStyle(TintedButton(material: .systemMaterial, fullwidth: false))
                                    }
                                }
                                .listRowInsets(EdgeInsets())
                                .padding()
                                if info2 == true {
                                    VStack {
                                        Spacer().frame(height: 20)
                                        HStack {
                                            Spacer()
                                            Image(systemName: "restart.circle")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                            Spacer()
                                        }
                                        Spacer().frame(height: 20)
                                        Text("With this button you can refresh your Jailbreak. In this case FridaUtility app gets loaded to the homescreen and preboot gets remounted.")
                                            .font(.system(size: 12, weight: .bold))
                                        Spacer().frame(height: 20)
                                    }
                                }
                                if info1 == true {
                                    VStack {
                                        Spacer().frame(height: 20)
                                        HStack {
                                            Spacer()
                                            Image(systemName: "internaldrive")
                                                .resizable()
                                                .frame(width: 50, height: 40)
                                            Spacer()
                                        }
                                        Spacer().frame(height: 20)
                                        Text("With this button you can bootstrap your devices. which is cool, cause you can have a jailbreak-like experience.")
                                            .font(.system(size: 12, weight: .bold))
                                        Spacer().frame(height: 20)
                                    }
                                }
                            } else if isbootstrapping {
                                if !locui {
                                    VStack {
                                        ScrollView {
                                            VStack(alignment: .leading) {
                                                ForEach(0..<c.lines.count, id: \.self) { i in
                                                    let item = c.lines[i]
                                                    
                                                    Line2(item)
                                                        .foregroundColor(.primary)
                                                }
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(4)
                                            .flipped()
                                        }
                                        .frame(height: deviceHeight / 4)
                                        .opacity(0.8)
                                        .padding(.horizontal)
                                        .flipped()
                                        .onAppear {
                                            info1 = false
                                            info2 = false
                                        }
                                    }
                                    .padding()
                                    if hide_button {
                                        Button("Done") {
                                            hide_button = false
                                            btn1chk()
                                        }
                                    } else {
                                        VStack(alignment: .leading) {
                                            Spacer()
                                            Text(valmsg)
                                                .font(.system(size: 10))
                                            ProgressView(value: progress, total: 1.0)
                                                .progressViewStyle(LinearProgressViewStyle())
                                                .accentColor(color1)
                                            //.padding()
                                            Spacer()
                                        }
                                        .frame(height: 40)
                                    }
                                } else {
                                    VStack {
                                        Spacer().frame(height: 5)
                                        Text("PackageManager")
                                        Spacer().frame(height: 25)
                                        HStack {
                                            Spacer()
                                            VStack {
                                                ImageView(image: "Sileoapp")
                                                    .onTapGesture {
                                                        if !sileo {
                                                            withAnimation {
                                                                sileo = true
                                                            }
                                                        } else if sileo {
                                                            withAnimation {
                                                                sileo = false
                                                            }
                                                        }
                                                    }
                                                Spacer().frame(height: 10)
                                                Text("Sileo")
                                                    .font(.system(size: 12))
                                                Spacer().frame(height: 10)
                                                Image(systemName: sileo ? "checkmark.circle.fill" : "circle")
                                            }
                                            Spacer().frame(width: 50)
                                            VStack {
                                                ImageView(image: "Zebraapp")
                                                    .onTapGesture {
                                                        if !zebra {
                                                            withAnimation {
                                                                zebra = true
                                                            }
                                                        } else if zebra {
                                                            withAnimation {
                                                                zebra = false
                                                            }
                                                        }
                                                    }
                                                Spacer().frame(height: 10)
                                                Text("Zebra")
                                                    .font(.system(size: 12))
                                                Spacer().frame(height: 10)
                                                Image(systemName: zebra ? "checkmark.circle.fill" : "circle")
                                            }
                                            Spacer()
                                        }
                                        Spacer().frame(height: 20)
                                    }
                                    .frame(height: deviceHeight / 4)
                                    if sileo == true {
                                        Button("Select") {
                                            locui = false
                                            bootstrap()
                                        }
                                    } else if zebra == true {
                                        Button("Select") {
                                            locui = false
                                            bootstrap()
                                        }
                                    }
                                }
                            }
                        } header: {
                                Label("Action", systemImage: "hammer")
                            }
                            Section {
                                Text("Location: " + bsm + "fr1d4" + "/.fridastrapped")
                                Picker("Mode", selection: $exec_location_pre) {
                                    ForEach(0..<segments2.count, id: \.self) { index in
                                        Text(segments2[index])
                                            .tag(index)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            } header: {
                                Label("Bootstrap", systemImage: "archivebox")
                            }
                            Section() {
                                Text("Mode")
                                Picker("Mode", selection: $exploit_mode) {
                                    ForEach(0..<segments.count, id: \.self) { index in
                                        Text(segments[index])
                                            .tag(index)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            } header: {
                                Label("Exploitment", systemImage: "greaterthan.square")
                            }
                            Section() {
                                HStack {
                                    Image("lol")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(360)
                                    Spacer()
                                    VStack {
                                        Text("SeanIsTethered")
                                            .font(.system(size: 12))
                                        Text("FridaRootManager")
                                            .font(.system(size: 10))
                                    }
                                    .frame(width: 125)
                                    Spacer().frame(width: 20)
                                }
                                HStack {
                                    Image("elvis")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(360)
                                    Spacer()
                                    VStack {
                                        Text("Elvis")
                                            .font(.system(size: 12))
                                        Text("Bootstrap")
                                            .font(.system(size: 10))
                                    }
                                    .frame(width: 125)
                                    Spacer().frame(width: 20)
                                }
                                HStack {
                                    Image("rh")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(360)
                                    Spacer()
                                    VStack {
                                        Text("RootHide")
                                            .font(.system(size: 12))
                                        Text("Remount + Bootstrap help")
                                            .font(.system(size: 10))
                                    }
                                    .frame(width: 125)
                                    Spacer().frame(width: 20)
                                }
                            } header: {
                                Label("credits", systemImage: "person.3")
                            }
                            Section {
                                HStack {
                                    Image("opa334")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(360)
                                    Spacer()
                                    VStack {
                                        Text("Opa334")
                                            .font(.system(size: 12))
                                        Text("Trollstore's ldid")
                                            .font(.system(size: 10))
                                    }
                                    .frame(width: 125)
                                    Spacer().frame(width: 20)
                                }
                                HStack {
                                    Image("lemin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(360)
                                    Spacer()
                                    VStack {
                                        Text("Lemin Limez")
                                            .font(.system(size: 12))
                                        Text("Buttons in main menu")
                                            .font(.system(size: 10))
                                    }
                                    .frame(width: 125)
                                    Spacer().frame(width: 20)
                                }
                                HStack {
                                    Image("hahalosah")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(360)
                                    Spacer()
                                    VStack {
                                        Text("HAHALOSAH")
                                            .font(.system(size: 12))
                                        Text("posix_spawn help")
                                            .font(.system(size: 10))
                                    }
                                    .frame(width: 125)
                                    Spacer().frame(width: 20)
                                }
                                HStack {
                                    Image("serena")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(360)
                                    Spacer()
                                    VStack {
                                        Text("Serena")
                                            .font(.system(size: 12))
                                        Text("NSTask execution")
                                            .font(.system(size: 10))
                                    }
                                    .frame(width: 125)
                                    Spacer().frame(width: 20)
                                }
                                HStack {
                                    Image("procursus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(360)
                                    Spacer()
                                    VStack {
                                        Text("Procursus")
                                            .font(.system(size: 12))
                                        Text("Binpack for bootstrap")
                                            .font(.system(size: 10))
                                    }
                                    .frame(width: 125)
                                    Spacer().frame(width: 20)
                                }
                            }
                        Section() {
                            HStack {
                                Image("amy")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(360)
                                Spacer()
                                VStack {
                                    Text("Amy While")
                                        .font(.system(size: 12))
                                    Text("Sileo")
                                        .font(.system(size: 10))
                                }
                                .frame(width: 125)
                                Spacer().frame(width: 20)
                            }
                            HStack {
                                Image("zebra")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(360)
                                Spacer()
                                VStack {
                                    Text("Adam Demasi")
                                        .font(.system(size: 12))
                                    Text("Zebra")
                                        .font(.system(size: 10))
                                }
                                .frame(width: 125)
                                Spacer().frame(width: 20)
                            }
                        }
                    }
                    .onAppear {
                        if almdc == false {
                            if exploit_mode == 1 {
                                try? MacDirtyCow.unsandbox()
                                almdc = true
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("FridaRootManager")
                    .opacity(fropacity)
                    .frame(width: deviceWidth)
                }
            }
            .onAppear {
                if fropacity == 0.0 {
                    fropacity = 1.0
                }
            }
    }
    func bootstrap() {
        run_protection = false
        if isstrapped == false {
            if exploit_mode == 2 {
                bsm_correction()
                print("exec")
                if bsm == "/private/var/" {
                    withAnimation {
                        isbootstrapping = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        Console2.shared.log("[*] Prepare for MobileStrap")
                        withAnimation {
                            valmsg = "Prepare for MobileStrap"
                            color1 = Color.blue
                            progress = 0.05
                        }
                        folderName = "fr1d4"
                        createFolder(atPath: "private/var/mobile")
                        Console2.shared.log("[+] Creating MobileStrap")
                        withAnimation {
                            valmsg = "Creating MobileStrap"
                            color1 = Color.blue
                            progress = 0.10
                        }
                        extractZipArchive(zipFilePath: url?.path ?? "", destinationPath: "/private/var/mobile/fr1d4")
                        Console2.shared.log("[*] Permission Fuckery")
                        withAnimation {
                            valmsg = "Permission Fuckery"
                            color1 = Color.blue
                            progress = 0.15
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            cuser = getCurrentUsername()
                            chgrpAtPathMS(bsm)
                            chownAtPathMS(bsm)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                folderName = "fr1d4"
                                createFolder(atPath: bsm)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    Console2.shared.log("[+] Creating FridaStrap")
                                    withAnimation {
                                        valmsg = "Creating FridaStrap"
                                        color1 = Color.blue
                                        progress = 0.20
                                    }
                                    extractZipArchive(zipFilePath: url?.path ?? "", destinationPath: bsm + "fr1d4")
                                    let directoryPath = bsm + "fr1d4"
                                    let fileName = ".fridastrapped"
                                    let fileContent = "I really have a crush on Frida"
                                    
                                    if createFile(atPath: directoryPath, withFileName: fileName, content: fileContent) {
                                        Console2.shared.log("[+] Creating FridaStrap IDENT")
                                        withAnimation {
                                            valmsg = "Creating FridaStrao IDENT"
                                            color1 = Color.blue
                                            progress = 0.25
                                        }
                                    } else {
                                        Console2.shared.log("[-] Failed to create the Identification file. (/var/fr1d4)")
                                        withAnimation {
                                            valmsg = "Failed to create IDENT"
                                            color1 = Color.red
                                            progress = 0.30
                                        }
                                        return
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        cuser = "root"
                                        chownAtPathMS(bsm)
                                        cuser = "wheel"
                                        chgrpAtPathMS(bsm)
                                        cuser = getCurrentUsername()
                                        Console2.shared.log("[*] Remount Preboot")
                                        withAnimation {
                                            valmsg = "Remount Preboot"
                                            color1 = Color.blue
                                            progress = 0.40
                                        }
                                        remountpreboot()
                                    }
                                }
                            }
                        }
                    }
                } else {
                    folderName = "fr1d4"
                    createFolder(atPath: bsm)
                    withAnimation {
                        isbootstrapping = true
                    }
                    Console2.shared.log("[+] Extracting zip")
                    withAnimation {
                        valmsg = "Extracting zip"
                        color1 = Color.blue
                        progress = 0.15
                    }
                    extractZipArchive(zipFilePath: url?.path ?? "", destinationPath: bsm + "fr1d4")
                    Console2.shared.log("[+] Create IDENT")
                    withAnimation {
                        valmsg = "Create IDENT"
                        color1 = Color.blue
                        progress = 0.30
                    }
                    let directoryPath = bsm + "fr1d4"
                    let fileName = ".fridastrapped"
                    let fileContent = "I really have a crush on Frida"
                    
                    if createFile(atPath: directoryPath, withFileName: fileName, content: fileContent) {
                        remountpreboot()
                    } else {
                        msgbox = "Failed to create the file."
                        Console2.shared.log("[-] Error while creating IDENT")
                        withAnimation {
                            valmsg = "Failed to create IDENT"
                            color1 = Color.red
                            progress = 0.15
                        }
                        return
                    }
                }
            }
        } else {
            if exploit_mode == 2 {
                print("exec")
                withAnimation {
                    isbootstrapping = true
                }
                let filePath = bsm + "fr1d4" + "/.fridestrapped"
                
                if deleteFile(atPath: filePath) {
                    msgbox = "File deleted successfully."
                    deleteContentsOfFolder(atPath: bsm + "fr1d4")
                } else {
                    msgbox = "Failed to delete the file."
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if fileExists(atPath: "/var/jb/usr/bin/uicache") {
                        uicacheu(atPath: "/var/jb/Applications")
                    }
                    folderName = "fr1d4"
                    if !folderExists(atPath: "/private/var/mobile/fr1d4") {
                        createFolder(atPath: "/private/var/mobile")
                        withAnimation {
                            isbootstrapping = true
                        }
                    }
                    Console2.shared.log("[+] Extracting zip")
                    extractZipArchive(zipFilePath: url?.path ?? "", destinationPath: bsm + "fr1d4")
                    let directoryPath = bsm + "fr1d4"
                    let fileName = ".fridastrapped"
                    let fileContent = "I really have a crush on Frida"
                    
                    if createFile(atPath: directoryPath, withFileName: fileName, content: fileContent) {
                        Console2.shared.log("[*] IDENT Created successfully")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            Console2.shared.log("[*] permission fuckery")
                            cuser = getCurrentUsername()
                            chownAtPathMS("/private/var")
                            chgrpAtPathMS("/private/var")
                            if folderExists(atPath: "/private/preboot/" + roothash + "/jb") {
                                Console2.shared.log("[*] jb folder detected")
                                chownAtPathMS("/private/preboot/" + roothash + "/jb")
                                chgrpAtPathMS("/private/preboot/" + roothash + "/jb")
                            } else {
                                Console2.shared.log("[*] jb folder sems to not exist")
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                if fileExists(atPath: "/private/var/jb") {
                                    Console2.shared.log("[+] Removing symlink")
                                    try? FileManager.default.removeItem(at: URL(fileURLWithPath: "/private/var/jb"))
                                } else {
                                    Console2.shared.log("[*] symlink sems to not exist")
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    if folderExists(atPath: "/private/var/fr1d4") {
                                        Console2.shared.log("[*] Remove fridastrap")
                                        deleteFolder(atPath: "/private/var/fr1d4")
                                        if folderExists(atPath: "/private/var/fr1d4") {
                                            removeDirectoryAtPathMS("/private/var/fr1d4")
                                        }
                                        Console2.shared.log("[*] Fridastrap removed")
                                    } else {
                                        Console2.shared.log("[*] Fridastrap sems to not exist")
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        if folderExists(atPath: "/private/preboot/" + roothash + "/jb") {
                                            cuser = getCurrentUsername()
                                            chownAtPathMS("/private/preboot/" + roothash)
                                            chgrpAtPathMS("/private/preboot/" + roothash)
                                        } else {
                                            Console2.shared.log("[*] jb folder sems to not exist")
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            Console2.shared.log("[*] Revert permission fuckery")
                                            cuser = "root"
                                            chownAtPathMS("/private/var")
                                            chownAtPathMS("/private/preboot/" + roothash)
                                            cuser = "wheel"
                                            chgrpAtPathMS("/private/var")
                                            chgrpAtPathMS("/private/preboot/" + roothash)
                                            if folderExists(atPath: "/private/preboot/jb") {
                                                Console2.shared.log("[*] jb folder detected")
                                                cuser = "root"
                                                chownAtPathMS("/private/preboot/" + roothash + "/jb")
                                                cuser = "wheel"
                                                chgrpAtPathMS("/private/preboot/" + roothash + "/jb")
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                removeJBFolder()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        Console2.shared.log("[*] Failed to unjailbreak")
                    }
                }
                
            }
        }
        if fileExists(atPath: bsm + "fr1d4" + "/.fridastrapped") {
            button1text = "Unbootstrap Device"
            colorstat1 = Color.orange
            isstrapped = true
        } else {
            button1text = "Bootstrap Device"
            colorstat1 = Color.blue
            isstrapped = false
        }
    }
    func removeJBFolder() {
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, 0)
        posix_spawnattr_set_persona_gid_np(&attr, 0)
        
        let commandPath = "/private/var/mobile/fr1d4/bin/rm"
        let pathCString = strdup("/private/preboot/" + roothash + "/jb")
        
        var pid: pid_t = 0
        let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-rf"), pathCString]
        let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
        
        for arg in arguments {
            free(arg)
        }
        
        if status == 0 {
            if folderExists(atPath: "/private/var/mobile/fr1d4") {
                Console2.shared.log("[+] Removing mobilestrap")
                try? FileManager.default.removeItem(at: URL(fileURLWithPath: "/private/var/mobile/fr1d4"))
                cuser = getCurrentUsername()
                hide_button = true
            }
        } else {
            removeJBFolder()
        }
    }
    func removeDirectoryAtPathMS(_ path: String) {
        if debug_mode {
            Console2.shared.log("[func] triggered: removeDirectoryAtPathMS()")
        }
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, uid_t(0))
        posix_spawnattr_set_persona_gid_np(&attr, gid_t(0))
        
        let commandPath = "/private/var/mobile/fr1d4/bin/rm"
        let pathCString = strdup(path)
        
        var pid: pid_t = 0
        let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-rf"), strdup(pathCString)]
        if debug_mode {
            Console2.shared.log("[exec] " + "rm " + "-rf " + path)
        }
        let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
        
        for arg in arguments {
            free(arg)
        }
        
        if status == 0 {
            if debug_mode {
                Console2.shared.log("[+] Successfully removed directory at Path " + path)
            }
            return
        } else {
            if debug_mode {
                Console2.shared.log("[-] Error removing directory at: " + path)
            } else {
                Console2.shared.log("[-] Error removing directory")
            }
            Console2.shared.log("[*] Remount Preboot")
            return
        }
    }
    func isPathAccessible(atPath path: String) -> Bool {
        let fileManager = FileManager.default
        
        // Check if the path exists
        if fileManager.fileExists(atPath: path) {
            // Check if the path is reachable
            return fileManager.isReadableFile(atPath: path) && fileManager.isWritableFile(atPath: path)
        } else {
            return false
        }
    }
    func getFolderNameIfSingleFolder(directoryPath: String) -> String? {
        if debug_mode {
            Console2.shared.log("[func] triggered: getFolderNameIfSingleFolder()")
        }
        let fileManager = FileManager.default
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: directoryPath)
            
            // Filter out directories from the list of contents
            let subdirectories = contents.filter { item in
                var isDirectory: ObjCBool = false
                let itemPath = (directoryPath as NSString).appendingPathComponent(item)
                return fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory) && isDirectory.boolValue
            }
            
            // Check if there's exactly one subdirectory
            if subdirectories.count == 1 {
                return subdirectories[0]
            }
        } catch {
            if debug_mode {
                Console2.shared.log("[debug] Error finding hash folder : \(error)")
            }
        }
        
        return nil
    }
    func runExecutable(pathAndArgs: String) {
        if debug_mode {
            Console2.shared.log("[func] triggered: runExecutable()")
        }
        var components = pathAndArgs.components(separatedBy: " ")
        guard let executable = components.first, !executable.isEmpty else {
            return
        }

        // Make it just args
        components.removeFirst()
        let task = NSTask()
        
        // Set the execution path

        task.executableURL = URL(fileURLWithPath: executable)
        task.arguments = components

        let pipe = Pipe()
        pipe.fileHandleForReading.readabilityHandler = { outPipe in
            guard let output = String(data: outPipe.availableData, encoding: .utf8),
            !output.isEmpty else {
                return
            }

            DispatchQueue.main.async {
                Console2.shared.log(output)
            }
        }

        task.standardError = pipe
        task.standardOutput = pipe
        do {
            // Assuming you have an "outputText" property for storing output
            task.launch()
            task.waitUntilExit()
        } catch {
            return
        }
    }
    func trolludid() {
        if debug_mode {
            Console2.shared.log("[func] triggered: trolludid()")
        }
        TrollStore_UUID = getAppUUID(for: "TrollStore.app", in: "/private/var/containers/Bundle/Application") ?? "not found"
        ldid = "/private/var/containers/Bundle/Application/" + TrollStore_UUID + "/TrollStore.app/ldid"
        if debug_mode {
            Console2.shared.log("[var] TrollStore_UUID: " +  TrollStore_UUID)
            Console2.shared.log("[var] ldid: " + ldid)
        }
    }
    func raw_remountpreboot() {
        if debug_mode {
            Console2.shared.log("[func] triggered: rraw_prebootremount()")
        }
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, uid_t(0))
        posix_spawnattr_set_persona_gid_np(&attr, gid_t(0))
        
        let commandPath = "/sbin/mount"
        
        var pid: pid_t = 0
        let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-u"), strdup("-w"), strdup("/private/preboot")]
        if debug_mode {
            Console2.shared.log("[exec] " + "mount " + "-u " + "-w " + "/private/preboot")
        }
        let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
        
        for arg in arguments {
            free(arg)
        }
        if status == 0 {
            if debug_mode {
                Console2.shared.log("[debug] successfully remounted preboot")
            }
            return
        } else {
            if debug_mode {
                Console2.shared.log("[debug] failed to remount preboot")
            }
            raw_remountpreboot()
        }
    }
        func remountpreboot() {
            if run_protection == true {
                return
            }
            var attr: posix_spawnattr_t?
            posix_spawnattr_init(&attr)
            posix_spawnattr_set_persona_np(&attr, 99, 1)
            posix_spawnattr_set_persona_uid_np(&attr, uid_t(0))
            posix_spawnattr_set_persona_gid_np(&attr, gid_t(0))
            
            let commandPath = "/sbin/mount"
            
            var pid: pid_t = 0
            let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-u"), strdup("-w"), strdup("/private/preboot")]
            if debug_mode {
                Console2.shared.log2("[exec] " + "mount " + "-u " + "-w " + "/private/preboot")
            }
            let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
            
            for arg in arguments {
                free(arg)
            }
            if status == 0 {
                        if debug_mode {
                            Console2.shared.log2("[debug] remounted preboot successfully")
                        }
                        run_protection = true
                        if !folderExists(atPath: "/private/preboot/" + roothash + "/jb") {
                            Console2.shared.log2("[*] Prepare Bootstrap")
                            var attr: posix_spawnattr_t?
                            posix_spawnattr_init(&attr)
                            posix_spawnattr_set_persona_np(&attr, 99, 1)
                            posix_spawnattr_set_persona_uid_np(&attr, uid_t(0))
                            posix_spawnattr_set_persona_gid_np(&attr, gid_t(0))
                            
                            let commandPath = bsm + "fr1d4/bin/mkdir"
                            let pathCString = strdup("/private/preboot/" + roothash + "/jb")
                            
                            var pid: pid_t = 0
                            let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-p"), pathCString]
                            let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
                            
                            for arg in arguments {
                                free(arg)
                            }
                            if status != 0 {
                                if debug_mode {
                                    Console2.shared.log("[debug] mkdir failed")
                                    Console2.shared.log("[debug] switching to secondary methode")
                                }
                                cuser = getCurrentUsername()
                                chownAtPathMS("/private/preboot/" + roothash)
                                chgrpAtPathMS("/private/preboot/" + roothash)
                                folderName = "jb"
                                createFolder(atPath: "/private/preboot/" + roothash)
                                cuser = "root"
                                chownAtPathMS("/private/preboot/" + roothash)
                                cuser = "wheel"
                                chgrpAtPathMS("/private/preboot/" + roothash)
                                cuser = getCurrentUsername()
                                if debug_mode {
                                    Console2.shared.log("[debug] secendary mode done")
                                    Console2.shared.log("[debug] patching status")
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    Console2.shared.log("[*] Permission Fuckery")
                                    cuser = "mobile"
                                    if debug_mode {
                                        Console2.shared.log("[var] cuser: " + cuser)
                                    }
                                    chownAtPathMS("/private/preboot/" +  roothash + "/jb")
                                    chgrpAtPathMS("/private/preboot/" +  roothash + "/jb")
                                    chownAtPathMS("/private/var")
                                    chownAtPathMS("/private/var")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        if debug_mode {
                                            Console2.shared.log("[+] extract zip")
                                        }
                                        extractZipArchive(zipFilePath: pbbs?.path ?? "", destinationPath: "/private/preboot/" + roothash + "/jb")
                                        createSymbolicLink(from: "/private/preboot/" + roothash + "/jb/procursus", to: "/private/var/jb")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            tarExtract("/private/preboot/" + roothash + "/jb", tarpath: pbs?.path ?? "")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                                Console2.shared.log("[+] Updating Applications Folder")
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    if sileo {
                                                        extractZipArchive(zipFilePath: sl?.path ?? "", destinationPath: "/private/preboot/" + roothash + "/jb")
                                                    }
                                                    if zebra {
                                                        extractZipArchive(zipFilePath: zl?.path ?? "", destinationPath: "/private/preboot/" + roothash + "/jb")
                                                    }
                                                    Console2.shared.log("[*] Applications Folder updated")
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                        Console2.shared.log("[+] Updating uicache")
                                                        if fileExists(atPath: "/var/jb/usr/bin/uicache") {
                                                            uicachep(atPath: "/var/jb/Applications")
                                                        }
                                                        Console2.shared.log("[*] uicache updated")
                                                        Console2.shared.log("[+] Done :)")
                                                        if !folderExists(atPath: "/private/preboot/" + roothash + "/jb/etc") {
                                                            retrybootstrap()
                                                        } else {
                                                            hide_button = true
                                                        }
                                                        return
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }
                            
                            if status == 0 {
                                Console2.shared.log("[*] Permission Fuckery")
                                cuser = "mobile"
                                if debug_mode {
                                    Console2.shared.log("[var] cuser: " + cuser)
                                }
                                chownAtPathMS("/private/preboot/" +  roothash + "/jb")
                                chgrpAtPathMS("/private/preboot/" +  roothash + "/jb")
                                chownAtPathMS("/private/var")
                                chownAtPathMS("/private/var")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    if debug_mode {
                                        Console2.shared.log("[+] extract zip")
                                    }
                                    extractZipArchive(zipFilePath: pbbs?.path ?? "", destinationPath: "/private/preboot/" + roothash + "/jb")
                                    createSymbolicLink(from: "/private/preboot/" + roothash + "/jb/procursus", to: "/private/var/jb")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        tarExtract("/private/preboot/" + roothash + "/jb", tarpath: pbs?.path ?? "")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                            Console2.shared.log("[*] Updating uicache")
                                            if fileExists(atPath: "/var/jb/usr/bin/uicache") {
                                                uicachep(atPath: "/var/jb/Applications")
                                            }
                                            Console2.shared.log("[+] uicache updated")
                                            Console2.shared.log("[+] Done")
                                            if !folderExists(atPath: "/private/preboot/" + roothash + "/jb/etc") {
                                                retrybootstrap()
                                            } else {
                                                hide_button = true
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            Console2.shared.log2("[-] Jailbreak retry")
                            run_protection = false
                            remountpreboot()
                        }
            } else {
                if !run_protection {
                    remountpreboot()
                }
        }
    }
    func retrybootstrap() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if !fileExists(atPath: "/private/var/jb") {
                    createSymbolicLink(from: "/private/preboot/" + roothash + "/jb/procursus", to: "/private/var/jb")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    tarExtract("/private/preboot/" + roothash + "/jb", tarpath: pbs?.path ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        Console2.shared.log("[+] Updating Applications Folder")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if sileo {
                                extractZipArchive(zipFilePath: sl?.path ?? "", destinationPath: "/private/preboot/" + roothash + "/jb")
                            }
                            if zebra {
                                extractZipArchive(zipFilePath: zl?.path ?? "", destinationPath: "/private/preboot/" + roothash + "/jb")
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                Console2.shared.log("[*] Applications Folder updated")
                                Console2.shared.log("[*] Updating uicache")
                                if fileExists(atPath: "/var/jb/usr/bin/uicache") {
                                    uicachep(atPath: "/var/jb/Applications")
                                }
                                Console2.shared.log("[+] uicache updated")
                                Console2.shared.log("[+] Done")
                                if !folderExists(atPath: "/var/jb/etc") {
                                    retrybootstrap()
                                } else {
                                    hide_button = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func tarExtract(_ destinationpath: String, tarpath: String) {
        Console2.shared.log("[*] tar called")
        if debug_mode {
            Console2.shared.log("[+] Extracting tar " + tarpath + " to: " + destinationpath)
        } else {
            Console2.shared.log("[+] Extracting tar")
        }
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, uid_t(0))
        posix_spawnattr_set_persona_gid_np(&attr, gid_t(0))
        
        let commandPath = bsm + "fr1d4/bin/tar"
        let dtp = strdup(tarpath)
        let pathCString = strdup(destinationpath)
        
        var pid: pid_t = 0
        let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-xpkf"), dtp, strdup("-C"), pathCString]
        if debug_mode {
            Console2.shared.log("[exec] tar -xpkf " + tarpath + " -C " + destinationpath)
        }
        let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
        
        for arg in arguments {
            free(arg)
        }
    }
    func appPath() -> String? {
        if debug_mode {
            Console2.shared.log("[func] triggered: appPath()")
        }
        if let appURL = Bundle.main.executableURL {
            if debug_mode {
                Console2.shared.log("[debug] fetched: " + appURL.path)
            }
            return appURL.path
        }
        if debug_mode {
            Console2.shared.log("[debug] error: nothing found")
        }
        return nil
    }
    func btn1chk() {
        if fileExists(atPath: bsm + "fr1d4" + "/.fridastrapped") {
            Console2.shared.clean()
            button1text = "Unbootstrap Device"
            colorstat1 = Color.orange
            isstrapped = true
            withAnimation {
                isbootstrapping = false
            }
        } else {
            Console2.shared.clean()
            button1text = "Bootstrap Device"
            colorstat1 = Color.blue
            isstrapped = false
            withAnimation {
                isbootstrapping = false
            }
        }
    }
    func getCurrentUsername() -> String {
        if debug_mode {
            Console2.shared.log("[func] triggered: getCurrentUsername()")
        }
        if debug_mode {
            Console2.shared.log("[debug] fetched: " + NSUserName())
        }
        return NSUserName()
    }
    func bsm_correction() {
        if debug_mode {
            Console2.shared.log("[func] triggered: bsm_correction()")
        }
        if exec_location_pre == 0 {
            bsm = "/private/var/"
            if debug_mode {
                Console2.shared.log("[var] bsm: " + bsm)
            }
        } else if exec_location_pre == 1 {
            bsm = "/private/var/mobile/"
            if debug_mode {
                Console2.shared.log("[var] bsm: " + bsm)
            }
        }
    }
    func createSymbolicLink(from sourcePath: String, to destinationPath: String) -> Bool {
        if debug_mode {
            Console2.shared.log("[func] triggered: createSymbolicLink()")
        }
        let fileManager = FileManager.default
        
        do {
            try fileManager.createSymbolicLink(atPath: destinationPath, withDestinationPath: sourcePath)
            return true
        } catch {
            if debug_mode {
                Console2.shared.log("[debug] Error creating symbolic Link from: " + sourcePath + " to: " + destinationPath)
            } else {
                Console2.shared.log("[-] Error creating symbolic link")
            }
            return false
        }
    }
    func chownAtPathMS(_ path: String) {
        if debug_mode {
            Console2.shared.log("[func] triggered: chownAtPathMS()")
        }
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, 0)
        posix_spawnattr_set_persona_gid_np(&attr, 0)
        
        let commandPath = "/private/var/mobile/fr1d4/bin/chown"
        
        // Convert Swift strings to C strings
        let cCommandPath = strdup(commandPath)
        let cUsername = strdup(cuser)
        let cPath = strdup(path)
        
        // Use posix_spawn to run the chown command with the specified persona
        var pid: pid_t = 0
        if debug_mode {
            Console2.shared.log("[exec] chown" + " " + cuser + " " + path)
        }
        let status = posix_spawn(&pid, cCommandPath, nil, &attr, [cCommandPath, cUsername, cPath, nil], nil)
        
        // Free the allocated C strings
        free(cCommandPath)
        free(cUsername)
        free(cPath)
        
        if status == 0 {
            if debug_mode {
                Console2.shared.log("[debug] Successfully changed Ownership of path: " + path + " to owner: " + cuser)
            }
        } else {
            if debug_mode {
                Console2.shared.log("[debug] Error changing ownership for \(path): \(strerror(status)!)")
            }
        }
    }
    func chgrpAtPathMS(_ path: String) {
        if debug_mode {
            Console2.shared.log("[func] triggered: chgrpAtPathMS()")
        }
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, 0)
        posix_spawnattr_set_persona_gid_np(&attr, 0)
        
        let commandPath = "/private/var/mobile/fr1d4/bin/chgrp"
        
        // Convert Swift strings to C strings
        let cCommandPath = strdup(commandPath)
        let cUsername = strdup(cuser)
        let cPath = strdup(path)
        
        // Use posix_spawn to run the chown command with the specified persona
        var pid: pid_t = 0
        if debug_mode {
            Console2.shared.log("[exec] chgrp" + " " + cuser + " " + path)
        }
        let status = posix_spawn(&pid, cCommandPath, nil, &attr, [cCommandPath, cUsername, cPath, nil], nil)
        
        // Free the allocated C strings
        free(cCommandPath)
        free(cUsername)
        free(cPath)
        
        if status == 0 {
            if debug_mode {
                Console2.shared.log("[debug] Successfully changed Ownership of path: " + path + " to owner: " + cuser)
            }
        } else {
            if debug_mode {
                Console2.shared.log("[debug] Error changing ownership for \(path): \(strerror(status)!)")
            }
        }
    }
    func uicachep(atPath directoryPath: String) {
        if debug_mode {
            Console2.shared.log("[func] triggered: uicachep()")
        }
        let fileManager = FileManager.default
        
        do {
            let folderURLs = try fileManager.contentsOfDirectory(atPath: directoryPath)
            
            for folderURL in folderURLs {
                let uicacheCommand = "/var/jb/usr/bin/uicache -p " + "/var/jb/Applications/" + folderURL
                if debug_mode {
                    Console2.shared.log("[exec] " + uicacheCommand)
                }
                Console2.shared.log("[+]" + " uicached: " + folderURL)
                runExecutable(pathAndArgs: uicacheCommand)
            }
        } catch {
            if debug_mode {
                Console2.shared.log("Error reading directory: \(error.localizedDescription)")
            }
        }
    }
    func uicacheu(atPath directoryPath: String) {
        if debug_mode {
            Console2.shared.log("[func] triggered: uicachep()")
        }
        let fileManager = FileManager.default
        
        do {
            let folderURLs = try fileManager.contentsOfDirectory(atPath: directoryPath)
            
            for folderURL in folderURLs {
                let uicacheCommand = "/var/jb/usr/bin/uicache -u " + "/var/jb/Applications/" + folderURL
                if debug_mode {
                    Console2.shared.log("[exec] " + uicacheCommand)
                }
                Console2.shared.log("[+]" + " unuicached: " + folderURL)
                runExecutable(pathAndArgs: uicacheCommand)
            }
        } catch {
            if debug_mode {
                Console2.shared.log("Error reading directory: \(error.localizedDescription)")
            }
        }
    }
    func chownRAtPathMS(_ path: String) {
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, 0)
        posix_spawnattr_set_persona_gid_np(&attr, 0)
        
        let commandPath = "/private/var/mobile/fr1d4/bin/chown -R"
        
        // Convert Swift strings to C strings
        let cCommandPath = strdup(commandPath)
        let cUsername = strdup(cuser)
        let cPath = strdup(path)
        
        // Use posix_spawn to run the chown command with the specified persona
        var pid: pid_t = 0
        let status = posix_spawn(&pid, cCommandPath, nil, &attr, [cCommandPath, cUsername, cPath, nil], nil)
        
        // Free the allocated C strings
        free(cCommandPath)
        free(cUsername)
        free(cPath)
        
        if status == 0 {
            //Console2.shared.log("Ownership changed successfully for \(path) to \(cuser)")
        } else {
            Console2.shared.log("Error changing ownership for \(path): \(strerror(status)!)")
        }
    }
    func chgrpRAtPathMS(_ path: String) {
        
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, 0)
        posix_spawnattr_set_persona_gid_np(&attr, 0)
        
        let commandPath = "/private/var/mobile/fr1d4/bin/chgrp -R"
        
        // Convert Swift strings to C strings
        let cCommandPath = strdup(commandPath)
        let cUsername = strdup(cuser)
        let cPath = strdup(path)
        
        // Use posix_spawn to run the chown command with the specified persona
        var pid: pid_t = 0
        let status = posix_spawn(&pid, cCommandPath, nil, &attr, [cCommandPath, cUsername, cPath, nil], nil)
        
        // Free the allocated C strings
        free(cCommandPath)
        free(cUsername)
        free(cPath)
        
        if status == 0 {
            //Console2.shared.log("Ownership changed successfully for \(path) to \(cuser)")
        } else {
            Console2.shared.log("Error changing ownership for \(path): \(strerror(status)!)")
        }
    }
    func createFolder(atPath path: String) {
        if debug_mode {
            Console2.shared.log("[func] triggered: createFolder()")
        }
        if !folderName.isEmpty {
            let folderURL = URL(fileURLWithPath: path).appendingPathComponent(folderName)
            
            do {
                if debug_mode {
                    Console2.shared.log("[debug] FileManager createDirectory at Path: " + folderURL.path)
                }
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                folderName = ""
            } catch {
                if debug_mode {
                    Console2.shared.log("[debug] Error creating folder: \(error.localizedDescription)")
                }
            }
        }
    }
    func createcheck(atPath path: String) -> Bool {
        if debug_mode {
            Console2.shared.log("[func] triggered: createFolder()")
        }
        if !folderName.isEmpty {
            let folderURL = URL(fileURLWithPath: path).appendingPathComponent(folderName)
            
            do {
                if debug_mode {
                    Console2.shared.log("[debug] FileManager createDirectory at Path: " + folderURL.path)
                }
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                folderName = ""
            } catch {
                if debug_mode {
                    Console2.shared.log("[debug] Error creating folder: \(error.localizedDescription)")
                    return false
                }
            }
            return true
        }
        return false
    }
    func fileExists(atPath path: String) -> Bool {
        if debug_mode {
            Console2.shared.log("[func] triggered: fileExists()")
        }
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }
    func folderExists(atPath path: String) -> Bool {
        if debug_mode {
            Console2.shared.log("[func] triggered: folderExists()")
        }
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        // Check if the item at the specified path exists and is a directory
        return fileManager.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
    func getAppUUID(for appName: String, in folderPath: String) -> String? {
        if debug_mode {
            Console2.shared.log("[func] triggered: getAppUUID()")
        }
        do {
            let folderURL = URL(fileURLWithPath: folderPath)
            let subfolderURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [])
            
            for subfolderURL in subfolderURLs {
                let subfolderName = subfolderURL.lastPathComponent
                let appFolderURL = subfolderURL.appendingPathComponent("\(appName)")
                
                if FileManager.default.fileExists(atPath: appFolderURL.path),
                   let uuid = UUID(uuidString: subfolderName) {
                    return uuid.uuidString
                }
            }
        } catch {
            print("Error: \(error)")
        }
        
        return nil
    }
    func createFile(atPath path: String, withFileName fileName: String, content: String) -> Bool {
        if debug_mode {
            Console2.shared.log("[func] triggered: createFile()")
        }
        let fileURL = URL(fileURLWithPath: path).appendingPathComponent(fileName)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return true // File creation was successful.
        } catch {
            print("Error creating file: \(error.localizedDescription)")
            return false // File creation failed.
        }
    }
    func deleteFile(atPath filePath: String) -> Bool {
        if debug_mode {
            Console2.shared.log("[func] triggered: deleteFile()")
        }
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: filePath)
            return true // File deletion was successful.
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
            return false // File deletion failed.
        }
    }
    func extractZipArchive(zipFilePath: String, destinationPath: String) {
        if debug_mode {
            Console2.shared.log("[func] triggered: extractZipArchive()")
        }
        SSZipArchive.unzipFile(atPath: zipFilePath, toDestination: destinationPath)
        if debug_mode {
            Console2.shared.log("[debug] zip in " + zipFilePath + " extracted to: " + destinationPath)
        }
    }
    func deleteFolder(atPath folderPath: String) -> Bool {
        if debug_mode {
            Console2.shared.log("[func] triggered: deleteFolder()")
        }
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: folderPath)
            return true // Folder deletion was successful.
        } catch {
            return false // Folder deletion failed.
        }
    }
    func deleteContentsOfFolder(atPath folderPath: String) -> Bool {
        if debug_mode {
            Console2.shared.log("[func] triggered: deleteContentsOfFolder()")
        }
        let fileManager = FileManager.default
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: folderPath)
            for item in contents {
                let itemPath = (folderPath as NSString).appendingPathComponent(item)
                try fileManager.removeItem(atPath: itemPath)
            }
            return true // Deletion of contents was successful.
        } catch {
            Console2.shared.log("Error deleting contents of folder: \(error.localizedDescription)")
            return false // Deletion of contents failed.
        }
    }
    func resignAllFilesInDirectoryAtPath(_ directoryPath: String) {
        let fileManager = FileManager.default
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: directoryPath)
            
            for item in contents {
                let fullPath = (directoryPath as NSString).appendingPathComponent(item)
                
                var isDirectory: ObjCBool = false
                if fileManager.fileExists(atPath: fullPath, isDirectory: &isDirectory) {
                    if isDirectory.boolValue {
                        // It's a directory, recurse into it
                        resignAllFilesInDirectoryAtPath(fullPath)
                    } else if isExecutableFile(filePath: fullPath) {
                        // It's an executable file, sign it
                        ldidFileAtPath(fullPath)
                    }
                }
            }
        } catch {
            Console2.shared.log("Error reading directory: \(error)")
        }
    }
    func isExecutableFile(filePath: String) -> Bool {
        if debug_mode {
            Console2.shared.log("[func] triggered: isExecutableFile()")
        }
        var isExecutable = false
        
        if FileManager.default.isExecutableFile(atPath: filePath) {
            isExecutable = true
        }
        return isExecutable
    }
    func ldidFileAtPath(_ path: String) {
        
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, 0)
        posix_spawnattr_set_persona_gid_np(&attr, 0)
        
        let commandPath = ldid // Update the path to ldid as needed
        let pathCString = strdup(path)
        
        var pid: pid_t = 0
        let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-K" + "/private/var/containers/Bundle/Application/" + TrollStore_UUID + "/TrollStore.app/cert.p12"), strdup("-s"), pathCString, nil]
        
        let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
        for arg in arguments {
            free(arg)
        }
        
        if status != 0 {
            //Console2.shared.log("Signing with ldid... \(path): \(strerror(status)!)")
            return
        }
    }
}
class Console2: ObservableObject {
    
    static let shared = Console2()
    
    @Published var lines = [String]()
    
    init() {
        log("[*] FridaRootManager ClosedBeta 4")
        log("[*] Semi-Jailbreak for arm64")
        log("")
    }
    
    public func log(_ str: String) {
        withAnimation {
            self.lines.append(str)
        }
    }
    public func log2(_ str: String) {
        self.lines.append(str)
    }
    public func clean() {
        self.lines = [""]
    }
}
struct ImageView: View {
    let image: String
    var body: some View {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60) // Adjust the size as needed
                .cornerRadius(10)
    }
}

