//
//  kmdeditorApp.swift
//  kmdeditor
//
//  Created by Иван Мурашов on 21.10.2024.
//

import SwiftUI

@main
struct kmdeditorApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: kmdeditorDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
