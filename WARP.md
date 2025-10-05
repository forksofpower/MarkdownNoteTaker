# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This repository contains the source code for MarkdownNoteTaker, a native macOS application for taking notes in Markdown. The application is built with SwiftUI and follows the Model-View-ViewModel (MVVM) architecture. It features a two-pane interface with a note list and a live Markdown editor with a toggleable preview. Notes are saved automatically to a local JSON file.

## Architecture

- **UI:** The user interface is built entirely with SwiftUI. The main view is `ContentView.swift`, which coordinates the note list and the editor view.
- **State Management:** The app uses the MVVM pattern. The `NotesViewModel.swift` class acts as the ViewModel, managing the state of the notes and handling user interactions. The `Note.swift` file defines the data model for a single note.
- **Markdown Rendering:** The live preview of Markdown is rendered using the `swift-markdown-ui` library.
- **Persistence:** The persistence layer is abstracted through the `NoteStorage.swift` protocol. The primary implementation, `JSONStorage.swift`, saves all notes to a single JSON file in the app's sandboxed container.

## Common Commands

### Building the Project

To build the project, use the following command:

```bash
xcodebuild build -scheme MarkdownNoteTaker -project MarkdownNoteTaker.xcodeproj
```

### Running Tests

To run all tests, use the following command:

```bash
xcodebuild test -scheme MarkdownNoteTaker -project MarkdownNoteTaker.xcodeproj
```

To run a single test, use the `-only-testing` option with the following format:

```bash
xcodebuild test -scheme MarkdownNoteTaker -project MarkdownNoteTaker.xcodeproj -only-testing:MarkdownNoteTakerTests/MarkdownNoteTakerTests/testExample
```

Replace `testExample` with the name of the test you want to run. You can also run a specific test class by providing the class name instead of a specific test method.
