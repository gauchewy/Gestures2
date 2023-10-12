//
//  ContentView.swift
//  Gestures2
//
//  Created by Qiwei on 10/11/23.
//

import SwiftUI

// Your Enumeration
enum SelectedOption: String {
    case handClasp = "Hand Clasp"
    case binoculars = "Binoculars"
    case wave = "Wave"
    case interlace = "Interlace"
    case iscratch = "iScratch"
}

struct ContentView: View {
    @State private var isSettingsViewShown = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("Welcome to Justure")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                Spacer()

                ButtonGroupView()

                Spacer()

                NavigationLink(destination: ScratchView()) {
                    Text("iScratch")
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .cornerRadius(10)
                }.padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Button(action: {
                                isSettingsViewShown = true
                            }) {
                                Image(systemName: "gear")
                                    .font(.title)
                            }
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Justure")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                .sheet(isPresented: $isSettingsViewShown) {
                    SettingsView()
                }

                Spacer()
            }
        }
    }
}

struct ButtonGroupView: View {
    let actions: [SelectedOption] = [.handClasp, .binoculars, .wave, .interlace]

    var body: some View {
        VStack {
            ForEach(actions, id: \.self) { action in
                NavigationLink(destination: OtherView(selection: action)) {
                    Text(action.rawValue)
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }.padding(.bottom)
            }
        }.padding()
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings")
            .font(.largeTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
