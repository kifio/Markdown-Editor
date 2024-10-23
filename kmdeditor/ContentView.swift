//
//  ContentView.swift
//  kmdeditor
//
//  Created by Иван Мурашов on 21.10.2024.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @Binding var document: kmdeditorDocument
    @State private var previewState = PreviewState.web

    var body: some View {
        HSplitView {
            TextEditor(text: $document.text)
                .frame(minWidth: 200)
            if PreviewState.web == previewState {
                WebView(html: document.html)
                    .frame(minWidth: 200)
            } else if PreviewState.code == previewState {
                ScrollView {
                    Text(document.html)
                        .frame(minWidth: 200)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .topLeading
                        )
                        .padding()
                        .textSelection(.enabled)
                }
            }
        }
        .frame(
            minWidth: 400,
            idealWidth: 600,
            maxWidth: .infinity,
            minHeight: 300,
            idealHeight: 400,
            maxHeight: .infinity
        )
        .toolbar {
            ToolbarItem {
                Picker("", selection: $previewState) {
                    Image(systemName: "network")
                        .tag(PreviewState.web)
                    Image(systemName: "chevron.left.forwardslash.chevron.right")
                        .tag(PreviewState.code)
                    Image(systemName: "nosign")
                        .tag(PreviewState.off)
                }
                .pickerStyle(.segmented)
                .help("Hide preview, show HTML or web view")
            }
        }
    }
}

enum PreviewState {
    case web
    case code
    case off
}

struct WebView: NSViewRepresentable {
    var html: String
    
    init(html: String) {
        self.html = html
    }
    
    func makeNSView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
    }
}
