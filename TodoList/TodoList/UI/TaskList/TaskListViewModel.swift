//
//  TodoTasksListVM.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import Combine
import CoreData
import SwiftUI

class TaskListViewModel: ObservableObject, HandlesErrors {
    @Published private(set) var tasks: [TodoTask] = []
    @Published var error: String?
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .allFields
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: TasksCoreDataService.shared.context)
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.loadTasks(sortOption: self.sortOption, searchText: self.searchText)
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest($sortOption, $searchText)
            .sink { [weak self] sortOption, searchText in
                self?.loadTasks(sortOption: sortOption, searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    func loadTasks(sortOption: SortOption, searchText: String) {
        do {
            tasks = try TasksCoreDataService.shared.getTasks(sortOption: sortOption, searchText: searchText)
        } catch {
            handleError(error)
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            do {
                try TasksCoreDataService.shared.deleteTask(by: tasks[index].id)
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
            try TasksCoreDataService.shared.editTask(updatedTask)
        } catch {
            handleError(error)
        }
    }
}

