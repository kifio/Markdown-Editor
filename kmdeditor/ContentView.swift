//
//  ContentView.swift
//  kmdeditor
//
//  Created by Иван Мурашов on 21.10.2024.
//

import SwiftUI
import WebKit

@main
struct kmdeditorApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: kmdeditorDocument()) { file in
            ContentView(document: file.$document)
        }
        .commands { MenuCommands() }
    }
}

struct ContentView: View {
    
    
    @AppStorage("editorFontSize")
    var editorFontSize: Double = 14
    
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
        .font(.system(size: editorFontSize))
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
    @AppStorage("styleSheet")
    var styleSheet: StyleSheet = .raywenderlich
    
    var html: String
    
    var formattedHtml: String {
        return """
            <html>
            <head>
               <link href="\(styleSheet).css" rel="stylesheet">
            </head>
            <body>
               \(html)
            </body>
            </html>
            """
    }
    
    init(html: String) {
        self.html = html
    }
    
    func makeNSView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.loadHTMLString(formattedHtml, baseURL: Bundle.main.resourceURL)
    }
}

struct MenuCommands: Commands {
    
    @AppStorage("styleSheet")
    var styleSheet: StyleSheet = .raywenderlich
    
    @AppStorage("editorFontSize")
    var editorFontSize: Double = 14
    
    var body: some Commands {
        CommandMenu("Display") {
            ForEach(StyleSheet.allCases, id: \.self) { style in
                Button {
                    styleSheet = style
                } label: {
                    Text(style.rawValue)
                }
                
            }
            
            Divider()
            
            Menu("Font Size") {
                Button("Smaller") {
                    if editorFontSize > 8 {
                        editorFontSize -= 1
                    }
                }
                .keyboardShortcut("-")
                
                Button("Reset") {
                    editorFontSize = 14
                }
                .keyboardShortcut("0")
                
                Button("Larger") {
                    editorFontSize += 1
                }
                .keyboardShortcut("+")
            }
        }
        
//        CommandGroup(replacing: .help) {
//            NavigationLink(
//        }
    }
}
