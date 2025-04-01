//
//  TodoTask+CoreDataProperties.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//
//

import Foundation
import CoreData


extension TodoTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoTask> {
        return NSFetchRequest<TodoTask>(entityName: "TodoTask")
    }

    @NSManaged public var name: String?
    @NSManaged public var finished: Bool
    @NSManaged public var id: UUID?

}

extension TodoTask : Identifiable {

}
