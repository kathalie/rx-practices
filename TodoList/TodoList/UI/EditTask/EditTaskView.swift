//
//  EditTodoTaskView.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import SwiftUI
import Combine

struct EditTaskView: View {
    @ObservedObject private var vm: EditTaskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingError = false
    
    init(taskToEdit: TodoTask, taskListVm: TaskListViewModel) {
        self._vm = ObservedObject(wrappedValue: EditTaskViewModel(task: taskToEdit, taskListVm: taskListVm))
    }
    
    var body: some View {
        Form {
            TextField("Task Name", text: $vm.taskName)
            Button("Save") {
                vm.updateTask()
                
                guard vm.error == nil else {
                    showingError = true
                    return
                }
                
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Edit Task")
        .alert("Error", isPresented: $showingError, actions: {
            Button("OK", role: .cancel) {vm.error = nil}
        }, message: {
            Text(vm.error ?? "")
        })
    }
}
