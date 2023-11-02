@_private(sourceFile: "ContentView.swift") import Gestures2
import func SwiftUI.__designTimeBoolean
import func SwiftUI.__designTimeInteger
import protocol SwiftUI.PreviewProvider
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeFloat
import struct SwiftUI.EmptyView
import protocol SwiftUI.View
import SwiftUI

extension ContentView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/cristiisaula/Desktop/Gestures2/Gestures2/ContentView.swift", line: 164)
        ContentView()
    
#sourceLocation()
    }
}

extension SettingsView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/cristiisaula/Desktop/Gestures2/Gestures2/ContentView.swift", line: 105)
        VStack {
            Spacer()
            Text(__designTimeString("#6793.[4].[6].property.[0].[0].arg[0].value.[1].arg[0].value", fallback: "Settings"))
                .font(.title)
                Spacer()
            
            HStack {
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .frame(width: __designTimeInteger("#6793.[4].[6].property.[0].[0].arg[0].value.[3].arg[0].value.[0].[0].[0].modifier[1].arg[0].value", fallback: 200), height: __designTimeInteger("#6793.[4].[6].property.[0].[0].arg[0].value.[3].arg[0].value.[0].[0].[0].modifier[1].arg[1].value", fallback: 200))
                }
                
                Button {
                    // show image picker
                    isPickerShowing = __designTimeBoolean("#6793.[4].[6].property.[0].[0].arg[0].value.[3].arg[0].value.[1].arg[0].value.[0].[0]", fallback: true)
                    
                } label: {
                    Text(__designTimeString("#6793.[4].[6].property.[0].[0].arg[0].value.[3].arg[0].value.[1].arg[1].value.[0].arg[0].value", fallback: "Upload photo"))
                }
                
                .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                    // Image picker
                    ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                }
            }
            Text(__designTimeString("#6793.[4].[6].property.[0].[0].arg[0].value.[4].arg[0].value", fallback: "Buffer time"))
                .font(.title3)
            TextField(__designTimeString("#6793.[4].[6].property.[0].[0].arg[0].value.[5].arg[0].value", fallback: "Enter time in seconds:"), text: $bufferTimeAmnt)
                .focused($focusedField, equals: .int)
                .keyboardType(.numberPad)
            
            
            Text(__designTimeString("#6793.[4].[6].property.[0].[0].arg[0].value.[6].arg[0].value", fallback: "Timer clock"))
                .font(.title3)
            TextField(__designTimeString("#6793.[4].[6].property.[0].[0].arg[0].value.[7].arg[0].value", fallback: "Enter time in minutes:"), text: $timerClockAmnt)
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .int)
            Spacer()
        }
        .textFieldStyle(.roundedBorder)
        .frame(width: __designTimeInteger("#6793.[4].[6].property.[0].[0].modifier[1].arg[0].value", fallback: 200))
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Spacer()
            }
            ToolbarItem(placement: .keyboard) {
                Button {
                    focusedField = nil
                } label: {
                    Image(systemName: __designTimeString("#6793.[4].[6].property.[0].[0].modifier[2].arg[0].value.[1].arg[1].value.[0].arg[1].value.[0].arg[0].value", fallback: "keyboard."))
                }
            }
        }
    
#sourceLocation()
    }
}

extension ButtonGroupView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/cristiisaula/Desktop/Gestures2/Gestures2/ContentView.swift", line: 78)
        VStack {
            ForEach(actions, id: \.self) { action in
                NavigationLink(destination: OtherView(selection: action)) {
                    Text(action.rawValue)
                        .font(.headline)
                        .frame(minWidth: __designTimeInteger("#6793.[3].[1].property.[0].[0].arg[0].value.[0].arg[2].value.[0].arg[1].value.[0].modifier[1].arg[0].value", fallback: 0), maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(__designTimeInteger("#6793.[3].[1].property.[0].[0].arg[0].value.[0].arg[2].value.[0].arg[1].value.[0].modifier[5].arg[0].value", fallback: 10))
                }.padding(.bottom)
            }
        }.padding()
    
#sourceLocation()
    }
}

extension ContentView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/cristiisaula/Desktop/Gestures2/Gestures2/ContentView.swift", line: 22)
        NavigationView {
            VStack {
                Spacer()

                Text(__designTimeString("#6793.[2].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[0].value", fallback: "Welcome to Justure"))
                    .font(.largeTitle)
                    .bold()
                    .padding()

                Spacer()

                ButtonGroupView()

                Spacer()

                NavigationLink(destination: ScratchView()) {
                    Text(__designTimeString("#6793.[2].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[5].arg[1].value.[0].arg[0].value", fallback: "iScratch"))
                        .font(.headline)
                        .frame(minWidth: __designTimeInteger("#6793.[2].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[5].arg[1].value.[0].modifier[1].arg[0].value", fallback: 0), maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .cornerRadius(__designTimeInteger("#6793.[2].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[5].arg[1].value.[0].modifier[5].arg[0].value", fallback: 10))
                }.padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Button(action: {
                                isSettingsViewShown = __designTimeBoolean("#6793.[2].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[5].modifier[2].arg[0].value.[0].arg[1].value.[0].arg[0].value.[0].arg[0].value.[0].[0]", fallback: true)
                            }) {
                                Image(systemName: __designTimeString("#6793.[2].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[5].modifier[2].arg[0].value.[0].arg[1].value.[0].arg[0].value.[0].arg[1].value.[0].arg[0].value", fallback: "gear"))
                                    .font(.title)
                            }
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text(__designTimeString("#6793.[2].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[5].modifier[2].arg[0].value.[1].arg[1].value.[0].arg[0].value", fallback: "Justure"))
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
    
#sourceLocation()
    }
}

import enum Gestures2.SelectedOption
import struct Gestures2.ContentView
import struct Gestures2.ButtonGroupView
import struct Gestures2.SettingsView
import struct Gestures2.ContentView_Previews

