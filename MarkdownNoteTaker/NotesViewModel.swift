//
//  NotesViewModel.swift
//  MarkdownNoteTaker
//
//  Created by Patrick Jones on 10/3/25.
//

import Foundation
internal import Combine
internal import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = [] {
        didSet {
            // This code runs every time a note is added, deleted, or changed
            saveNotes()
        }
    }
    
    init() {
        loadNotes()
    }
    
    func createNote() -> Note.ID {
        // Logic to add a new, empty note to the `notes` array
        let newNote = Note(id: UUID(), title: "New Note", content: "")
        notes.insert(newNote, at: 0) // Insert at the top of the list
        
        return newNote.id // Return the ID of the new note
    }
    
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
    
    func deleteNote(with id: UUID) {
        if let index = notes.firstIndex(where: { $0.id == id }) {
            notes.remove(at: index)
        }
    }
    
    func loadNotes() {
        // Load notes from disk
        self.notes = [Note(id: UUID(), title: "Testing", content: "# Testing a thing")]
    }
    
    func saveNotes() {
        // Logic to encode the `notes` array to json and write to a file
    }
}
