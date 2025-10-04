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
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: getFileURL())
            let items = try decoder.decode([Note].self, from: data)
            notes = items
        } catch {
            print("Error: \(error)")
        }
        
    }
    
    func saveNotes() {
        let encoder = JSONEncoder()
        let fileURL = getFileURL()
        
        // JSONEncoder options
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try encoder.encode(notes)
            try jsonData.write(to: fileURL)
            
            print("Data saved to file : \(fileURL.path)")
            
        } catch {
            print("Error : \(error)")
        }
    }
    
    private func getFileURL() -> URL {
        let fileManager = FileManager.default
        let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = documentsDir.appendingPathComponent("notes.json")
        
        return fileUrl
    }
}
