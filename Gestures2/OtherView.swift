//
//  OtherView.swift
//  Gestures2
//
//  Created by Qiwei on 10/12/23.
//

import SwiftUI


struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}

struct OtherView: View {
    let selection: SelectedOption
    //manual setting for now
    var viewCleared: Bool = false

    var body: some View {
        
        VStack{
            
            Text("You selected \(selection.rawValue)")
            
            ZStack{
                Image("treehouse")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                
                if !viewCleared{
                    Rectangle()
                        .fill(Color.green)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                //entire vstack is the camera
                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        CameraView()
                            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 4)
                            .cornerRadius(20)
                            .padding()
                    }
                }
                //camera ends
                
                
            }
            
        }
        
        
    }
}
