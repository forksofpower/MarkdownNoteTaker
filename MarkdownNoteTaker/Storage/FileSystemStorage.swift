//
//  FileSystemStorage.swift
//  MarkdownNoteTaker
//
//  Created by Patrick Jones on 10/4/25.
//

import Foundation
internal import UniformTypeIdentifiers

class FileSystemStorage: NoteStorage {
    private let fileManager = FileManager.default
    private var notesDirectory: URL
    
    
    init() {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        notesDirectory = documentsPath.appendingPathComponent("MarkdownNotes")
        
        if !fileManager.fileExists(atPath: notesDirectory.path) {
            try? fileManager.createDirectory(at: notesDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func loadNotes() -> [Note] {
        do {
            let fileUrls = try fileManager.contentsOfDirectory(at: notesDirectory, includingPropertiesForKeys: nil)
            return fileUrls
                .filter { $0.pathExtension == "md" || $0.pathExtension == "txt" }
                .compactMap { url in
                    guard let content = try? String(contentsOf: url, encoding: .utf8) else { return nil }
                    let title = url.deletingPathExtension().lastPathComponent
                        
                    return Note(id: UUID(), title: title, content: content)
                }
        } catch {
            print("Error loading notes: \(error)")
            return []
        }
    }
    
    func createNote(title: String) -> Note {
        // create empty markdown file
        let newNote = Note(id: UUID(), title: title, content: "")

        do {
            try save(note: newNote)
        } catch {
            print("Error creating note file: \(error)")
        }
        
        return newNote
    }
    
    func rename(title: String, note: Note) throws {
        let oldFileUrl = getFileURL(title: note.title)
        let newFileUrl = getFileURL(title: title)
        
        if fileManager.fileExists(atPath: oldFileUrl.path) {
            try? fileManager.moveItem(at: oldFileUrl, to: newFileUrl)
            print("File renamed:\n\tfrom: \(note.title)\n\tto: \(title)")
        }
    }
    
    func save(note: Note) throws {
        let fileURL = getFileURL(title: note.title)
        try note.content.write(to: fileURL, atomically: true, encoding: .utf8)
    }
    
    func save(notes: [Note]) throws {
        do {
            for note in notes {
                try save(note: note)
            }
        } catch {
            print("Error saving notes: \(error)")
        }
    }
    
    func delete(note: Note) throws {
        let fileURL = getFileURL(title: note.title)
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(at: fileURL)
        }
    }
    
    func getFileURL(title: String) -> URL {
        return notesDirectory.appendingPathComponent("\(title)").appendingPathExtension("md")
    }
}
