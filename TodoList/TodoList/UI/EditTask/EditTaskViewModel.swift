//
//  EditTaskViewModel.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import Combine

class EditTaskViewModel: ObservableObject {
    private let task: TodoTask
    
    @Published var taskName: String
    @Published var error: String?
    
    private let todoTasksService = CoreDataService.shared
    
    private let taskListVm: TaskListViewModel
    
    init(task: TodoTask, taskListVm: TaskListViewModel) {
        self.task = task
        self.taskName = task.name
        self.taskListVm = taskListVm
    }
    
    func updateTask() {
        let updatedTask = EditTodoTaskModel(id: task.id, name: taskName, isCompleted: task.isCompleted)
        do {
            try todoTasksService.editTask(updatedTask)
            taskListVm.loadTasks()
        } catch {
            self.error = (error as? TodoTaskError)?.rawValue ?? "Something went wrong"
        }
    }
}
