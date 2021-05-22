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
                    Color.gray.overlay(OptionalImage(uiImage: document.backgroundImage))
                    
                    ForEach(document.emojis){ emoji in
                        Text(emoji.text)
                            .font(font(for: emoji))
                            .position(position(for: emoji, in: geometry.size))
                    }
                }
                .clipped()
                .edgesIgnoringSafeArea([.horizontal,.bottom])
                .onDrop(of: ["public.image","public.text"], isTargeted: nil, perform: { providers, location in
                    var fixedLocation = geometry.convert(location, from: .global)
                fixedLocation = CGPoint(x: fixedLocation.x - geometry.size.width/2, y: fixedLocation.y - geometry.size.height/2)
                    return self.drop(providers: providers, at: fixedLocation)
                })
                
            }
            
        }
        
        
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
    
    private func font(for emoji: EmojiArt.Emoji) -> Font{
        Font.system(size: emoji.fontSize)
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize)->CGPoint{
        CGPoint(x: emoji.location.x + size.width/2, y: emoji.location.y + size.height/2 )
    }
}
