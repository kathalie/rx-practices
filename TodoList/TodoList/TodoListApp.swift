//
//  TodoListApp.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import SwiftUI

@main
struct TodoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
