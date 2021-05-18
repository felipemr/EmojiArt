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
                    }
                }
            }
            .padding(.horizontal)
            
            Color.yellow
                .edgesIgnoringSafeArea([.horizontal,.bottom])
        }
        
        
    }
    
    private let emojiFontSize: CGFloat = 45
}
