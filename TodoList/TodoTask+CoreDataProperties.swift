//
//  TodoTask+CoreDataProperties.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 02.04.2025.
//
//

import Foundation
import CoreData


extension TodoTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoTask> {
        return NSFetchRequest<TodoTask>(entityName: "TodoTask")
    }

    @NSManaged public var id: UUID
    @NSManaged public var isCompleted: Bool
    @NSManaged public var name: String
    @NSManaged public var dueDate: Date
    @NSManaged public var priority: Int16

}

extension TodoTask : Identifiable {

}
