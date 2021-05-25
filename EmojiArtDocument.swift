//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Felipe Marques Ramos on 17/05/21.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject {
    static let pallete = "👾🕹🎮❤️🍻🪙🎲"
    private static let untitled = "EmojiArtDocument.Untitled"
    @Published private var emojiArt = EmojiArt()
    
    private var autosavesCancellabe : AnyCancellable?
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        autosavesCancellabe = $emojiArt.sink(receiveValue: { emojiArt in
            print("jjson : \(emojiArt.json!)")
            UserDefaults.standard.set(emojiArt.json,forKey: EmojiArtDocument.untitled)
        })
        fetchBackgroundImageDate()
    }
    
    @Published private(set) var backgroundImage : UIImage?
    
    var emojis : [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK - Intents
    func addEmoji(_ emoji: String, at location: CGPoint,size: CGFloat){
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize){
        if let index = emojiArt.emojis.firstIndex(matching: emoji){
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)

        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat){
        if let index = emojiArt.emojis.firstIndex(matching: emoji){
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size)*scale).rounded(.toNearestOrEven))
        }
    }
    
    var backgroundURL: URL?{
        get{
            emojiArt.backgroundURL
        }
        set{
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageDate()
        }
    }
    
    private var fetchImageCancellable : AnyCancellable?
    private func fetchBackgroundImageDate(){
        backgroundImage = nil
        if let url = emojiArt.backgroundURL{
//            DispatchQueue.global(qos: .userInitiated).async {
//                if let imageData = try? Data(contentsOf: url){
//                    DispatchQueue.main.async {
//                        if url == self.emojiArt.backgroundURL{
//                            self.backgroundImage = UIImage(data: imageData)
//                        }
//                    }
//                }
//            }
            fetchImageCancellable?.cancel()
            let session = URLSession.shared
            let publisher = session.dataTaskPublisher(for: url)
                .map { data, urlResponse in UIImage(data: data)}
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
            fetchImageCancellable = publisher.assign(to: \.backgroundImage, on: self)
        }
    }
}

extension EmojiArt.Emoji{
    var fontSize: CGFloat{ CGFloat(self.size)}
    var location: CGPoint{ CGPoint(x: self.x, y: self.y)}
    
}
