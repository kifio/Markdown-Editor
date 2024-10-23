//
//  kmdeditorDocument.swift
//  kmdeditor
//
//  Created by Иван Мурашов on 21.10.2024.
//

import SwiftUI
import UniformTypeIdentifiers
import MarkdownKit

extension UTType {
    static var markdownText: UTType {
        UTType(importedAs: "me.kifio.markdown")
    }
}

struct kmdeditorDocument: FileDocument {
    
    var text: String

    var html: String {
        let md = MarkdownParser.standard.parse(text)
        return HtmlGenerator.standard.generate(doc: md)
    }
    
    init(text: String = "Hello, world!") {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.markdownText] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}
