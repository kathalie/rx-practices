//
//  TodoTasksListVM.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import Combine

class TodoTaskViewModel: ObservableObject {
    let tasks = CurrentValueSubject<[TodoTask], Never>([])
    let taskErrors = PassthroughSubject<String, Never>()
    private let _taskUpdates = PassthroughSubject<Void, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    private let todoTasksService = CoreDataService.shared
        
    init() {
        bindFetchTasks()
        _taskUpdates.send()
    }
    
    private func handleTodoTaskError(_ error: TodoTaskError?) {
        let errorMessage: String
        
        switch error {
        case .duplicateTask: errorMessage = "Task with this name already exists. Please, specify another name and try again."
        case .emptyName: errorMessage = "Task name should not be empty."
        case .failedToDeleteTask: errorMessage = "Failed to delete a task."
        case .failedToGetTasks: errorMessage = "Failed to access tasks."
        case .failedToSaveTask: errorMessage = "Failed to save a task."
        case .taskNotFound: errorMessage = "Task with a specified name was not found."
        default: errorMessage = "Something went wrong."
        }
        
        taskErrors.send(errorMessage)
    }
    
    private func bindFetchTasks() {
        _taskUpdates
            .map { [weak self] in
                guard let self else { return [] }
                
                do {
                    return try self.todoTasksService.getTasks()
                } catch {
                    self.handleTodoTaskError(error as? TodoTaskError)
                    
                    return []
                }
            }
            .sink { [weak self] in self?.tasks.send($0) }
            .store(in: &bag)
    }

    func addTask(task: CreateTodoTaskModel) {
        do {
            try todoTasksService.createTask(task)
            
            _taskUpdates.send()
        } catch {
            handleTodoTaskError(error as? TodoTaskError)
        }
    }
    
    func updateTask(with newTask: EditTodoTaskModel) {
        do {
            try todoTasksService.editTask(newTask)
            
            _taskUpdates.send()
        } catch {
            handleTodoTaskError(error as? TodoTaskError)
        }
    }
    
    func deleteTask(by id: UUID) {
        do {
            try todoTasksService.deleteTask(by: id)
            
            _taskUpdates.send()
        } catch {
            handleTodoTaskError(error as? TodoTaskError)
        }
    }
}
