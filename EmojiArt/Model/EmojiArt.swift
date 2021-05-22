//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Felipe Marques Ramos on 17/05/21.
//

import Foundation

struct EmojiArt {
    var backgroundURL : URL?
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable {
        let text: String
        let id: Int
        var x: Int
        var y: Int
        var size: Int
        
        fileprivate init(text: String, id: Int, x: Int, y: Int, size: Int) {
            self.text = text
            self.id = id
            self.x = x
            self.y = y
            self.size = size
        }
    }
    
    private var uniqueEmojiId: Int = 0
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int){
        emojis.append(Emoji(text: text, id: uniqueEmojiId, x: x, y: y, size: size))
        uniqueEmojiId+=1
    }
}
