//
//  ScratchView.swift
//  Gestures2
//
//  Created by Qiwei on 10/12/23.
//

import SwiftUI

struct ScratchView: View {
    @State var onFinish: Bool = false
    var body: some View {
        
        VStack{
            
            ScratchCardView(cursorSize: 50, onFinish: $onFinish){
                
                VStack{
                    Image("treehouse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(10)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                
            } overlayView: {
                
                
                Image("pattern")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
    
    
    struct ScratchView_Previews: PreviewProvider {
        static var previews: some View {
            ScratchView()
        }
    }
    
    struct ScratchCardView<Content: View,overlayImage:View>: View {
        
        var content: Content
        var overlayView: overlayImage
        
        init(cursorSize: CGFloat, onFinish: Binding<Bool>, @ViewBuilder content: @escaping ()->Content, @ViewBuilder overlayView: @escaping()->overlayImage){
            self.content = content()
            self.overlayView = overlayView()
            self.cursorSize = cursorSize
            self._onFinish = onFinish
        }
        
        @State var startingPoint: CGPoint = .zero
        @State var points: [CGPoint] = []
        
        @GestureState var gestureLocation: CGPoint = .zero
        
        var cursorSize: CGFloat
        @Binding var onFinish: Bool
        
        var body: some View{
            
            ZStack{
                overlayView
                
                content
                    .mask(ScratchMask(points: points, startingPoint: startingPoint)
                        .stroke(style: StrokeStyle(lineWidth: cursorSize, lineCap: .round, lineJoin: .round)))
                    .gesture(
                       DragGesture()
                          .onChanged { value in
                              if self.startingPoint == .zero {
                                  withAnimation {
                                      self.startingPoint = value.location
                                  }
                                  // Start the timer for regrowing
                                  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                      withAnimation {
                                          self.points = []
                                          self.startingPoint = .zero
                                      }
                                  }
                              }
                              self.points.append(value.location)
                          }
                    )
            }
            .frame(width: 300, height: 300)
            .cornerRadius(20)
        }
        
    }
    
    //scratch mask
    struct ScratchMask: Shape {
        var points:[CGPoint]
        var startingPoint: CGPoint
        
        func path(in rect: CGRect) -> Path{
            return Path{path in
                path.move(to:startingPoint)
                path.addLines(points)
            }
        }
    }
}
