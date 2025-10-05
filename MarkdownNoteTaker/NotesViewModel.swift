//
//  NotesViewModel.swift
//  MarkdownNoteTaker
//
//  Created by Patrick Jones on 10/3/25.
//

import Foundation
import Combine
import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = [] {
        didSet {
            saveNotes()
        }
    }
    private let storage: NoteStorage
    
    init(storage: NoteStorage) {
        self.storage = storage
        self.notes = storage.loadNotes()
    }
    
    @discardableResult
    func createNote(title: String = "New Note") -> Note.ID {
        let newNote = storage.createNote(title: title)
        notes.insert(newNote, at: 0) // Insert at the top of the list
        
        return newNote.id
    }
    
    func deleteNote(at offsets: IndexSet) {
        let noteToDelete = notes[offsets.first!]
        try? storage.delete(note: noteToDelete)
        notes.remove(atOffsets: offsets)
    }
    
    func deleteNote(with id: UUID) {
        guard let noteIndex = notes.firstIndex(where: { $0.id == id }) else { return }
        let noteToDelete = notes[noteIndex]
        try? storage.delete(note: noteToDelete)
        notes.remove(at: noteIndex)
    }
    
    func renameNote(title: String, with id: UUID) {
        var note = notes.filter({$0.id == id}).first!
        print("Renaming Note in NotesViewModel")
//        guard let noteIndex = notes.firstIndex(where: { $0.id == id }) else { return }
//        let noteToRename = notes[noteIndex]
        try? storage.rename(title: title, note: note)
        note.title = title
    }
    func saveNotes() {
        do {
            try storage.save(notes: notes)
        } catch {
            print("Error saving note: \(error)")
        }
    }
}
