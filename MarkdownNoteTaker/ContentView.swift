//
//  ContentView.swift
//  MarkdownNoteTaker
//
//  Created by Patrick Jones on 10/3/25.
//
import MarkdownUI
import SwiftUI

extension UUID: @retroactive RawRepresentable {
    public var rawValue: String {
        self.uuidString
    }
    public typealias RawValue = String
    
    public init?(rawValue: RawValue) {
        self.init(uuidString: rawValue)
    }
}

struct ContentView: View {
    @StateObject private var viewModel = NotesViewModel()
    @AppStorage("selectedNoteId") private var selectedNoteID: Note.ID?
    @AppStorage("showPreview") private var showPreview: Bool = true
    
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
                
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        withAnimation {
                            showPreview.toggle()
                        }
                    }) {
                        Label(
                            showPreview ? "Hide Preview" : "Show Preview",
                            systemImage: showPreview ? "document.circle.fill" : "document.circle")
                    }
                }
            }
        } detail: {
            if let selectedNoteID, let noteIndex = viewModel.notes.firstIndex(where: { $0.id == selectedNoteID }) {
                // Create a binding to the note's content
                let noteBinding = $viewModel.notes[noteIndex]
                HStack(alignment: .top) {
                    // editor
                    VStack {
                        TextEditor(text: noteBinding.content)
                            .navigationTitle(noteBinding.title)
                    }
                    
                    // markdown preview
                    if showPreview {
                        ScrollView {
                            Markdown(noteBinding.content.wrappedValue)
                                .markdownTheme(.gitHub)
                                .padding()
                                .frame(minWidth: 200)
                        }.transition(.slide)
                        
                    }
                }
                .animation(.default, value: showPreview)
                
            } else {
                Text("Select a note to begin.")
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
