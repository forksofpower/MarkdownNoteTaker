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
    @StateObject private var viewModel: NotesViewModel
    
    @AppStorage("selectedNoteId") private var selectedNoteID: Note.ID?
    @AppStorage("showPreview") private var showPreview: Bool = true
    @State private var showCreateAlert = false
    @State private var showRenameAlert = false
    @State var newNoteTitle = ""

    init() {
//        let storage = JSONStorage()
        let storage = FileSystemStorage() // uncomment for markdown file based storage
        _viewModel = StateObject(wrappedValue: NotesViewModel(storage: storage))
    }
    
    var body: some View {
        NavigationSplitView {
            List(selection: self.$selectedNoteID) {
                ForEach(self.viewModel.notes) { note in
                    Text(note.title)
                        .tag(note.id)
                        .contextMenu {
                            Button(role: .destructive, action: {
                                self.viewModel.deleteNote(with: note.id)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }.onDelete(perform: self.viewModel.deleteNote)
            }.toolbar {
                ToolbarItem {
                    Button(action: {
                        showCreateAlert = true
                    }) {
                        Label("New Note", systemImage: "plus")
                    }
                    .alert("New Note", isPresented: $showCreateAlert) {
                        TextField("Note Title", text: $newNoteTitle)
                        Button("Create") {
                            self.selectedNoteID = self.viewModel.createNote(title: newNoteTitle)
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                }
                
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        withAnimation {
                            self.showPreview.toggle()
                        }
                    }) {
                        Label(
                            self.showPreview ? "Hide Preview" : "Show Preview",
                            systemImage: self.showPreview ? "document.circle.fill" : "document.circle"
                        )
                    }
                }
                
                ToolbarItem() {
                    Button("Rename", action: {
                        print("Rename button pressed!")
                        showRenameAlert = true
                    })
                    .alert("Rename Note", isPresented: $showRenameAlert) {
                        TextField("Note Title", text: $newNoteTitle)
                        Button("Rename") {
                            self.viewModel.renameNote(title: newNoteTitle, with: selectedNoteID.unsafelyUnwrapped)
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                }
            }
        } detail: {
            if let selectedNoteID, let noteIndex = viewModel.notes.firstIndex(where: { $0.id == selectedNoteID }) {
                // Create a binding to the note's content
                let noteBinding = self.$viewModel.notes[noteIndex]
                HStack(alignment: .top) {
                    // editor
                    VStack {
                        TextEditor(text: noteBinding.content)
                            .navigationTitle(noteBinding.title)
                    }
                    
                    // markdown preview
                    if self.showPreview {
                        ScrollView {
                            Markdown(noteBinding.content.wrappedValue)
                                .markdownTheme(.gitHub)
                                .padding()
                                .frame(minWidth: 200)
                        }.transition(.slide)
                     }
                }
                .animation(.default, value: self.showPreview)
                
            } else {
                Text("Select a note to begin.")
            }
        }
    }
}

#Preview {
    ContentView()
}
