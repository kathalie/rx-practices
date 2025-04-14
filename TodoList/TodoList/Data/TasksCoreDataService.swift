//
//  TodoService.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import CoreData
import Combine

class TasksCoreDataService {
    static let shared = TasksCoreDataService()
    
    @Published var sortOption: SortOption = .allFields
    @Published var searchText: String = ""
    @Published var error: String?
    
    private init() {}
    
    private(set) var context = CoreDataStack.shared.persistentContainer.viewContext

    private func handleError(_ error: Error) {
        self.error = (error as? TodoTaskError)?.rawValue ?? "Something went wrong"
    }
    
    private func taskExists(withName name: String) -> Bool? {
        let request = TodoTask.fetchRequest()
        request.predicate = NSPredicate(format: "name == \"\(name)\"")
        
        do {
            let count = try context.count(for: request)
            
            return count > 0
        } catch {
            print("Error checking if task exists: \(error.localizedDescription)")
            
            return nil
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
    
    private func _createTask(_ newTask: CreateTodoTaskModel) throws -> Void {
        guard !newTask.name.isEmpty else { throw TodoTaskError.emptyName
        }
        
        let taskExists = taskExists(withName: newTask.name)
        guard let taskExists else { throw TodoTaskError.taskNotFound }
        guard !taskExists else { throw TodoTaskError.duplicateTask }
        
        let _ = newTask.toEntity(context: context)
        
        do {
            try context.save()
            
            print("Task created")
        } catch {
            print("Failed to create task: \(error.localizedDescription)")
            
            throw TodoTaskError.failedToSaveTask
        }
    }
    
    func createTask(_ newTask: CreateTodoTaskModel) -> Void {
        do {
            try _createTask(newTask)
        } catch {
            handleError(error)
        }
    }
    
    private func _editTask(_ task: EditTodoTaskModel) throws -> Void {
        guard !task.name.isEmpty else { throw TodoTaskError.emptyName }
        guard let taskToEdit = getTask(by: task.id) else { throw TodoTaskError.taskNotFound }

        task.update(taskToEdit)
        
        do {
            try context.save()
            
            print("Task edited")
        } catch {
            print("Failed to edit task: \(error.localizedDescription)")
            
            throw TodoTaskError.failedToSaveTask
        }
    }
    
    func editTask(_ task: EditTodoTaskModel) -> Void {
        do {
            try _editTask(task)
        } catch {
            handleError(error)
        }
    }
    
    private func _deleteTask(by id: UUID) throws -> Void {
        do {
            guard let taskToDelete = getTask(by: id) else { throw TodoTaskError.taskNotFound }
            
            context.delete(taskToDelete)
            
            try context.save()
            
            print("Task deleted")
        } catch {
            print("Failed to delete task: \(error.localizedDescription)")
            
            throw TodoTaskError.failedToDeleteTask
        }
    }
    
    func deleteTask(by id: UUID) -> Void {
        do {
            try _deleteTask(by: id)
        } catch {
            handleError(error)
        }
    }
    
    private func getTasks(sortOption: SortOption, searchText: String) throws -> [TodoTask] {
        do {
            let request = TodoTask.fetchRequest()
            if !searchText.isEmpty {
                request.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
            }
            request.sortDescriptors = sortOption.sortDescriptors

            let tasks = try context.fetch(request)
            
            return tasks
        } catch {
            print("Failed to get tasks: \(error.localizedDescription)")
            
            throw TodoTaskError.failedToGetTasks
        }
    }
    
    func getTasksPublisher(sortOption: SortOption, searchText: String) -> AnyPublisher<[TodoTask], Never> {
        let tasksUpdatedPublisher = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: context)

        return Publishers.CombineLatest3(tasksUpdatedPublisher, $searchText, $sortOption)
            .map {[weak self] _, searchText, sortOption in
                guard let self else {return []}
                
                do {
                    return try self.getTasks(sortOption: sortOption, searchText: searchText)
                } catch {
                    self.handleError(error)
                    
                    return []
                }
            }
            .eraseToAnyPublisher()
    }
}
