//
//  TodoTasksListVM.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    @Published private(set) var tasks: [TodoTask] = []
    @Published var error: String?
    
    private let todoTasksService = CoreDataService.shared
    
    init() {
        loadTasks()
    }
    
    func loadTasks() {
        do {
            tasks = try todoTasksService.getTasks()
        } catch {
            self.error = (error as? TodoTaskError)?.rawValue ?? "Something went wrong"
        }
        
    }
    
    func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            do {
                try todoTasksService.deleteTask(by: tasks[index].id)
                loadTasks()
            } catch {
                self.error = (error as? TodoTaskError)?.rawValue ?? "Something went wrong"
            }
        }
    }
    
    func toggleCompletion(for task: TodoTask) {
        let updatedTask = EditTodoTaskModel(id: task.id, name: task.name, isCompleted: !task.isCompleted)
        
        do {
            try todoTasksService.editTask(updatedTask)
            loadTasks()
        } catch {
            self.error = (error as? TodoTaskError)?.rawValue ?? "Something went wrong"
        }
    }
}

