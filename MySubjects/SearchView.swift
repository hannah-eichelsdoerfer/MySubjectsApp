//
//  SearchView.swift
//  MySubjects
//
//  Created by Hannah on 28/4/2023.
//

import SwiftUI
import CoreData

struct SearchView: View {
    var courseName: String
    var viewContext: NSManagedObjectContext
    @State var matches: [Courses]?
    
    
    var body: some View {
        List {
            ForEach (matches ?? []) { match in
                Text(match.name ?? "No name")
            }
        }
        .navigationTitle("Search Results")
        .task {
            let fetchRequest: NSFetchRequest<Courses> = Courses.fetchRequest()
            fetchRequest.entity = Courses.entity()
            fetchRequest.predicate = NSPredicate (format: "name contains %@", courseName)
            matches = try? viewContext.fetch(fetchRequest)
        }
    }
}
