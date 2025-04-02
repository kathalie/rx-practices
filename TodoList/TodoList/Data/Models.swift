//
//  Models.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import CoreData

enum TaskPriority: Int16, CaseIterable {
    case high = 1
    case medium = 2
    case low = 3
    
    static func getCase(with value: Int16) -> TaskPriority? {
        return TaskPriority.allCases.first(where: {value == $0.rawValue})
    }
    
    var asString: String {
        switch self {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        }
    }
}

struct CreateTodoTaskModel {
    let name: String
    let dueDate: Date
    let priority: TaskPriority
    
    init(
        name: String,
        dueDate: Date,
        priority: TaskPriority
    ) {
        self.name = name
        self.dueDate = dueDate
        self.priority = priority
    }
    
    init(from task: TodoTask) {
        self.name = task.name
        self.dueDate = task.dueDate
        self.priority = TaskPriority.getCase(with: task.priority)  ?? .low
    }
    
    func toEntity(context: NSManagedObjectContext) -> TodoTask {
        var task = TodoTask(context: context)
        
        task.id = UUID()
        task.name = self.name
        task.dueDate = self.dueDate
        task.priority = self.priority.rawValue
        task.isCompleted = false
        
        return task
    }
}

struct EditTodoTaskModel {
    let id: UUID
    let name: String
    let isCompleted: Bool
    let dueDate: Date
    let priority: TaskPriority
    
    init(
        id: UUID,
        name: String,
        isCompleted: Bool,
        dueDate: Date,
        priority: TaskPriority
    ) {
        self.id = id
        self.name = name
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.priority = priority
    }
    
    init(from task: TodoTask) {
        self.id = task.id
        self.name = task.name
        self.isCompleted = task.isCompleted
        self.dueDate = task.dueDate
        self.priority = TaskPriority.getCase(with: task.priority)  ?? .low
    }
    
    func update(_ entityToUpdate: TodoTask) {
        entityToUpdate.id = self.id
        entityToUpdate.name = self.name
        entityToUpdate.dueDate = self.dueDate
        entityToUpdate.priority = self.priority.rawValue
        entityToUpdate.isCompleted = self.isCompleted
    }
}
