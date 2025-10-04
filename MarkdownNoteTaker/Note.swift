//
//  Note.swift
//  MarkdownNoteTaker
//
//  Created by Patrick Jones on 10/3/25.
//

import Foundation

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var content: String
}
