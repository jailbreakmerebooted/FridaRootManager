import SwiftUI

struct Setup: View {
    @State private var state: String = "ts"
    @State private var frida: Bool = false
    @State private var setup_done: Bool = false
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    var body: some View {
        if !frida {
            if !setup_done {
                NavigationView {
                    VStack {
                        ZStack {
                            Image("frida7")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .edgesIgnoringSafeArea(.all)
                                .blur(radius: 10)
                            VStack(alignment: .leading) {
                                Text("FridaRootManager")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.black)
                                Text("iOS 14.0 - 17.0")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                                Text("From Sean for Frida")
                                    .font(.system(size: 17))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Next") {
                                        setup_done = true
                                    }
                                }
                            }
                        }
                    }
                }
            } else if setup_done {
                NavigationView {
                    List {
                        Section(header: Text("Mode")) {
                            Button(action: {
                                       state = "ts"
                            }) {
                                HStack {
                                    Image("ts")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(10)
                                    Spacer().frame(width: 25)
                                    VStack(alignment: .leading) {
                                        Spacer().frame(height: 10)
                                        Text("TrollStore")
                                            .font(.system(size: 17, weight: .bold)) // Use a professional font and adjust size
                                            .foregroundColor(.primary)
                                        Spacer().frame(height: 10)
                                        Text("iOS 14.0 - 15.4.1")
                                            .font(.system(size: 14)) // Adjust size
                                            .foregroundColor(.secondary) // Use a lighter color for additional information
                                        Text("Full featured")
                                            .font(.system(size: 14)) // Adjust size
                                            .foregroundColor(.secondary)
                                        Spacer().frame(height: 10)
                                    }
                                    .frame(height: 70)
                                    Spacer()
                                    Image(systemName: state == "ts" ? "checkmark.circle.fill" : "circle")
                                    Spacer().frame(width: 10)
                                }
                            }
                            Button(action: {
                                       state = "mdc"
                            }) {
                                HStack {
                                    Image("cow")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(10)
                                    Spacer().frame(width: 25)
                                    VStack(alignment: .leading) {
                                        Spacer().frame(height: 10)
                                        Text("MacDirtyCow")
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundColor(.primary)
                                        Spacer().frame(height: 10)
                                        Text("iOS 14.0 - 16.1.2")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondary)
                                        Text("Unsandboxed")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondary)
                                        Spacer().frame(height: 10)
                                    }
                                    .frame(height: 70)
                                    Spacer()
                                    Image(systemName: state == "mdc" ? "checkmark.circle.fill" : "circle")
                                    Spacer().frame(width: 10)
                                }
                            }
                            Button(action: {
                                       // Code to execute when the button is tapped
                                       state = "ios"
                            }) {
                                HStack {
                                    Image("ios")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(10)
                                    Spacer().frame(width: 25)
                                    VStack(alignment: .leading) {
                                        Spacer().frame(height: 10)
                                        Text("Normal")
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundColor(.primary)
                                        Spacer().frame(height: 10)
                                        Text("iOS 14.0 - 17.0")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondary)
                                        Text("No Exploits")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondary)
                                        Spacer().frame(height: 10)
                                    }
                                    .frame(height: 70)
                                    Spacer()
                                    Image(systemName: state == "ios" ? "checkmark.circle.fill" : "circle")
                                    Spacer().frame(width: 10)
                                }
                            }
                        }
                    }
                }
                Button("FRIDA!!!!") {
                    frida = true
                }
            }
        } else if frida {
            RootView()
        }
    }
}
