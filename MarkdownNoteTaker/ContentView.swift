//
//  ContentView.swift
//  MarkdownNoteTaker
//
//  Created by Patrick Jones on 10/3/25.
//

internal import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var selectedNoteID: Note.ID?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedNoteID) {
                ForEach(viewModel.notes) { note in
                    Text(note.title)
                        .tag(note.id)
                        .contextMenu {
                            Button(role: .destructive, action: {
                                viewModel.deleteNote(with: note.id)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }.onDelete(perform: viewModel.deleteNote)
            }.toolbar {
                ToolbarItem {
                    Button(action: {
                        selectedNoteID = viewModel.createNote()
                    }) {
                        Label("New Note", systemImage: "plus")
                    }
                }
            }
        } detail: {
            if let selectedNoteID, let noteIndex = viewModel.notes.firstIndex(where: { $0.id == selectedNoteID }) {
                // Create a binding to the note's content
                let noteBinding = $viewModel.notes[noteIndex]
                
                VStack {
                    TextField("Title", text: noteBinding.title)
                    TextEditor(text: noteBinding.content)
                }
            } else {
                Text("Select a note to begin.")
            }
        }
    }
}
