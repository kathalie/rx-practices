//
//  Errors.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation

enum TodoTaskError: String, Error {
    case duplicateTask = "Task with this name already exists. Please, specify another name and try again."
    case emptyName = "Task name should not be empty."
    case taskNotFound = "Failed to delete a task."
    case failedToSaveTask = "Failed to access tasks."
    case failedToDeleteTask = "Failed to save a task."
    case failedToGetTasks = "Task with a specified name was not found."
}


