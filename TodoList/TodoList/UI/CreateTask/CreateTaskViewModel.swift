//
//  CreateTaskViewModel.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import Combine

class CreateTaskViewModel: ObservableObject {
    @Published var taskName: String = ""
    @Published var error: String?
    
    private let todoTasksService = CoreDataService.shared

    private let taskListVm: TaskListViewModel
    
    init(taskListVm: TaskListViewModel) {
        self.taskListVm = taskListVm
    }
    
    func addTask() {
        let newTask = CreateTodoTaskModel(name: taskName)
        
        do {
            try todoTasksService.createTask(newTask)
            taskListVm.loadTasks()
        } catch {
            self.error = (error as? TodoTaskError)?.rawValue ?? "Something went wrong"
        }
    }
}
