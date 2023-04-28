//
//  CourseView.swift
//  MySubjects
//
//  Created by Hannah on 28/4/2023.
//

import SwiftUI
import CoreData

/// Course View is used to manage the assessments of individual courses
struct CourseView: View {
    var course: Courses
    var viewContext: NSManagedObjectContext
    @State var assessments: [Assessment]?
    @State var assessmentName: String = ""
    @State var assessmentWeight: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Assessment Name:", text: $assessmentName).padding()
                Spacer()
                TextField("Assessment Weight:", text: $assessmentWeight).padding()
                Spacer()
            }
            HStack {
                Spacer()
                Button("Add") {
                    addAssessment()
                    fetchAssessment()
                }
                Spacer()
                Button("Clear") {
                    assessmentName = ""
                    assessmentWeight = ""
                }
                Spacer()
            }
            Text("Assignments:").padding()
            List {
                ForEach(assessments ?? []) { assessment in
                    Text("\(assessment.name ?? "no name") \(assessment.weight)%")
                }
            }
        }
        .navigationTitle("\(course.name ?? "no name")")
        .task{fetchAssessment()}
    }
}

extension CourseView {
    // addAssessment() is used to add a new assessment to the course
    private func addAssessment() {
        guard let weight = Int16(assessmentWeight) else {
            return
        }
        
        withAnimation {
            let assessment = Assessment(context: viewContext)
            assessment.name = assessmentName
            assessment.weight = weight
            assessment.belongsto = course
            saveContext(viewContext)
        }
    }
    // to fetch all the assignments belonging to the course
    private func fetchAssessment() {
        let fetchRequest: NSFetchRequest<Assessment> = Assessment.fetchRequest()
        fetchRequest.entity = Assessment.entity()
        fetchRequest.predicate = NSPredicate (
            format: "belongsto = %@", course
        )
        assessments = try? viewContext.fetch(fetchRequest)
    }
}

fileprivate func saveContext(_ viewContext: NSManagedObjectContext) {
    do {
        try viewContext.save()
    } catch {
        let error = error as NSError
        fatalError("An error occured during save: \(error)")
    }
}
