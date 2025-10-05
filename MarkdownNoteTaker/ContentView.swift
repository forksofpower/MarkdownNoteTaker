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
    @State private var noteToRename: Note?
    @State var newNoteTitle = ""

    init() {
//        let storage = JSONStorage()
        let storage = FileSystemStorage() // uncomment for markdown file based storage
        _viewModel = StateObject(wrappedValue: NotesViewModel(storage: storage))
//        NSTextView().appearance.backgroundColor = .clear
    }
    
    var body: some View {
        NavigationSplitView {
            List(selection: self.$selectedNoteID) {
                ForEach(self.viewModel.notes) { note in
                    Text(note.title)
                        .tag(note.id)
                        .contextMenu {
                            Button(action: {
                                self.noteToRename = note
                            }) {
                                Label("Rename", systemImage: "pencil")
                            }
                            Button(role: .destructive, action: {
                                self.viewModel.deleteNote(with: note.id)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }.onDelete(perform: self.viewModel.deleteNote)
            }
            .alert("Rename Note", isPresented: .constant(self.noteToRename != nil), actions: {
                TextField("Note Title", text: self.$newNoteTitle)
                Button("Rename") {
                    if let note = noteToRename {
                        self.viewModel.renameNote(title: self.newNoteTitle, with: note.id)
                    }
                    self.noteToRename = nil
                    self.newNoteTitle = ""
                }
                Button("Cancel", role: .cancel) {
                    self.noteToRename = nil
                    self.newNoteTitle = ""
                }
            })
        } detail: {
            if let selectedNoteID, let noteIndex = viewModel.notes.firstIndex(where: { $0.id == selectedNoteID }) {
                // Create a binding to the note's content
                let noteBinding = self.$viewModel.notes[noteIndex]
                HStack(alignment: .top) {
                    // editor
                    VStack {
                        TextEditor(text: noteBinding.content)
                            .font(.system(.body))
                            .padding(20)
                            .navigationTitle(noteBinding.title)
                            .background(Color.clear)
                    }
                    Divider()
                    // markdown preview
                    if self.showPreview {
                        ScrollView {
                            Markdown(noteBinding.content.wrappedValue)
                                .markdownTheme(.gitHub)
                                .padding(20)
                                .frame(minWidth: 200)
                                .background(Color.clear)
                        }.transition(.slide)
                    }
                }
                .animation(.default, value: self.showPreview)
                
            } else {
                Text("Select a note to begin.")
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    self.showCreateAlert = true
                }) {
                    Label("New Note", systemImage: "plus")
                }
                .alert("New Note", isPresented: self.$showCreateAlert) {
                    TextField("Note Title", text: self.$newNoteTitle)
                    Button("Create") {
                        self.selectedNoteID = self.viewModel.createNote(title: self.newNoteTitle)
                    }
                    Button("Cancel", role: .cancel) {}
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
        }
    }
}
        
#Preview {
    ContentView()
}
