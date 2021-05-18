//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Felipe Marques Ramos on 17/05/21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            DocumentView(document: EmojiArtDocument())
        }
    }
}
