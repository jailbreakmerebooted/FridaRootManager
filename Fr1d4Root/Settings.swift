import SwiftUI
import MacDirtyCow
import Exploit
import Foundation
import Darwin.POSIX.spawn

struct settings: View {
    @Binding var exploit_mode: Int
    @Binding var bsm: String
    @Binding var fropacity: Double
    @Binding var image1: String
    @State var isdesbsd: Bool = false
    @Binding var debug_mode: Bool
    @Binding var zebra: Bool
    @Binding var sileo: Bool
    let deviceWidth = UIScreen.main.bounds.width
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
                        Text("FridaRootManager")
                        Text("1.0-closedbeta-4")
                    Section(header: Text("Exploitation")) {
                        NavigationLink(destination: MDC()){
                            Text("MacDirtyCow")
                        }
                    }
                    Section(header: Text("tools")) {
                        NavigationLink(destination: posix_death(bsm: $bsm)) {
                            Text("POSIX")
                        }
                    }
                    NavigationLink(destination: theming(fropacity: $fropacity, image1: $image1)) {
                        Text("Theming")
                    }
                    Section {
                        Toggle("Debug Mode", isOn: $debug_mode)
                        Toggle("Install Sileo", isOn: $sileo)
                        Toggle("Install Zebra", isOn: $zebra)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Settings")
                .opacity(fropacity)
                .frame(width: deviceWidth)
            }
        }
    }
    func unsandbox() {
        var errormessage = ""
        grant_full_disk_access { error in
            if error != nil {
                errormessage = String(describing: error?.localizedDescription ?? "unknown?!")
            }
        }
    }
    func restartbackboard() {
        MacDirtyCow.restartBackboard()
    }
}

struct theming: View {
    @Binding var fropacity: Double
    @Binding var image1: String
    var body: some View {
        VStack {
            List {
                VStack {
                    Spacer().frame(height: 20)
                    HStack {
                        Spacer()
                        Image(image1)
                            .resizable()
                            .blur(radius: 2)
                            .scaledToFit()
                            .cornerRadius(15)
                            .frame(width: 200, height: 200)
                            .shadow(radius: 10)
                        Spacer()
                    }
                    Spacer().frame(height: 20)
                }
                Section(header: Text("image1")) {
                    Button("frida") {
                        image1 = "frida"
                    }
                    Button("frida2") {
                        image1 = "frida2"
                    }
                    Button("frida3") {
                        image1 = "frida3"
                    }
                    Button("frida4") {
                        image1 = "frida4"
                    }
                    Button("frida5") {
                        image1 = "frida5"
                    }
                    Button("frida6") {
                        image1 = "frida6"
                    }
                    Button("frida7") {
                        image1 = "frida7"
                    }
                }
                Section {
                    Text("Opacity: \(String(format: "%.2f", fropacity))") // Display the current value
                    
                    Slider(value: $fropacity, in: 0.0...1.0) // Slider for the Double value
                        .padding()
                }
            }
        }
    }
}
