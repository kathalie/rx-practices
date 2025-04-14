//
//  CreateTaskViewModel.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import Combine

class TaskFormViewModel: ObservableObject {
    private let initialTask: TodoTask?
    
    @Published var taskName: String
    @Published var taskPriority: TaskPriority
    @Published var taskDueDate: Date
    
    let navigationTitle: String
        
    init(initialTask: TodoTask?) {
        self.initialTask = initialTask
        self.taskName = initialTask?.name ?? ""
        self.taskPriority = TaskPriority.getCase(with: initialTask?.priority ?? TaskPriority.low.rawValue) ?? .low
        self.taskDueDate = initialTask?.dueDate ?? Date()
        
        navigationTitle = initialTask == nil ? "Create Task" : "Edit Task"
    }
    
    func saveTask() {
        if let initialTask {
            updateTask(initialTask)
        } else {
            createTask()
        }
    }
    
    private func createTask() {
        let newTask = CreateTodoTaskModel(
            name: taskName,
            dueDate: taskDueDate,
            priority: taskPriority
        )
        
        TasksCoreDataService.shared.createTask(newTask)
    }
    
    private func updateTask(_ initialTask: TodoTask) {
        let updatedTask = EditTodoTaskModel(
            id: initialTask.id,
            name: taskName,
            isCompleted: initialTask.isCompleted,
            dueDate: taskDueDate,
            priority: taskPriority
        )
        
        TasksCoreDataService.shared.editTask(updatedTask)
    }
}
