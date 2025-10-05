//
//  FileSystemStorage.swift
//  MarkdownNoteTaker
//
//  Created by Patrick Jones on 10/4/25.
//

import Foundation

//class JSONStorage: NoteStorage {
//    // 1. It holds a reference to another storage object (the "wrapped" object).
//    private let wrappedStorage: NoteStorage
//    private let fileURL: URL
//
//    // 2. The wrapped storage (our MemoryStorage) is injected.
//    init(wrapping storage: NoteStorage) {
//        self.wrappedStorage = storage
//
//        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        self.fileURL = documentsPath.appendingPathComponent("notes.json")
//
//        // Optionally load from disk into the wrapped storage on init
//        self.loadNotes()
//    }
//
//    func loadNotes() -> [Note] {
//        // Try to load from disk, otherwise use what's in the wrapped storage.
//        do {
//            let data = try Data(contentsOf: fileURL)
//            let loadedNotes = try JSONDecoder().decode([Note].self, from: data)
//            // We need to populate the wrapped storage here.
//            for note in loadedNotes { try? wrappedStorage.save(note: note) }
//            return loadedNotes
//        } catch {
//            return wrappedStorage.loadNotes()
//        }
//    }
//
//    func createNote(title: String) -> Note {
//        // 3. First, perform the action on the in-memory store.
//        let newNote = wrappedStorage.createNote(title: title)
//        // 4. Then, add the persistence behavior.
//        try? saveAllNotes()
//        return newNote
//    }
//
//    func save(note: Note) throws {
//        try wrappedStorage.save(note: note)
//        try saveAllNotes()
//    }
//
//    func delete(note: Note) throws {
//        try wrappedStorage.delete(note: note)
//        try saveAllNotes()
//    }
//
//    // Helper to persist the state of the wrapped storage to disk.
//    private func saveAllNotes() throws {
//        let notesToSave = wrappedStorage.loadNotes()
//        let data = try JSONEncoder().encode(notesToSave)
//        try data.write(to: fileURL, options: .atomic)
//    }
//}


//import Foundation
//
class JSONStorage: NoteStorage {
    
            
    private let fileManager = FileManager.default
    private var fileURL: URL
    
    init() {
        let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsDir.appendingPathComponent("notes.json")
    }
    
    func loadNotes() -> [Note] {
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL)
            let notes = try decoder.decode([Note].self, from: data)
            return notes
        } catch {
            print("Error: \(error)")
            return []
        }
    }
    
    func save(notes: [Note]) throws {
        let encoder = JSONEncoder()
        
        // JSONEncoder options
        encoder.outputFormatting = .prettyPrinted
        
        let jsonData = try encoder.encode(notes)
        try jsonData.write(to: fileURL)
            print("Data saved to file : \(fileURL.path)")
    }
    
    func save(note: Note) throws {
        // unimplemented
    }
    
    func rename(title: String, note: Note) throws {
        // unimplemented
    }
    
    func createNote(title: String = "New Note") -> Note {
        return Note(id: UUID(), title: title, content: "")
    }
    
    func delete(note: Note) throws {
        // unimplemented
    }
    
}
