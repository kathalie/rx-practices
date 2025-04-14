//
//  CreateTaskView.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import SwiftUI
import Combine

struct TaskFormView: View {
    @ObservedObject private var vm: TaskFormViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingError = false
    
    init(taskToEdit: TodoTask? = nil) {
        self.vm = TaskFormViewModel(initialTask: taskToEdit)
    }
    
    var body: some View {
        Form {
            TextField("Task Name", text: $vm.taskName)
            Picker("Priority", selection: $vm.taskPriority) {
                ForEach(TaskPriority.allCases, id: \.self) { priority in
                    Text(priority.asString).tag(priority)
                }
            }
            DatePicker(
                selection: $vm.taskDueDate,
                displayedComponents: [.date]
            ) {
                Text("Due Date")
            }
            
            Button("Save", action: handleSave)
        }
        .navigationTitle(vm.navigationTitle)
        .alert("Error", isPresented: $showingError, actions: {
            Button("OK", role: .cancel) {TasksCoreDataService.shared.error = nil}
        }, message: {
            Text(TasksCoreDataService.shared.error ?? "")
        })
    }
    
    private func handleSave() {
        vm.saveTask()
        
        guard TasksCoreDataService.shared.error == nil else {
            showingError = true
            return
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}
