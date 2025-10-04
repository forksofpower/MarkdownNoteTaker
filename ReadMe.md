# MarkdownNoteTaker 📝

A simple, native macOS application for taking notes in Markdown, built with SwiftUI. This project serves as a learning exercise for building modern, document-based macOS apps.

## Features

-   **Clean, Two-Pane Interface:** A familiar and efficient layout with a list of notes on the left and the editor on the right.
-   **Live Markdown Preview:** See a beautifully rendered preview of your Markdown content side-by-side with the editor.
-   **Toggleable Preview:** The preview pane can be hidden or shown with a toolbar button to focus on writing.
-   **Automatic Saving:** Notes are saved automatically to a local JSON file.
-   **Context Menus:** Right-click or use swipe-to-delete to manage your notes.

## Technology Stack

-   **Framework:** SwiftUI
-   **Language:** Swift
-   **Architecture:** Model-View-ViewModel (MVVM)
-   **Markdown Rendering:** [swift-markdown-ui](https://github.com/gonzalezreal/swift-markdown-ui)
-   **Persistence:** `JSONEncoder` / `FileManager`

## Future Enhancements (TODO)

The following is a list of planned features and architectural improvements to make the app more powerful and flexible.

### Storage and Vaults

-   [ ] **Individual File Storage:** Refactor the persistence layer to save each note as a separate `.md` file in a user-accessible folder, making the data transparent and portable.
-   [ ] **Vault System:** Allow users to create and manage multiple "Vaults." Each vault will represent a distinct storage location (e.g., a specific folder in `Documents`, a folder in iCloud Drive, etc.).
-   [ ] **User-Selectable Storage:** Let users choose the storage backend for each vault (e.g., a folder of `.md` files vs. a single database file).

### Search and Performance

-   [ ] **Core Data Indexing:** Implement a Core Data store that acts as a search index for file-based vaults. This will enable fast, powerful, full-text search across all notes without needing to read each file from disk during a search.

### Editor and UI

-   [ ] **Syntax Highlighting:** Add live syntax highlighting to the text editor to style Markdown characters (e.g., make `#` headings bold and larger).
-   [ ] **Theme Support:** Allow users to choose different themes for the Markdown preview, building on the `.markdownTheme()` modifier from `MarkdownUI`.

### Cross-Platform Sync

-   [ ] **iCloud Sync:** Add an iOS companion app and use iCloud (CloudKit) to sync vaults and notes between macOS and iOS devices.
