//
//  MySubjectsApp.swift
//  MySubjects
//
//  Created by Hannah on 28/4/2023.
//

import SwiftUI

@main
struct MySubjectsApp: App {
    let persistenceController = PersitenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
