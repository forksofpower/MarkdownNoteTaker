//
//  MarkdownNoteTakerTests.swift
//  MarkdownNoteTakerTests
//
//  Created by Patrick Jones on 10/3/25.
//

import Testing
@testable import MarkdownNoteTaker
import Foundation

struct MarkdownNoteTakerTests {

    @Test func testCreateNote() async throws {
        let viewModel = NotesViewModel()
        
        let initialCount = viewModel.notes.count
        
        let newNoteID = viewModel.createNote()
        
        #expect(viewModel.notes.count == initialCount + 1)
        #expect(viewModel.notes.first?.id == newNoteID)
        #expect(viewModel.notes.first?.title == "New Note")
    }

}
