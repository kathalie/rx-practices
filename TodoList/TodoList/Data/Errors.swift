//
//  Errors.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation

enum TodoTaskError: Error {
    case duplicateTask
    case emptyName
    case taskNotFound
    case failedToSaveTask
    case failedToDeleteTask
    case failedToGetTasks
}
