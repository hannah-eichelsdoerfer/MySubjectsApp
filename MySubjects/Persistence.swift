//
//  Persistence.swift
//  MySubjects
//
//  Created by Hannah on 28/4/2023.
//

import CoreData

struct PersitenceController {
    static let shared = PersitenceController()
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "Subjects")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Container load failed: \(error)")
            }
        }
    }
}
