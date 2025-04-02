//
//  TodoTasksListVM.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import Combine

class TaskListViewModel: ObservableObject, HandlesErrors {
    @Published private(set) var tasks: [TodoTask] = []
    @Published var error: String?
    
    private let todoTasksService = CoreDataService.shared
    
    func loadTasks() {
        do {
            tasks = try todoTasksService.getTasks()
        } catch {
            handleError(error)
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            do {
                try todoTasksService.deleteTask(by: tasks[index].id)
                loadTasks()
            } catch {
                handleError(error)
            }
        }
    }
    
    func toggleCompletion(for task: TodoTask) {
        let updatedTask = EditTodoTaskModel(
            id: task.id,
            name: task.name,
            isCompleted: !task.isCompleted,
            dueDate: task.dueDate,
            priority: TaskPriority.getCase(with: task.priority) ?? .low
        )
        
        do {
            try todoTasksService.editTask(updatedTask)
            loadTasks()
        } catch {
            handleError(error)
        }
    }
}

