//
//  TodoService.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    
    private init() {}
    
    private var context = CoreDataStack.shared.persistentContainer.viewContext

    private func taskExists(withName name: String) -> Bool {
        let request = TodoTask.fetchRequest()
        request.predicate = NSPredicate(format: "name == \"\(name)\"")
        
        do {
            let count = try context.count(for: request)
            
            return count > 0
        } catch {
            print("Error checking if task exists: \(error.localizedDescription)")
            
            return false
        }
    }
    
    private func getTask(by id: UUID) -> TodoTask? {
        let request = TodoTask.fetchRequest()
        request.predicate = NSPredicate(format: "id = \"\(id)\"")
        
        do {
            let fetchedTasks = try context.fetch(request)
            
            guard let task = fetchedTasks.first else {
                print("Failed to find task with id \(id)")
                
                return nil
            }
            
            return task
        } catch {
            print("Failed to get task with id \(id)")
            
            return nil
        }
    }
    
    func createTask(_ newTask: CreateTodoTaskModel) throws -> Void {
        guard !newTask.name.isEmpty else {
            throw TodoTaskError.emptyName
        }
        guard !taskExists(withName: newTask.name) else {
            throw TodoTaskError.duplicateTask
        }
        
        let task = TodoTask(context: context)
        task.id = UUID()
        task.name = newTask.name
        
        do {
            try context.save()
            
            print("Task created")
        } catch {
            print("Failed to create task: \(error.localizedDescription)")
            
            throw TodoTaskError.failedToSaveTask
        }
    }
    
    func editTask(_ task: EditTodoTaskModel) throws -> Void {
        guard !task.name.isEmpty else {
            throw TodoTaskError.emptyName
        }
        guard let taskToEdit = getTask(by: task.id) else {
            throw TodoTaskError.taskNotFound
        }
        
        taskToEdit.name = task.name
        taskToEdit.isCompleted = task.isCompleted
        
        do {
            try context.save()
            
            print("Task edited")
        } catch {
            print("Failed to edit task: \(error.localizedDescription)")
            
            throw TodoTaskError.failedToSaveTask
        }
    }
    
    func deleteTask(by id: UUID) throws -> Void {
        do {
            guard let taskToDelete = getTask(by: id) else {
                throw TodoTaskError.taskNotFound
            }
            
            context.delete(taskToDelete)
            
            try context.save()
            
            print("Task deleted")
        } catch {
            print("Failed to delete task: \(error.localizedDescription)")
            
            throw TodoTaskError.failedToDeleteTask
        }
    }
    
    func getTasks() throws -> [TodoTask] {
        do {
            let tasks = try context.fetch(TodoTask.fetchRequest())
            
            return tasks
        } catch {
            print("Failed to get tasks: \(error.localizedDescription)")
            
            throw TodoTaskError.failedToGetTasks
        }
    }
}
