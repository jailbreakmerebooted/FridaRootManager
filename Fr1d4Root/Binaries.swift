import Foundation
import Darwin.POSIX.spawn
import Darwin.POSIX.sys.stat
import Darwin.POSIX.sys.types
import Darwin.POSIX.fcntl
import SwiftUI

class OutputCapture {
    var value: NSString?

    init() {}
}

struct Binaries: View {
    var stdOut: AutoreleasingUnsafeMutablePointer<NSString?>?
    var errormsgbox2: AutoreleasingUnsafeMutablePointer<NSString?>?
    @State var errormsgbox = ""
    @State var dir = ""
    @State var uid = 0
    @State var gid = 0
    @State var username = ""
    @State var ldid = ""
    @State var ldidthispath = ""
    @State var ts_uid = ""
    @State var ldid_calls = 0
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("ldid calls: " + String(ldid_calls))
                }
                Section {
                    Button("Resign Apps") {
                        ldid_calls = 0
                        resignAllFilesInDirectoryAtPath("/var/jb/Applications")
                    }
                    .foregroundColor(.green)
                }
                Section(header: Text("bootstrap actions")) {
                    Button("Resign Binaries") {
                        ldid_calls = 0
                        resignAllFilesInDirectoryAtPath("/var/jb/bin")
                    }
                    .foregroundColor(.orange)
                    Button("Resign Libraries") {
                        ldid_calls = 0
                        resignAllFilesInDirectoryAtPath("/var/jb/Library")
                    }
                    .foregroundColor(.orange)
                }
                Section(header: Text("usr actions")) {
                    Button("Resign System Binaries") {
                        ldid_calls = 0
                        resignAllFilesInDirectoryAtPath("/var/jb/usr/sbin")
                    }
                    .foregroundColor(.orange)
                    Button("Resign Binaries") {
                        ldid_calls = 0
                        resignAllFilesInDirectoryAtPath("/var/jb/usr/bin")
                    }
                    .foregroundColor(.orange)
                    Button("Resign Libraries") {
                        ldid_calls = 0
                        resignAllFilesInDirectoryAtPath("/var/jb/usr/lib")
                    }
                    .foregroundColor(.orange)
                    Button("Resign Local") {
                        ldid_calls = 0
                        resignAllFilesInDirectoryAtPath("/var/jb/usr/local")
                    }
                    .foregroundColor(.orange)
                    Button("Resign Share") {
                        ldid_calls = 0
                        resignAllFilesInDirectoryAtPath("/var/jb/usr/share")
                    }
                    .foregroundColor(.orange)
                }
                Section {
                    Button("resign bootstrap (mostlikely breaks bootstrap)") {
                        ldid_calls = 0
                        resignAllFilesInDirectoryAtPath("/var/jb")
                    }
                    .foregroundColor(.red)
                }
            }
            .onAppear {
                ts_uid = getAppUUID(for: "TrollStore.app", in: "/private/var/containers/Bundle/Application") ?? "not found: TrollStore missing?"
                ldid = "/private/var/containers/Bundle/Application/" + ts_uid + "/TrollStore.app/ldid"
            }
            .navigationTitle("Binaries")
        }
    }
    func getAppUUID(for appName: String, in folderPath: String) -> String? {
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
    func resignAllFilesInDirectoryAtPath(_ directoryPath: String) {
        DispatchQueue.global(qos: .background).async {
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: directoryPath)
            
            while let filePath = enumerator?.nextObject() as? String {
                let fullPath = (directoryPath as NSString).appendingPathComponent(filePath)
                
                // Check if the file is executable
                if isExecutableFile(filePath: fullPath) {
                    // Sign the executable file using ldid
                    ldidDirectoryAtPath(fullPath)
                }
            }
        }
    }

    func isExecutableFile(filePath: String) -> Bool {
        var isExecutable = false
        
        // Check if the file exists and is a regular file
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory) && !isDirectory.boolValue {
            // Check if the file is executable
            if access(filePath, X_OK) == 0 {
                isExecutable = true
            }
        }
        if FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory) && isDirectory.boolValue {
            resignAllFilesInDirectoryAtPath(filePath)
        }
        
        return isExecutable
    }
    func ldidDirectoryAtPath(_ path: String) {
        ldid_calls += 1
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, uid_t(uid))
        posix_spawnattr_set_persona_gid_np(&attr, gid_t(gid))
        
        let commandPath = ldid // Update the path to ldid as needed
        let pathCString = strdup(path)
        
        var pid: pid_t = 0
        let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-K" + "/private/var/containers/Bundle/Application/" + ts_uid + "/TrollStore.app/cert.p12"), strdup("-s"), pathCString, nil]
        
        let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
        for arg in arguments {
            free(arg)
        }
        
        if status != 0 {
            errormsgbox = "Error signing executable at path \(path): \(strerror(status)!)"
            return
        }
        
        // Wait for the child process to finish
        var childStatus: Int32 = 0
        let waitResult = waitpid(pid, &childStatus, 0)
        
        if waitResult == -1 {
            errormsgbox = "Error waiting for ldid process: \(strerror(errno)!)"
            return
        } else {
            errormsgbox = "ldid process did not exit normally."
            return
        }
        
        errormsgbox = "Executable signed successfully at path: \(path)"
    }
    func createDirectoryhacky(atPath path: String, withPermissions permissions: mode_t) {
        let fileDescriptor = open(path, O_RDONLY | O_CREAT | O_DIRECTORY, permissions)
        
        if fileDescriptor != -1 {
            close(fileDescriptor)
            errormsgbox = "Directory created successfully at path: \(path)"
        } else {
            let errorNumber = errno
            let errorMessage = String(cString: strerror(errorNumber))
            errormsgbox = "Error creating directory at path \(path): \(errorMessage)"
        }
    }
    func appPath() -> String? {
        if let appURL = Bundle.main.executableURL {
            return appURL.path
        }
        return nil
    }
}
