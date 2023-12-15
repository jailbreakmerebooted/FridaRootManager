import SwiftUI
import MacDirtyCow
import Foundation
import ZIPFoundation
import ZipArchive
import Darwin.POSIX.spawn
import UIKit
import NSTaskBridge

struct Line: View {
    let text: String

    var body: some View {
        HStack {
            Text(text)
                .font(.system(.caption2, design: .monospaced))
            Spacer()
        }
    }
}

struct Terminal: View {
    @ObservedObject var console = Console.shared
    @Binding var bsm: String
    @Binding var image1: String
    @Binding var fropacity: Double
    @Binding var cuser: String

    @State private var inputCommand = ""
    @State private var outputText = ""
    @State private var workdir: String = "/"
    @State private var returnment: String = ""

    var body: some View {
        ZStack {
            Image(image1)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 10)

            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(console.lines, id: \.self) { item in
                            Line(text: item)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .flipped()
                }
                .frame(height: UIScreen.main.bounds.height / 2)
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .foregroundColor(.black)
                )
                .opacity(0.8)
                .padding(.horizontal)
                .flipped()

                HStack {
                    TextField("Enter a command", text: $inputCommand)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()

                    Button("EXEC") {
                        preexec()
                    }
                    .frame(width: 75)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 10)
            .padding()
        }
    }

    func preexec() {
        returnment = ""
        if containsCdCommand(withPath: inputCommand) {
            if isFirstCharacterSlash(removeCdPrefix(from: inputCommand)) {
                if pathExists(atPath: removeCdPrefix(from: inputCommand)) {
                    workdir = removeCdPrefix(from: inputCommand)
                } else {
                    returnment = "cd: path not found"
                }
            } else if removeCdPrefix(from: inputCommand) == ".." {
                workdir = (workdir as NSString).deletingLastPathComponent
            } else {
                if pathExists(atPath: workdir + "/" + removeCdPrefix(from: inputCommand)) {
                    if isFirstCharacterSlash(removeCdPrefix(from: workdir)) {
                        workdir += removeCdPrefix(from: inputCommand)
                    } else {
                        workdir += "/" + removeCdPrefix(from: inputCommand)
                    }
                } else {
                    returnment = "cd: path not found"
                }
            }
        } else {
            console.log("[" + cuser + "]" + workdir + "> " + inputCommand)
            executeCommand()
            inputCommand = ""
            return
        }
        console.log("[" + cuser + "]" + workdir + "> " + inputCommand)
        inputCommand = ""
        if returnment != "" {
            console.log(returnment)
        }
    }

    func executeCommand() {
        let command = inputCommand
        runExecutable(pathAndArgs: bsm + "fr1d4/bin/env " + bsm + "fr1d4/bin/" + command)
    }

    func pathExists(atPath path: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }

    func containsCdCommand(withPath input: String) -> Bool {
        let pattern = "^cd (.+)$"
        if let _ = input.range(of: pattern, options: .regularExpression) {
            return true
        }
        return false
    }

    func isFirstCharacterSlash(_ input: String) -> Bool {
        return input.first == "/"
    }

    func removeCdPrefix(from input: String) -> String {
        let pattern = "^cd (.+)$"
        let replacement = "$1"

        let modifiedInput = input.replacingOccurrences(
            of: pattern,
            with: replacement,
            options: .regularExpression
        )

        return modifiedInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func runExecutable(pathAndArgs: String) {
        var components = pathAndArgs.components(separatedBy: " ")
        guard let executable = components.first, !executable.isEmpty else {
            return
        }

        components.removeFirst()
        let task = NSTask()

        task.currentDirectoryURL = URL(fileURLWithPath: workdir)
        task.executableURL = URL(fileURLWithPath: executable)
        task.arguments = components

        let pipe = Pipe()
        task.standardError = pipe
        task.standardOutput = pipe

        do {
            outputText = ""
            task.launch()
            task.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            
            // Attempt to decode as ASCII
            if let asciiString = String(data: data, encoding: .ascii) {
                console.log(asciiString)
                outputText = asciiString
            } else {
                // Fallback to UTF-8
                if let utf8String = String(data: data, encoding: .utf8) {
                    console.log(utf8String)
                    outputText = utf8String
                }
            }
        } catch {
            return
        }
    }
}

class Console: ObservableObject {
    static let shared = Console()

    @Published var lines = [String]()

    init() {
        log("[*] FridaRootManager Closed Beta 4")
        log("[*] FridaTerminal v.0.2")
        log("")
    }

    func log(_ str: String) {
        DispatchQueue.main.async {
            self.lines.append(str)
        }
    }
}
