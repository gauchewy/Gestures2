//
//  ContentView.swift
//  Gestures2
//
//  Created by Qiwei on 10/11/23.
//

import SwiftUI

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
                
                NavigationLink(destination: OtherView()) {
                    Text("Single Button")
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .cornerRadius(20)
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
    let buttonLabels = ["Hand Clasp", "Binoculars", "Wave", "Interlace"]
    
    var body: some View {
        VStack {
            ForEach(buttonLabels, id: \.self) { label in
                NavigationLink(destination: OtherView()) {
                    Text(label)
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(40)
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

struct OtherView: View {
    var body: some View {
        Text("Other View")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
