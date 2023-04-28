//
//  ContentView.swift
//  MySubjects
//
//  Created by Hannah on 28/4/2023.
//

import SwiftUI
import CoreData // 1. Import CoreData

struct ContentView: View {
    @Environment (\.managedObjectContext) private var viewContext // through environment get view context
    @State var courseName: String = "" // @State variable is courseName
    @FetchRequest(entity: Courses.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) // all courses are fetched and stored in Courses (sortDescriptors: To make the courses listed in specified sorted order)
    private var courses: FetchedResults<Courses>
    
    // Where is the body? -> in extension of ContentView
    
    // two private functions addCourse() and saveContext()
    private func addCourse() { // could be put in a better place
        withAnimation {
            let course = Courses(context: viewContext)
            course.name = courseName
            saveContext()
        }
    }
    
    private func deleteCourse(idx: IndexSet) {
        withAnimation {
            idx.map{courses[$0]}.forEach { course in
                viewContext.delete(course)
            }
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("An error occured during save \(error)")
        }
        
    }
}

// To improve the readability, body section of ContentView is put into extension
extension ContentView {
    var body: some View {
        NavigationView {
            VStack {
                TextField("Course Name", text: $courseName).padding()
                
                HStack {
                    Spacer()
                    Button("Add") {
                        addCourse()
                        courseName = ""
                    }
                    Spacer()
                    NavigationLink("Search") {
                        SearchView(courseName: courseName, viewContext: viewContext)
                    }
                    Spacer()
                    Button("Clear") {
                        courseName = ""
                    }
                    Spacer()
                }
                
                List {
                    ForEach(courses) { course in
                        Text(course.name ?? "unknown course name")
                        
                    }.onDelete(perform: deleteCourse)
                }
            }.navigationTitle("My Courses")
        }
    }
}


