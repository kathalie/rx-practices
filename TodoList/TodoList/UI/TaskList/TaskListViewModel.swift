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

class TaskListViewModel: ObservableObject {
    // MARK: Input
    @Published var sortOption: SortOption = .allFields
    @Published var searchText: String = ""
    
    // MARK: Output
    @Published private(set) var tasks: [TodoTask] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        TasksCoreDataService.shared.$searchText
            .assign(to: \.searchText, on: self)
            .store(in: &cancellables)
        
        TasksCoreDataService.shared.$sortOption
            .assign(to: \.sortOption, on: self)
            .store(in: &cancellables)
        
        TasksCoreDataService.shared.getTasksPublisher(
            sortOption: sortOption,
            searchText: searchText
        )
        .assign(to: \.tasks, on: self)
        .store(in: &cancellables)
        
//        Publishers.CombineLatest($sortOption, $searchText)
//            .sink { [weak self] sortOption, searchText in
//                guard let self else {return}
//
//                TasksCoreDataService.shared.getTasksPublisher(
//                    sortOption: sortOption,
//                    searchText: searchText
//                )
//                .assign(to: \.tasks, on: self)
//                .store(in: &cancellables)
//            }
//            .store(in: &cancellables)
    }

    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            TasksCoreDataService.shared.deleteTask(by: tasks[index].id)
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
        
        TasksCoreDataService.shared.editTask(updatedTask)
    }
}

