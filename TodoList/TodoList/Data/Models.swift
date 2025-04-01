//
//  Models.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation

struct CreateTodoTaskModel {
    let name: String
}

struct EditTodoTaskModel {
    let id: UUID
    let name: String
    let isFinished: Bool
}
