//
//  ContentView.swift
//  kmdeditor
//
//  Created by Иван Мурашов on 21.10.2024.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: kmdeditorDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(kmdeditorDocument()))
}
