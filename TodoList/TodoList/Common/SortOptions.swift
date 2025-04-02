//
//  SortOptions.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 02.04.2025.
//

import Foundation

enum SortOption: String, CaseIterable {
    case allFields = "Default"
    case dueDate = "Due date"
    case priority = "Priority"
    
    var sortDescriptors: [NSSortDescriptor] {
        switch self {
        case .allFields:
            return [
                NSSortDescriptor(keyPath: \TodoTask.isCompleted, ascending: true),
                NSSortDescriptor(keyPath: \TodoTask.priority, ascending: true),
                NSSortDescriptor(keyPath: \TodoTask.dueDate, ascending: true),
                NSSortDescriptor(keyPath: \TodoTask.name, ascending: true),
            ]
        case .dueDate:
            return [
                NSSortDescriptor(keyPath: \TodoTask.dueDate, ascending: true),
            ]
        case .priority:
            return [
                NSSortDescriptor(keyPath: \TodoTask.priority, ascending: true),
            ]
        }
    }
    
//    typealias AreInIncreasingOrder = (TodoTask, TodoTask) -> Bool
//    
//    var sortFunction: AreInIncreasingOrder {
//        switch self {
//        case .allFields:
//            return { allFieldsSort(lhs: $0, rhs: $1) }
//        case .dueDate:
//            return { $0.dueDate < $1.dueDate }
//        case .priority:
//            return { $0.priority < $1.priority }
//        }
//    }
//    
//    private func allFieldsSort(lhs: TodoTask, rhs: TodoTask) -> Bool {
//        let predicates: [AreInIncreasingOrder] = [
//            { !$0.isCompleted && $1.isCompleted },
//            { $0.priority < $1.priority},
//            { $0.dueDate > $1.dueDate },
//            { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
//        ]
//        
//        for predicate in predicates {
//            if !predicate(lhs, rhs) && !predicate(rhs, lhs) {
//                continue
//            }
//            
//            return predicate(lhs, rhs)
//        }
//        
//        return false
//    }
}
