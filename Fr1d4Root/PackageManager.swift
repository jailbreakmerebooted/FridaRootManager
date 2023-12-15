import SwiftUI

struct PackageManager: View {
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    @Binding var bsm: String
    @Binding var fropacity: Double
    @Binding var image1: String
    @State private var executables: [(name: String, size: String, creationDate: Date)] = []
    @State private var sortOption: SortOption = .name // Default sorting option
    
    enum SortOption: String, CaseIterable {
        case name = "Name"
        case size = "Size"
        case creationDate = "Creation Date"
    }

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
                    ForEach(sortedExecutables, id: \.name) { executable in
                        VStack(alignment: .leading) {
                            Text("\(executable.name)")
                            Text("Size: \(executable.size)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("Creation Date: \(executable.creationDate, formatter: dateFormatter)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: deleteExecutable) // Add onDelete modifier here
                }
                .listStyle(InsetGroupedListStyle())
                .opacity(fropacity)
                .frame(width: deviceWidth)
            }
            .onAppear {
                executables = []
                findExecutables(in: "/var/jb/usr/bin")
                findExecutables(in: "/var/jb/usr/lib")
            }
            .navigationBarTitle("Package Manager")
            .navigationBarItems(trailing: Picker("Sort By", selection: $sortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle()))
        }
    }

    var sortedExecutables: [(name: String, size: String, creationDate: Date)] {
        switch sortOption {
        case .name:
            return executables.sorted { $0.name < $1.name }
        case .size:
            return executables.sorted { $0.size > $1.size }
        case .creationDate:
            return executables.sorted { $0.creationDate > $1.creationDate }
        }
    }

    func findExecutables(in directoryPath: String) {
        let fileManager = FileManager.default
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: directoryPath)
            
            var newExecutables: [(name: String, size: String, creationDate: Date)] = []
            
            for fileName in contents {
                let filePath = (directoryPath as NSString).appendingPathComponent(fileName)
                
                if isExecutableFile(filePath: filePath) {
                    if let fileSize = getFileSize(filePath: filePath),
                       let creationDate = getFileCreationDate(filePath: filePath) {
                        newExecutables.append((name: fileName, size: fileSize, creationDate: creationDate))
                    }
                }
            }
            executables = newExecutables + executables // Update the executables array
        } catch {
            print("Error reading directory: \(error.localizedDescription)")
        }
    }


    func isExecutableFile(filePath: String) -> Bool {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: filePath, isDirectory: &isDirectory) {
            if !isDirectory.boolValue {
                // Check if the file has execute permissions
                let attributes = try? fileManager.attributesOfItem(atPath: filePath)
                if let permissions = attributes?[.posixPermissions] as? NSNumber {
                    return permissions.intValue & 0o111 != 0
                }
            }
        }
        return false
    }
    
    func getFileSize(filePath: String) -> String? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = attributes[.size] as? Int64 {
                let byteCountFormatter = ByteCountFormatter()
                byteCountFormatter.countStyle = .file
                return byteCountFormatter.string(fromByteCount: fileSize)
            }
        } catch {
            print("Error getting file size: \(error.localizedDescription)")
        }
        return nil
    }
    
    func getFileCreationDate(filePath: String) -> Date? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let creationDate = attributes[.creationDate] as? Date {
                return creationDate
            }
        } catch {
            print("Error getting file creation date: \(error.localizedDescription)")
        }
        return nil
    }
    
    func deleteExecutable(at offsets: IndexSet) {
        let path: String = bsm + "fr1d4/bin"
        // Get the selected indexes and corresponding executables to delete
        let executablesToDelete = offsets.map { sortedExecutables[$0] }

        // Delete the associated binary files
        let fileManager = FileManager.default
        for executable in executablesToDelete {
            let filePath = (path as NSString).appendingPathComponent(executable.name)
            do {
                try fileManager.removeItem(atPath: filePath)
            } catch {
                print("Error deleting file: \(error.localizedDescription)")
            }
        }

        // Update the executables array after deletion
        executables.removeAll { executable in
            executablesToDelete.contains { $0.name == executable.name }
        }
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}
