//
//  Spinning.swift
//  EmojiArt
//
//  Created by Felipe Marques Ramos on 24/05/21.
//

import SwiftUI

struct Spinning: ViewModifier {
    @State var isVisible: Bool = false
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: isVisible ? 360 : 0))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false))
            .onAppear{isVisible.toggle()}
    }
}

extension View{
    func spinning()-> some View{
        self.modifier(Spinning())
    }
}
