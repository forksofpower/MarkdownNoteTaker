//
//  MarkdownNoteTakerApp.swift
//  MarkdownNoteTaker
//
//  Created by Patrick Jones on 10/3/25.
//

import SwiftUI
import CoreData

@main
struct MarkdownNoteTakerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
