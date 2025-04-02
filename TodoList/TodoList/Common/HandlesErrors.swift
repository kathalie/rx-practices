//
//  HandleError.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 02.04.2025.
//

import Foundation

protocol HandlesErrors: AnyObject {
    var error: String? { get set }
}

extension HandlesErrors {
    func handleError(_ error: Error) {
        self.error = (error as? TodoTaskError)?.rawValue ?? "Something went wrong"
    }
}
