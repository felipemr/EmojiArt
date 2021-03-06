//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Felipe Marques Ramos on 22/05/21.
//

import SwiftUI


struct OptionalImage : View {
    
    var uiImage: UIImage?
    
    var body: some View{
        Group{
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
    
}

struct OptionalImage_Previews: PreviewProvider {
    static var previews: some View {
        OptionalImage()
    }
}
