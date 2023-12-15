import SwiftUI
import MacDirtyCow
import Exploit
import Foundation
import Darwin.POSIX.spawn
import AVFoundation

struct File_Manager: View {
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    var fd: String
    @State var ldid = ""
    @State var ldidthispath = ""
    @State var ts_uid = ""
    @State var folderName = ""
    @State var files: [URL] = []
    @State var folders: [URL] = []
    @State var directoryPath = "/"
    @State var subdirectories: [URL] = []
    @State var error_msg = ""
    @State var showAlert = false
    @State var filePath = ""
    @State var fileViewer = false
    @State var plistViewer = false
    @State var textViewer = false
    @State var foldercreationview = false
    @State var owner_dir = ""
    @State var group_dir = ""
    @Binding var cuser: String
    @State var isShowingTextInputAlert = false
    @State var textInput = ""
    @Binding var exploit_mode: Int
    @Binding var fropacity: Double
    @Binding var image1: String
    @Binding var bsm: String
    @State private var dfub: Bool = false
    var audioPlayer: AVAudioPlayer?
    var body: some View {
        NavigationView {
            ZStack {
                Image(image1)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 10)
                    .onAppear {
                        directoryPath = fd
                        loadFiles()
                    }
                List {
                    Section() {
                        ForEach(folders, id: \.self) { file in
                                let fileURL = URL(fileURLWithPath: filePath)
                                let fileExtension = fileURL.pathExtension
                                let ownershipStatus = doIHaveOwnership(file)
                                let textColor = doIHaveOwnership(file)
                                let image = geticon(file)
                                NavigationLink(destination: File_Manager_sub(fd: file.path, cuser: $cuser, exploit_mode: $exploit_mode, fropacity: $fropacity, image1: $image1, bsm: $bsm)) {
                                    HStack {
                                        Image(systemName: image)
                                            .foregroundColor(textColor)
                                        Text(file.lastPathComponent)
                                            .foregroundColor(textColor)
                                            .contextMenu {
                                                Button("Rename") {
                                                    renameFileOrDirectory(oldPath: file.path, newPath: directoryPath + "/" + folderName)
                                                    files = loadSubdirectories(atPath: directoryPath)
                                                    loadFiles()
                                                }
                                                if exploit_mode == 2 {
                                                    Button("Steal File") {
                                                        
                                                    }
                                                }
                                                
                                            }
                                        Spacer()
                                        Text(getFilePermissionsForUser(filePath: file.path, userName: cuser) ?? "")
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .alert(isPresented: $isShowingTextInputAlert) {
                                    Alert(
                                        title: Text("Enter Text"),
                                        message: Text("Please enter some text:"),
                                        primaryButton: .default(Text("Submit")) {
                                            // Handle the submitted text here
                                            print("You entered: \(textInput)")
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                                .onDelete(perform: deleteFiles)
                        ForEach(files, id: \.self) { file in
                                let fileURL = URL(fileURLWithPath: filePath)
                                let fileExtension = fileURL.pathExtension
                                let ownershipStatus = doIHaveOwnership(file)
                                let textColor = doIHaveOwnership(file)
                                let image = geticon(file)
                                    HStack {
                                        Image(systemName: image)
                                            .foregroundColor(textColor)
                                        Text(file.lastPathComponent)
                                            .foregroundColor(textColor)
                                            .contextMenu {
                                                Button("Rename") {
                                                    renameFileOrDirectory(oldPath: file.path, newPath: directoryPath + "/" + folderName)
                                                    files = loadSubdirectories(atPath: directoryPath)
                                                    loadFiles()
                                                }
                                                if exploit_mode == 2 {
                                                    Button("Steal File") {
                                                        
                                                    }
                                                }
                                                
                                            }
                                        Spacer()
                                        Text(getFilePermissionsForUser(filePath: file.path, userName: cuser) ?? "")
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                                .alert(isPresented: $isShowingTextInputAlert) {
                                    Alert(
                                        title: Text("Enter Text"),
                                        message: Text("Please enter some text:"),
                                        primaryButton: .default(Text("Submit")) {
                                            // Handle the submitted text here
                                            print("You entered: \(textInput)")
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                .onTapGesture {
                                    if isSymbolicLink(atPath: file.path) {
                                        let springdir = resolveSymlink(atPath: file.path)
                                        directoryPath = springdir ?? "/"
                                        loadFiles()
                                        owner_dir = getOwnerName(forDirectoryAtPath: directoryPath) ?? ""
                                        group_dir = getGroupName(forFileAtPath: directoryPath) ?? ""
                                        //   } //else if isDirectory(file) {
                                        // directoryPath = file.path
                                        //  loadFiles()
                                        //  owner_dir = getOwnerName(forDirectoryAtPath: directoryPath) ?? ""
                                        //  group_dir = getGroupName(forFileAtPath: directoryPath) ?? ""
                                    } else {
                                        filePath = file.path
                                        let fileExtension = file.pathExtension.lowercased()
                                        
                                        if fileExtension == "txt" {
                                            foldercreationview = false
                                            textViewer = true
                                            plistViewer = false
                                        } else if fileExtension == "plist" {
                                            foldercreationview = false
                                            textViewer = false
                                            plistViewer = true
                                        } else if fileExtension == "mp3" {
                                            AudioPlayerManager.shared.stopAudio()
                                            AudioPlayerManager.shared.playAudio(filePath: file.path)
                                            print(file.path)
                                        } else {
                                            foldercreationview = false
                                            textViewer = true
                                            plistViewer = false
                                        }
                                        
                                        fileViewer = true
                                    }
                                }
                            }
                                .onDelete(perform: deleteFiles)
                    }
                    HStack {
                        Spacer()
                        VStack {
                            Text("current path: " + directoryPath)
                            Text("uid: " + owner_dir + " / gid: " + group_dir)
                        }
                        Spacer()
                    }
                }
                .onAppear {
                    if dfub == false {
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        dfub = true
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle((directoryPath as NSString).lastPathComponent)
                .opacity(fropacity)
                .frame(width: deviceWidth)
                }
                .onAppear {
                    cuser = getCurrentUsername()
                }
                .sheet(isPresented: $fileViewer) {
                    if plistViewer {
                        PlistViewer(plistPath: filePath, plistData: ["": 1])
                            .onDisappear {
                                foldercreationview = false
                                textViewer = false
                                plistViewer = false
                            }
                    } else if textViewer {
                        TextViewer(filePath: filePath)
                            .onDisappear {
                                foldercreationview = false
                                textViewer = false
                                plistViewer = false
                            }
                    } else if foldercreationview {
                        foldercreation(directoryPath: $directoryPath, exploit_mode: $exploit_mode)
                            .onDisappear {
                                foldercreationview = false
                                textViewer = false
                                plistViewer = false
                                files = loadSubdirectories(atPath: directoryPath)
                                loadFiles()
                            }
                    }
                }
                .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Reload Page") {
                            files = loadSubdirectories(atPath: directoryPath)
                            loadFiles()
                        }
                        Button("Create") {
                            foldercreationview = true
                            textViewer = false
                            plistViewer = false
                            fileViewer = true
                        }
                        Menu("Go to") {
                            Button("Frida App Root") {
                                getlocation()
                                files = loadSubdirectories(atPath: directoryPath)
                                loadFiles()
                                owner_dir = getOwnerName(forDirectoryAtPath: directoryPath) ?? ""
                                group_dir = getGroupName(forFileAtPath: directoryPath) ?? ""
                            }
                            Button("/") {
                                directoryPath = "/"
                                files = loadSubdirectories(atPath: directoryPath)
                                loadFiles()
                            }
                            Button("/var") {
                                directoryPath = "/var"
                                files = loadSubdirectories(atPath: directoryPath)
                                loadFiles()
                            }
                            Button("/var/mobile") {
                                directoryPath = "/var/mobile"
                                files = loadSubdirectories(atPath: directoryPath)
                                loadFiles()
                            }
                            Button("/var/root") {
                                directoryPath = "/var/root"
                                files = loadSubdirectories(atPath: directoryPath)
                                loadFiles()
                            }
                        }
                        Menu("Tools") {
                            Button("Stop Audio") {
                                File_Manager.AudioPlayerManager.shared.stopAudio()
                            }
                        }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                    .onAppear {
                        files = loadSubdirectories(atPath: directoryPath)
                        loadFiles()
                        owner_dir = getOwnerName(forDirectoryAtPath: directoryPath) ?? ""
                        group_dir = getGroupName(forFileAtPath: directoryPath) ?? ""
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        fileViewer = false
                    }
                }
            }
            .onAppear {
                loadFiles()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(error_msg),
                    primaryButton: .default(Text("OK")) {
                        // Handle the action when OK is tapped
                        showAlert = false
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    class AudioPlayerManager {
        static let shared = AudioPlayerManager()
        
        private var audioPlayer: AVAudioPlayer?
        
        private init() {} // This prevents others from initializing their own instances
        
        // Function to play audio from a file path
        func playAudio(filePath: String) {
            guard let url = URL(string: filePath) else {
                print("Invalid file path")
                return
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
        
        // Function to stop the currently playing audio
        func stopAudio() {
            if let player = audioPlayer, player.isPlaying {
                player.stop()
            }
        }
    }
    func getFilePermissionsForUser(filePath: String, userName: String) -> String? {
        let fileManager = FileManager.default
        
        // Get file attributes
        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: filePath)
            
            // Check if the file exists
            if fileManager.fileExists(atPath: filePath),
                let fileOwner = fileAttributes[FileAttributeKey.ownerAccountName] as? String,
                let fileGroup = fileAttributes[FileAttributeKey.groupOwnerAccountName] as? String,
                let filePermissions = fileAttributes[.posixPermissions] as? NSNumber {
                
                if fileOwner == userName {
                    return parsePermissionString(filePermissions.uint16Value)
                } else if fileGroup == userName {
                    return parsePermissionString(filePermissions.uint16Value)
                } else {
                    return parsePermissionString(filePermissions.uint16Value)
                }
            }
        } catch {
            print("Error getting file permissions: \(error)")
        }
        
        return nil
    }
    func resolveSymlink(atPath path: String) -> String? {
        let fileManager = FileManager.default

        do {
            // Get the file attributes of the path
            let attributes = try fileManager.attributesOfItem(atPath: path)

            // Check if it's a symbolic link
            if let type = attributes[FileAttributeKey.type] as? FileAttributeType,
               type == FileAttributeType.typeSymbolicLink {

                // Get the destination of the symbolic link
                if let destination = try? fileManager.destinationOfSymbolicLink(atPath: path) {
                    return destination
                }
            }
        } catch {
            // Handle errors here, if needed
            print("Error: \(error)")
        }

        // If it's not a symbolic link or an error occurred, return nil
        return nil
    }
    func parsePermissionString(_ permissionValue: UInt16) -> String {
        var result = ""
        
        for i in 0..<3 {
            let shift = UInt16(2 * (2 - i))
            let permissionBits = (permissionValue >> shift) & 0b11
            
            switch permissionBits {
            case 0: result += "---"
            case 1: result += "--x"
            case 2: result += "-w-"
            case 3: result += "rwx"
            default: result += "???"
            }
        }
        
        return result
    }
    
    struct FileMetadata {
        var owner: String
        // Other metadata properties...
    }
    func renameFileOrDirectory(oldPath: String, newPath: String) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.moveItem(atPath: oldPath, toPath: newPath)
            print("Renamed successfully from '\(oldPath)' to '\(newPath)'.")
        } catch {
            error_msg = error.localizedDescription
            showAlert = true
        }
    }
    func getfridaroot() {
        getlocation()
        files = loadSubdirectories(atPath: directoryPath)
        loadFiles()
        owner_dir = getOwnerName(forDirectoryAtPath: directoryPath) ?? ""
        group_dir = getGroupName(forFileAtPath: directoryPath) ?? ""
    }
    func isSymbolicLink(atPath path: String) -> Bool {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
            if let fileType = fileAttributes[.type] as? FileAttributeType {
                return fileType == .typeSymbolicLink
            }
        } catch {
            print("Error: \(error)")
        }
        
        return false
    }
    func geticon(_ fileURL: URL) -> String {
        let filePath = fileURL.path
        let fileExtension = fileURL.pathExtension
        
        if isSymbolicLink(atPath: filePath) {
            return "link"
        } else if isDirectory(fileURL) {
            return "folder"
        } else if fileExtension == "pem" {
            return "checkmark.seal"
        } else if fileExtension == "sh" {
            return "applescript"
        } else if fileExtension == "mp3" {
            return "waveform"
        }
        
        return "doc"
    }
    func doIHaveOwnership(_ fileURL: URL) -> Color {
        let filePath = fileURL.path
        let ffus = getOwnerName(forDirectoryAtPath: filePath)
        let ffgs = getGroupName(forFileAtPath: filePath)
        
        if ffus == cuser {
            return Color.green
        }
        if ffgs == cuser {
            return Color.yellow
        }
        
        return Color.red
    }
    func getCurrentUsername() -> String {
        return NSUserName()
    }
    func getGroupName(forFileAtPath path: String) -> String? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
            
            if let groupOwner = fileAttributes[FileAttributeKey.groupOwnerAccountName] as? String {
                return groupOwner
            }
        } catch {
            print("Error getting group name: \(error.localizedDescription)")
        }
        
        return nil
    }
    func getOwnerNameOFile(forFileAtPath path: String) -> String? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
            
            if let ownerName = fileAttributes[FileAttributeKey.ownerAccountName] as? String {
                return ownerName
            }
        } catch {
            print("Error getting owner name: \(error.localizedDescription)")
        }
        
        return nil
    }
    func getOwnerName(forDirectoryAtPath path: String) -> String? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
            
            if let ownerName = fileAttributes[FileAttributeKey.ownerAccountName] as? String {
                return ownerName
            }
        } catch {
            print("Error getting owner name: \(error.localizedDescription)")
        }
        
        return nil
    }
    func deleteFiles(at offsets: IndexSet) {
        for index in offsets {
            let fileURL = files[index]
            do {
                if exploit_mode == 0 {
                    try FileManager.default.removeItem(at: fileURL)
                    files.remove(at: index)
                } else if exploit_mode == 1 {
                    try FileManager.default.removeItem(at: fileURL)
                    files.remove(at: index)
                } else if exploit_mode == 2 {
                    var attr: posix_spawnattr_t?
                    posix_spawnattr_init(&attr)
                    posix_spawnattr_set_persona_np(&attr, 99, 1)
                    posix_spawnattr_set_persona_uid_np(&attr, uid_t(0))
                    posix_spawnattr_set_persona_gid_np(&attr, gid_t(0))
                    
                    let commandPath = bsm + "fr1d4/bin/rm"
                    let pathCString = strdup(fileURL.path)
                    
                    var pid: pid_t = 0
                    let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-rf"), pathCString]
                    let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
                    
                    for arg in arguments {
                        free(arg)
                    }
                    files.remove(at: index)
                }
            } catch {
                print("Error deleting file: \(error.localizedDescription)")
                error_msg = error.localizedDescription
                showAlert = true
            }
        }
    }
    func getlocation() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Access the documents directory here
            print("Documents Directory: \(documentsDirectory)")
            directoryPath = documentsDirectory.path
        } else {
            // Handle the case where the documents directory is not accessible
            print("Error accessing documents directory.")
        }
    }
    func loadSubdirectories(atPath path: String) -> [URL] {
        let fileManager = FileManager.default
        let directoryURL = URL(fileURLWithPath: path)
        
        do {
            let subdirectoryURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            let subdirectories = subdirectoryURLs.filter { isDirectory($0) }
            return subdirectories
        } catch {
            print("Error loading subdirectories: \(error.localizedDescription)")
            return []
        }
    }
    func isDirectory(_ fileURL: URL) -> Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    func loadSubdirectories(atPath path: String) {
        files = loadSubdirectories(atPath: path)
    }
    func loadFiles() {
        let fileManager = FileManager.default
        let directoryURL = URL(fileURLWithPath: directoryPath)
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            let fileURLsOnly = fileURLs.filter { (url) -> Bool in
                    var isDirectory: ObjCBool = false
                    fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
                    return !isDirectory.boolValue
                }
            // Filter the URLs to include only directories
               let folderURLs = fileURLs.filter { (url) -> Bool in
                   var isDirectory: ObjCBool = true
                   fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
                   return isDirectory.boolValue
               }
            folders = folderURLs
            files = fileURLsOnly
        } catch {
            print("Error loading files: \(error.localizedDescription)")
            error_msg = error.localizedDescription
            showAlert = true
            files = []
        }
    }
    func createFolder(atPath path: String) {
        if !folderName.isEmpty {
            let folderURL = URL(fileURLWithPath: path).appendingPathComponent(folderName)
            
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                folderName = ""
                files = loadSubdirectories(atPath: folderURL.path) // Load files in the created folder
            } catch {
                print("Error creating folder: \(error.localizedDescription)")
                error_msg = error.localizedDescription
                showAlert = true
            }
        }
    }
}

struct TextViewer: View {
    @State private var text: String = ""
    var filePath: String // Add a property to hold the file path
    
    init(filePath: String) {
        self.filePath = filePath
    }
    
    var body: some View {
        VStack {
            Text("Text Viewer")
                .font(.largeTitle)
                .padding(.top, 20)
            
            TextEditor(text: $text)
                .frame(minHeight: 200)
                .padding()
                .onAppear(perform: loadTextFromFile) // Load text when the view appears
            
            Spacer()
        }
        .navigationBarTitle("Text Viewer", displayMode: .inline)
    }
    
    func loadTextFromFile() {
        do {
            let fileURL = URL(fileURLWithPath: filePath)
            let fileContent = try String(contentsOf: fileURL)
            text = fileContent
        } catch {
            print("Error loading file content: \(error)")
        }
    }
}

struct PlistViewer: View {
    let plistPath: String
    @State private var plistData: [String: Any]?
    @State private var openedKeys: Set<String> = []

    var body: some View {
        VStack {
            Text("Plist Viewer")
                .font(.largeTitle)
                .padding(.top, 20)
            
            if let plistData = plistData {
                List {
                    ForEach(Array(plistData.keys), id: \.self) { key in
                        HStack {
                            Text("\(key):")
                                .bold()
                            Spacer()
                            if let subDict = plistData[key] as? [String: Any] {
                                if openedKeys.contains(key) {
                                    Image(systemName: "chevron.down.circle")
                                        .onTapGesture {
                                            toggleKey(key)
                                        }
                                } else {
                                    Image(systemName: "chevron.right.circle")
                                        .onTapGesture {
                                            toggleKey(key)
                                        }
                                }
                            } else {
                                Text(String(describing: plistData[key] ?? ""))
                            }
                        }
                        if openedKeys.contains(key) {
                            PlistViewer(plistPath: plistPath, plistData: plistData[key] as? [String: Any])
                                .padding(.leading, 10)
                                .frame(height: 200)
                        }
                    }
                }
            } else {
                Text("Failed to load Plist data.")
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .navigationBarTitle("Plist Viewer", displayMode: .inline)
        .onAppear(perform: loadPlistData)
    }
    
    init(plistPath: String, plistData: [String: Any]?) {
        self.plistPath = plistPath
        self.plistData = plistData
    }
    
    func loadPlistData() {
        if plistData == nil {
            if let plistDict = NSDictionary(contentsOfFile: plistPath) as? [String: Any] {
                plistData = plistDict
            } else {
                plistData = nil
            }
        }
    }
    
    private func toggleKey(_ key: String) {
        if openedKeys.contains(key) {
            openedKeys.remove(key)
        } else {
            openedKeys.insert(key)
        }
    }
}

struct foldercreation: View {
    @State var folderName: String = ""
    @Binding var directoryPath: String
    @Binding var exploit_mode: Int
    var body: some View {
        NavigationView {
            List {
                TextField("Folder Name", text: $folderName)
                Button("Create") {
                    createFolder(atPath: directoryPath)
                }
            }
            .navigationTitle("Folder")
        }
    }
    func createFolder(atPath path: String) {
        print(String(exploit_mode))
        if exploit_mode == 0 {
            if !folderName.isEmpty {
                let folderURL = URL(fileURLWithPath: path).appendingPathComponent(folderName)
                
                do {
                    try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                    folderName = ""
                } catch {
                    print("Error creating folder: \(error.localizedDescription)")
                }
            }
        } else if exploit_mode == 1 {
            if !folderName.isEmpty {
                let folderURL = URL(fileURLWithPath: path).appendingPathComponent(folderName)
                
                do {
                    try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                    folderName = ""
                } catch {
                    print("Error creating folder: \(error.localizedDescription)")
                }
            }
        } else if exploit_mode == 2 {
            let folderURL = URL(fileURLWithPath: path).appendingPathComponent(folderName)
            var attr: posix_spawnattr_t?
            posix_spawnattr_init(&attr)
            posix_spawnattr_set_persona_np(&attr, 99, 1)
            posix_spawnattr_set_persona_uid_np(&attr, 0)
            posix_spawnattr_set_persona_gid_np(&attr, 0)
            
            let commandPath = "/private/var/fr1d4/bin/mkdir"
            let pathCString = strdup(folderURL.path)
            
            var pid: pid_t = 0
            let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-p"), pathCString]
            let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
            
            for arg in arguments {
                free(arg)
            }
        }
    }
}

struct File_Manager_sub: View {
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    var fd: String
    @State var ldid = ""
    @State var ldidthispath = ""
    @State var ts_uid = ""
    @State var folderName = ""
    @State var files: [URL] = []
    @State var folders: [URL] = []
    @State var directoryPath = "/"
    @State var subdirectories: [URL] = []
    @State var error_msg = ""
    @State var showAlert = false
    @State var filePath = ""
    @State var fileViewer = false
    @State var plistViewer = false
    @State var textViewer = false
    @State var foldercreationview = false
    @State var owner_dir = ""
    @State var group_dir = ""
    @Binding var cuser: String
    @State var isShowingTextInputAlert = false
    @State var textInput = ""
    @Binding var exploit_mode: Int
    @Binding var fropacity: Double
    @Binding var image1: String
    @Binding var bsm: String
    @State private var dfub: Bool = false
    var audioPlayer: AVAudioPlayer?
    var body: some View {
            ZStack {
                Image(image1)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 10)
                    .onAppear {
                        directoryPath = fd
                        loadFiles()
                    }
                List {
                    Section() {
                        ForEach(folders, id: \.self) { file in
                                let fileURL = URL(fileURLWithPath: filePath)
                                let fileExtension = fileURL.pathExtension
                                let ownershipStatus = doIHaveOwnership(file)
                                let textColor = doIHaveOwnership(file)
                                let image = geticon(file)
                                NavigationLink(destination: File_Manager_sub(fd: file.path, cuser: $cuser, exploit_mode: $exploit_mode, fropacity: $fropacity, image1: $image1, bsm: $bsm)) {
                                    HStack {
                                        Image(systemName: image)
                                            .foregroundColor(textColor)
                                        Text(file.lastPathComponent)
                                            .foregroundColor(textColor)
                                            .contextMenu {
                                                Button("Rename") {
                                                    renameFileOrDirectory(oldPath: file.path, newPath: directoryPath + "/" + folderName)
                                                    files = loadSubdirectories(atPath: directoryPath)
                                                    loadFiles()
                                                }
                                                if exploit_mode == 2 {
                                                    Button("Steal File") {
                                                        
                                                    }
                                                }
                                                
                                            }
                                        Spacer()
                                        Text(getFilePermissionsForUser(filePath: file.path, userName: cuser) ?? "")
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .alert(isPresented: $isShowingTextInputAlert) {
                                    Alert(
                                        title: Text("Enter Text"),
                                        message: Text("Please enter some text:"),
                                        primaryButton: .default(Text("Submit")) {
                                            // Handle the submitted text here
                                            print("You entered: \(textInput)")
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                                .onDelete(perform: deleteFiles)
                        ForEach(files, id: \.self) { file in
                                let fileURL = URL(fileURLWithPath: filePath)
                                let fileExtension = fileURL.pathExtension
                                let ownershipStatus = doIHaveOwnership(file)
                                let textColor = doIHaveOwnership(file)
                                let image = geticon(file)
                                    HStack {
                                        Image(systemName: image)
                                            .foregroundColor(textColor)
                                        Text(file.lastPathComponent)
                                            .foregroundColor(textColor)
                                            .contextMenu {
                                                Button("Rename") {
                                                    renameFileOrDirectory(oldPath: file.path, newPath: directoryPath + "/" + folderName)
                                                    files = loadSubdirectories(atPath: directoryPath)
                                                    loadFiles()
                                                }
                                                if exploit_mode == 2 {
                                                    Button("Steal File") {
                                                        
                                                    }
                                                }
                                                
                                            }
                                        Spacer()
                                        Text(getFilePermissionsForUser(filePath: file.path, userName: cuser) ?? "")
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                                .alert(isPresented: $isShowingTextInputAlert) {
                                    Alert(
                                        title: Text("Enter Text"),
                                        message: Text("Please enter some text:"),
                                        primaryButton: .default(Text("Submit")) {
                                            // Handle the submitted text here
                                            print("You entered: \(textInput)")
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                .onTapGesture {
                                    if isSymbolicLink(atPath: file.path) {
                                        let springdir = resolveSymlink(atPath: file.path)
                                        directoryPath = springdir ?? "/"
                                        loadFiles()
                                        owner_dir = getOwnerName(forDirectoryAtPath: directoryPath) ?? ""
                                        group_dir = getGroupName(forFileAtPath: directoryPath) ?? ""
                                        //   } //else if isDirectory(file) {
                                        // directoryPath = file.path
                                        //  loadFiles()
                                        //  owner_dir = getOwnerName(forDirectoryAtPath: directoryPath) ?? ""
                                        //  group_dir = getGroupName(forFileAtPath: directoryPath) ?? ""
                                    } else {
                                        filePath = file.path
                                        let fileExtension = file.pathExtension.lowercased()
                                        
                                        if fileExtension == "txt" {
                                            foldercreationview = false
                                            textViewer = true
                                            plistViewer = false
                                        } else if fileExtension == "plist" {
                                            foldercreationview = false
                                            textViewer = false
                                            plistViewer = true
                                        } else if fileExtension == "mp3" {
                                            AudioPlayerManager.shared.stopAudio()
                                            AudioPlayerManager.shared.playAudio(filePath: file.path)
                                            print(file.path)
                                        } else {
                                            foldercreationview = false
                                            textViewer = true
                                            plistViewer = false
                                        }
                                        
                                        fileViewer = true
                                    }
                                }
                            }
                                .onDelete(perform: deleteFiles)
                    }
                    HStack {
                        Spacer()
                        VStack {
                            Text("current path: " + directoryPath)
                            Text("uid: " + owner_dir + " / gid: " + group_dir)
                        }
                        Spacer()
                    }
                }
                .onAppear {
                    if dfub == false {
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        dfub = true
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle((directoryPath as NSString).lastPathComponent)
                .opacity(fropacity)
                .frame(width: deviceWidth)
                }
                .onAppear {
                    cuser = getCurrentUsername()
                }
                .sheet(isPresented: $fileViewer) {
                    if plistViewer {
                        PlistViewer(plistPath: filePath, plistData: ["": 1])
                            .onDisappear {
                                foldercreationview = false
                                textViewer = false
                                plistViewer = false
                            }
                    } else if textViewer {
                        TextViewer(filePath: filePath)
                            .onDisappear {
                                foldercreationview = false
                                textViewer = false
                                plistViewer = false
                            }
                    } else if foldercreationview {
                        foldercreation(directoryPath: $directoryPath, exploit_mode: $exploit_mode)
                            .onDisappear {
                                foldercreationview = false
                                textViewer = false
                                plistViewer = false
                                files = loadSubdirectories(atPath: directoryPath)
                                loadFiles()
                            }
                    }
                }
                .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Reload Page") {
                            files = loadSubdirectories(atPath: directoryPath)
                            loadFiles()
                        }
                        Button("Create") {
                            foldercreationview = true
                            textViewer = false
                            plistViewer = false
                            fileViewer = true
                        }
                        Menu("Go to") {
                            Button("Frida App Root") {
                                getlocation()
                                files = loadSubdirectories(atPath: directoryPath)
                                loadFiles()
                                owner_dir = getOwnerName(forDirectoryAtPath: directoryPath) ?? ""
                                group_dir = getGroupName(forFileAtPath: directoryPath) ?? ""
                            }
                            Button("/") {
                                directoryPath = "/"
                                files = loadSubdirectories(atPath: directoryPath)
                                loadFiles()
                            }
                            Button("/var") {
                                directoryPath = "/var"
                                files = loadSubdirectories(atPath: directoryPath)
                                loadFiles()
                            }
                            Button("/var/mobile") {
                                directoryPath = "/var/mobile"
                                files = loadSubdirectories(atPath: directoryPath)
                                loadFiles()
                            }
                            Button("/var/root") {
                                directoryPath = "/var/root"
                                files = loadSubdirectories(atPath: directoryPath)
                                loadFiles()
                            }
                        }
                        Menu("Tools") {
                            Button("Stop Audio") {
                                File_Manager.AudioPlayerManager.shared.stopAudio()
                            }
                        }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                    .onAppear {
                        files = loadSubdirectories(atPath: directoryPath)
                        loadFiles()
                        owner_dir = getOwnerName(forDirectoryAtPath: directoryPath) ?? ""
                        group_dir = getGroupName(forFileAtPath: directoryPath) ?? ""
                        foldercreationview = false
                        textViewer = false
                        plistViewer = false
                        fileViewer = false
                    }
                }
            }
            .onAppear {
                loadFiles()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(error_msg),
                    primaryButton: .default(Text("OK")) {
                        // Handle the action when OK is tapped
                        showAlert = false
                    },
                    secondaryButton: .cancel()
                )
            }
    }

    class AudioPlayerManager {
        static let shared = AudioPlayerManager()
        
        private var audioPlayer: AVAudioPlayer?
        
        private init() {} // This prevents others from initializing their own instances
        
        // Function to play audio from a file path
        func playAudio(filePath: String) {
            guard let url = URL(string: filePath) else {
                print("Invalid file path")
                return
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
        
        // Function to stop the currently playing audio
        func stopAudio() {
            if let player = audioPlayer, player.isPlaying {
                player.stop()
            }
        }
    }
    func getFilePermissionsForUser(filePath: String, userName: String) -> String? {
        let fileManager = FileManager.default
        
        // Get file attributes
        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: filePath)
            
            // Check if the file exists
            if fileManager.fileExists(atPath: filePath),
                let fileOwner = fileAttributes[FileAttributeKey.ownerAccountName] as? String,
                let fileGroup = fileAttributes[FileAttributeKey.groupOwnerAccountName] as? String,
                let filePermissions = fileAttributes[.posixPermissions] as? NSNumber {
                
                if fileOwner == userName {
                    return parsePermissionString(filePermissions.uint16Value)
                } else if fileGroup == userName {
                    return parsePermissionString(filePermissions.uint16Value)
                } else {
                    return parsePermissionString(filePermissions.uint16Value)
                }
            }
        } catch {
            print("Error getting file permissions: \(error)")
        }
        
        return nil
    }
    func resolveSymlink(atPath path: String) -> String? {
        let fileManager = FileManager.default

        do {
            // Get the file attributes of the path
            let attributes = try fileManager.attributesOfItem(atPath: path)

            // Check if it's a symbolic link
            if let type = attributes[FileAttributeKey.type] as? FileAttributeType,
               type == FileAttributeType.typeSymbolicLink {

                // Get the destination of the symbolic link
                if let destination = try? fileManager.destinationOfSymbolicLink(atPath: path) {
                    return destination
                }
            }
        } catch {
            // Handle errors here, if needed
            print("Error: \(error)")
        }

        // If it's not a symbolic link or an error occurred, return nil
        return nil
    }
    func parsePermissionString(_ permissionValue: UInt16) -> String {
        var result = ""
        
        for i in 0..<3 {
            let shift = UInt16(2 * (2 - i))
            let permissionBits = (permissionValue >> shift) & 0b11
            
            switch permissionBits {
            case 0: result += "---"
            case 1: result += "--x"
            case 2: result += "-w-"
            case 3: result += "rwx"
            default: result += "???"
            }
        }
        
        return result
    }
    
    struct FileMetadata {
        var owner: String
        // Other metadata properties...
    }
    func renameFileOrDirectory(oldPath: String, newPath: String) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.moveItem(atPath: oldPath, toPath: newPath)
            print("Renamed successfully from '\(oldPath)' to '\(newPath)'.")
        } catch {
            error_msg = error.localizedDescription
            showAlert = true
        }
    }
    func getfridaroot() {
        getlocation()
        files = loadSubdirectories(atPath: directoryPath)
        loadFiles()
        owner_dir = getOwnerName(forDirectoryAtPath: directoryPath) ?? ""
        group_dir = getGroupName(forFileAtPath: directoryPath) ?? ""
    }
    func isSymbolicLink(atPath path: String) -> Bool {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
            if let fileType = fileAttributes[.type] as? FileAttributeType {
                return fileType == .typeSymbolicLink
            }
        } catch {
            print("Error: \(error)")
        }
        
        return false
    }
    func geticon(_ fileURL: URL) -> String {
        let filePath = fileURL.path
        let fileExtension = fileURL.pathExtension
        
        if isSymbolicLink(atPath: filePath) {
            return "link"
        } else if isDirectory(fileURL) {
            return "folder"
        } else if fileExtension == "pem" {
            return "checkmark.seal"
        } else if fileExtension == "sh" {
            return "applescript"
        } else if fileExtension == "mp3" {
            return "waveform"
        }
        
        return "doc"
    }
    func doIHaveOwnership(_ fileURL: URL) -> Color {
        let filePath = fileURL.path
        let ffus = getOwnerName(forDirectoryAtPath: filePath)
        let ffgs = getGroupName(forFileAtPath: filePath)
        
        if ffus == cuser {
            return Color.green
        }
        if ffgs == cuser {
            return Color.yellow
        }
        
        return Color.red
    }
    func getCurrentUsername() -> String {
        return NSUserName()
    }
    func getGroupName(forFileAtPath path: String) -> String? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
            
            if let groupOwner = fileAttributes[FileAttributeKey.groupOwnerAccountName] as? String {
                return groupOwner
            }
        } catch {
            print("Error getting group name: \(error.localizedDescription)")
        }
        
        return nil
    }
    func getOwnerNameOFile(forFileAtPath path: String) -> String? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
            
            if let ownerName = fileAttributes[FileAttributeKey.ownerAccountName] as? String {
                return ownerName
            }
        } catch {
            print("Error getting owner name: \(error.localizedDescription)")
        }
        
        return nil
    }
    func getOwnerName(forDirectoryAtPath path: String) -> String? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
            
            if let ownerName = fileAttributes[FileAttributeKey.ownerAccountName] as? String {
                return ownerName
            }
        } catch {
            print("Error getting owner name: \(error.localizedDescription)")
        }
        
        return nil
    }
    func deleteFiles(at offsets: IndexSet) {
        for index in offsets {
            let fileURL = files[index]
            do {
                if exploit_mode == 0 {
                    try FileManager.default.removeItem(at: fileURL)
                    files.remove(at: index)
                } else if exploit_mode == 1 {
                    try FileManager.default.removeItem(at: fileURL)
                    files.remove(at: index)
                } else if exploit_mode == 2 {
                    var attr: posix_spawnattr_t?
                    posix_spawnattr_init(&attr)
                    posix_spawnattr_set_persona_np(&attr, 99, 1)
                    posix_spawnattr_set_persona_uid_np(&attr, uid_t(0))
                    posix_spawnattr_set_persona_gid_np(&attr, gid_t(0))
                    
                    let commandPath = bsm + "fr1d4/bin/rm"
                    let pathCString = strdup(fileURL.path)
                    
                    var pid: pid_t = 0
                    let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-rf"), pathCString]
                    let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
                    
                    for arg in arguments {
                        free(arg)
                    }
                    files.remove(at: index)
                }
            } catch {
                print("Error deleting file: \(error.localizedDescription)")
                error_msg = error.localizedDescription
                showAlert = true
            }
        }
    }
    func getlocation() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Access the documents directory here
            print("Documents Directory: \(documentsDirectory)")
            directoryPath = documentsDirectory.path
        } else {
            // Handle the case where the documents directory is not accessible
            print("Error accessing documents directory.")
        }
    }
    func loadSubdirectories(atPath path: String) -> [URL] {
        let fileManager = FileManager.default
        let directoryURL = URL(fileURLWithPath: path)
        
        do {
            let subdirectoryURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            let subdirectories = subdirectoryURLs.filter { isDirectory($0) }
            return subdirectories
        } catch {
            print("Error loading subdirectories: \(error.localizedDescription)")
            return []
        }
    }
    func isDirectory(_ fileURL: URL) -> Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    func loadSubdirectories(atPath path: String) {
        files = loadSubdirectories(atPath: path)
    }
    func loadFiles() {
        let fileManager = FileManager.default
        let directoryURL = URL(fileURLWithPath: directoryPath)
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            let fileURLsOnly = fileURLs.filter { (url) -> Bool in
                    var isDirectory: ObjCBool = false
                    fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
                    return !isDirectory.boolValue
                }
            // Filter the URLs to include only directories
               let folderURLs = fileURLs.filter { (url) -> Bool in
                   var isDirectory: ObjCBool = true
                   fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
                   return isDirectory.boolValue
               }
            folders = folderURLs
            files = fileURLsOnly
        } catch {
            print("Error loading files: \(error.localizedDescription)")
            error_msg = error.localizedDescription
            showAlert = true
            files = []
        }
    }
    func createFolder(atPath path: String) {
        if !folderName.isEmpty {
            let folderURL = URL(fileURLWithPath: path).appendingPathComponent(folderName)
            
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                folderName = ""
                files = loadSubdirectories(atPath: folderURL.path) // Load files in the created folder
            } catch {
                print("Error creating folder: \(error.localizedDescription)")
                error_msg = error.localizedDescription
                showAlert = true
            }
        }
    }
}
