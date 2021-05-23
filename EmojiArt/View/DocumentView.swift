//
//  DocumentView.swift
//  EmojiArt
//
//  Created by Felipe Marques Ramos on 17/05/21.
//

import SwiftUI

struct DocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                HStack{
                    ForEach(EmojiArtDocument.pallete.map({String($0)}),id: \.self ){emoji in
                        Text(emoji)
                            .font(Font.system(size: emojiFontSize))
                            .onDrag({ return NSItemProvider(object: emoji as NSString) })
                    }
                }
            }
            .padding(.horizontal)
            
            GeometryReader{ geometry in
                ZStack{
                    Color.gray.overlay(
                        OptionalImage(uiImage: document.backgroundImage).scaleEffect(zoomScale)
                            .gesture(doubleTapToZoom(in: geometry.size))
                            .offset(panOffset)
                    )
                        
                    
                    
                    ForEach(document.emojis){ emoji in
                        Text(emoji.text)
                            .font(animatableWithSize: emoji.fontSize * zoomScale)
                            .position(position(for: emoji, in: geometry.size))
                    }
                }
                .clipped()
                .gesture(panGesture())
                .gesture(zoomGesture())
                .edgesIgnoringSafeArea([.horizontal,.bottom])
                .onDrop(of: ["public.image","public.text"], isTargeted: nil, perform: { providers, location in
                    var fixedLocation = geometry.convert(location, from: .global)
                fixedLocation = CGPoint(x: fixedLocation.x - geometry.size.width/2, y: fixedLocation.y - geometry.size.height/2)
                    fixedLocation = CGPoint(x: fixedLocation.x - panOffset.width, y: fixedLocation.y - panOffset.height)
                    fixedLocation = CGPoint(x: fixedLocation.x/zoomScale, y: fixedLocation.y/zoomScale)
                    return self.drop(providers: providers, at: fixedLocation)
                })
                
            }
            
        }
        
        
    }
    @State private var steadyZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale : CGFloat = 1.0
    
    private var zoomScale: CGFloat{
        steadyZoomScale * gestureZoomScale
    }
    
    private let emojiFontSize: CGFloat = 45
    
    private func drop(providers: [NSItemProvider], at location : CGPoint)->Bool{
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.document.setBackgroundURL(url)
        }
        if !found {
            found = providers.loadObjects(ofType: String.self, using: { string in
                self.document.addEmoji(string, at: location, size: self.emojiFontSize)
            })
        }
        return found
    }
    

    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize)->CGPoint{
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2 )
        location = CGPoint(x: location.x + panOffset.width , y: location.y + panOffset.height)
        return location
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize){
        if let image = image, image.size.width > 0, image.size.height>0{
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyZoomScale = min(hZoom, vZoom)
        }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture{
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomGesture() -> some Gesture{
        MagnificationGesture()
            .updating($gestureZoomScale, body: { latestGestureScale, ourGestureStateInOut, transaction in
                print("updating :  \(gestureZoomScale)")
                ourGestureStateInOut = latestGestureScale
            })
            .onEnded { finalGestureScale in
                print("end : \(gestureZoomScale)")
                steadyZoomScale *= finalGestureScale
            }
    }
    
    
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gestureStatePanOffset: CGSize = .zero
    
    private var panOffset: CGSize{
        (steadyStatePanOffset + gestureStatePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture{
        DragGesture()
            .updating($gestureStatePanOffset) { latesteDragGestureValue, ourGestureStateInOut, transaction in
                ourGestureStateInOut = latesteDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragValue.translation / zoomScale)
            }
    }
}
