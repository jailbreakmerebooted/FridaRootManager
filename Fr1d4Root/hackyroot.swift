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

struct posix_death: View {
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
    @State var tried = 0
    @State private var roothash: String = ""
    @Binding var bsm: String
    var body: some View {
        List {
            Section {
                Text(errormsgbox)
                    .font(.system(size: 10))
                Button("spawn binary") {
                    executeBinary()
                }
                TextField("directory" ,text: $dir)
                Button("mkdir") {
                    let exitCode = createDirectory(atPath: dir)
                    
                    if exitCode == 0 {
                        errormsgbox = "Directory created successfully"
                    } else {
                        errormsgbox = "Error creating directory (Exit Code: \(exitCode))"
                    }
                }
            }
            Section(header: Text("posix panel")) {
                TextField("CHNAME", text: $username)
                TextField("UID", value: $uid, formatter: NumberFormatter())
                TextField("GID", value: $gid, formatter: NumberFormatter())
                Button("mkdir") {
                    createDirectoryAtPath(dir)
                }
                Button("rmdir") {
                    removeDirectoryAtPath(dir)
                }
                Button("chgrp") {
                    chgrpAtPath(dir)
                }
                Button("chown") {
                    chownAtPath(dir)
                }
            }

            Button("remount preboot") {
                remountpreboot()
            }
            Section(header: Text("ldid panel")) {
                TextField("exec name in bootstrap", text:$ldidthispath)
                Button("ldid") {
                    ldidDirectoryAtPath(bsm + "fr1d4/" + ldidthispath)
                }
                Button("resign all frida binaries") {
                    resignAllFilesInDirectoryAtPath(bsm + "fr1d4/bin/")
                }
                Button("resign all lib") {
                    resignAllFilesInDirectoryAtPath("/var/jb/usr/lib")
                }
                .foregroundColor(.orange)
                Button("resign all bin") {
                    resignAllFilesInDirectoryAtPath("/var/jb/usr/bin")
                }
                .foregroundColor(.orange)
                Button("resign bootstrap (experimental)") {
                    resignAllFilesInDirectoryAtPath(bsm + "/var/jb")
                }
                .foregroundColor(.red)
            }
            Section {
                Text("Tried: " + String(tried))
                Button("Force remove JB Folder") {
                    roothash = getFolderNameIfSingleFolder(directoryPath: "/private/preboot/") ?? ""
                    tried = 0
                    removeJBFolder()
                }
                .foregroundColor(.red)
            }
        }
        .onAppear {
            ts_uid = getAppUUID(for: "TrollStore.app", in: "/private/var/containers/Bundle/Application") ?? "not found: TrollStore missing?"
            ldid = "/private/var/containers/Bundle/Application/" + ts_uid + "/TrollStore.app/ldid"
        }
        .navigationTitle("POSIX")
    }
    func removeJBFolder() {
        tried += 1
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
            return
        } else {
            removeJBFolder()
        }
    }
    func getFolderNameIfSingleFolder(directoryPath: String) -> String? {
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
            print("Error: \(error)")
        }
        
        return nil
    }
    func executeBinary() {
        let binaryPath = bsm + "fr1d4/bin/" + ldidthispath
        let arguments: [String] = [""]
        
        errormsgbox = "Executing binary: \(binaryPath)"
        errormsgbox = "Arguments: \(arguments)"
        
        var pid = pid_t()
        var cArgs: [UnsafeMutablePointer<CChar>?] = [strdup(binaryPath)]
        
        for arg in arguments {
            cArgs.append(strdup(arg))
        }
        cArgs.append(nil)
        
        errormsgbox = "Executing process..."
        
        let spawnResult = posix_spawn(&pid, binaryPath, nil, nil, cArgs, environ)
        
        if spawnResult == 0 {
            errormsgbox = "Process spawned successfully with PID: \(pid)"
            
            // Optionally, wait for the process to complete
            waitpid(pid, nil, 0)
            
            print("Process completed.")
        } else {
            if let errorDescription = strerror(spawnResult).flatMap({ String(validatingUTF8: $0) }) {
                errormsgbox = "Error spawning process: \(errorDescription)"
            } else {
                errormsgbox = "Error spawning process: Unknown error"
            }
        }
        
        // Free memory allocated for C-style arguments
        for arg in cArgs.dropLast() {
            free(arg)
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
    func removeDirectoryAtPath(_ path: String) {
        
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, uid_t(uid))
        posix_spawnattr_set_persona_gid_np(&attr, gid_t(gid))
        
        let commandPath = "/private/var/fr1d4/bin/rmdir"
        let pathCString = strdup(path)
        
        var pid: pid_t = 0
        let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-p"), pathCString]
        let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
        
        for arg in arguments {
            free(arg)
        }
        
        if status == 0 {
            errormsgbox = "Directory removed successfully at path: \(path)"
        } else {
            errormsgbox = "Error removing directory at path \(path): \(strerror(status)!)"
        }
    }
    func remountpreboot() {
        
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, uid_t(uid))
        posix_spawnattr_set_persona_gid_np(&attr, gid_t(gid))
        
        let commandPath = "/sbin/mount"
        
        var pid: pid_t = 0
        let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-u"), strdup("-w"), strdup("/private/preboot")]
        let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
        
        for arg in arguments {
            free(arg)
        }
        
        if status == 0 {
            errormsgbox = "sucess remounting"
        } else {
            errormsgbox = "not successfully remounted preboot"
            remountpreboot()
        }
    }
    func killall_own() {
        
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, uid_t(uid))
        posix_spawnattr_set_persona_gid_np(&attr, gid_t(gid))
        
        let commandPath = bsm + "fr1d4/bin/killall"
        
        var pid: pid_t = 0
        let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("Fr1d4Root")]
        let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
        
        for arg in arguments {
            free(arg)
        }
        
        if status == 0 {
            errormsgbox = "sucess remounting"
        } else {
            errormsgbox = "not successfully remounted preboot"
        }
    }
    func resignAllFilesInDirectoryAtPath(_ directoryPath: String) {
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
    
    func createDirectoryAtPath(_ path: String) {
        
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, uid_t(uid))
        posix_spawnattr_set_persona_gid_np(&attr, gid_t(gid))
        
        let commandPath = bsm + "fr1d4/bin/mkdir"
        let pathCString = strdup(path)
        
        var pid: pid_t = 0
        let arguments: [UnsafeMutablePointer<CChar>?] = [strdup(commandPath), strdup("-p"), pathCString]
        let status = posix_spawn(&pid, commandPath, nil, &attr, arguments, nil)
        
        for arg in arguments {
            free(arg)
        }
        
        if status == 0 {
            errormsgbox = "Directory created successfully at path: \(path)"
        } else {
            errormsgbox = "Error creating directory at path \(path): \(strerror(status)!)"
        }
    }
    func chownAtPath(_ path: String) {
        
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, uid_t(uid))
        posix_spawnattr_set_persona_gid_np(&attr, gid_t(gid))
        
        let commandPath = bsm + "fr1d4/bin/chown"
        
        // Convert Swift strings to C strings
        let cCommandPath = strdup(commandPath)
        let cUsername = strdup(username)
        let cPath = strdup(path)
        
        // Use posix_spawn to run the chown command with the specified persona
        var pid: pid_t = 0
        let status = posix_spawn(&pid, cCommandPath, nil, &attr, [cCommandPath, cUsername, cPath, nil], nil)
        
        // Free the allocated C strings
        free(cCommandPath)
        free(cUsername)
        free(cPath)
        
        if status == 0 {
            errormsgbox = "Ownership changed successfully for \(path) to \(username)"
        } else {
            errormsgbox = "Error changing ownership for \(path): \(strerror(status)!)"
        }
    }
    func chgrpAtPath(_ path: String) {
        
        var attr: posix_spawnattr_t?
        posix_spawnattr_init(&attr)
        posix_spawnattr_set_persona_np(&attr, 99, 1)
        posix_spawnattr_set_persona_uid_np(&attr, uid_t(uid))
        posix_spawnattr_set_persona_gid_np(&attr, gid_t(gid))
        
        let commandPath = bsm + "fr1d4/bin/chgrp"
        
        // Convert Swift strings to C strings
        let cCommandPath = strdup(commandPath)
        let cUsername = strdup(username)
        let cPath = strdup(path)
        
        // Use posix_spawn to run the chown command with the specified persona
        var pid: pid_t = 0
        let status = posix_spawn(&pid, cCommandPath, nil, &attr, [cCommandPath, cUsername, cPath, nil], nil)
        
        // Free the allocated C strings
        free(cCommandPath)
        free(cUsername)
        free(cPath)
        
        if status == 0 {
            errormsgbox = "Ownership changed successfully for \(path) to \(username)"
        } else {
            errormsgbox = "Error changing ownership for \(path): \(strerror(status)!)"
        }
    }
    func createDirectory(atPath path: String, withPermissions permissions: mode_t = S_IRWXU) -> Int32 {
        var pid = pid_t()
        var exitCode: Int32 = -1
        
        let mkdirPath = bsm + "fr1d4/bin/mkdir"
        
        var cArgs: [UnsafeMutablePointer<CChar>?] = [strdup(mkdirPath), strdup(path)]
        cArgs.append(nil)
        
        let spawnResult = posix_spawn(&pid, mkdirPath, nil, nil, cArgs, environ)
        
        if spawnResult == 0 {
            waitpid(pid, &exitCode, 0)
        } else {
            exitCode = spawnResult
        }
        
        for arg in cArgs.dropLast() {
            free(arg)
        }
        
        return exitCode
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
