//
//  NoteStorage.swift
//  MarkdownNoteTaker
//
//  Created by Patrick Jones on 10/4/25.
//

import Foundation

protocol NoteStorage {
    func loadNotes() -> [Note]
    func save(note: Note) throws
    func save(notes: [Note]) throws
    func createNote(title: String) -> Note
    func delete(note: Note) throws
}
