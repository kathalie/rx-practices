//
//  CreateTaskView.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import SwiftUI
import Combine

struct CreateTaskView: View {
    @ObservedObject private var vm: CreateTaskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingError = false
    
    init(taskListVm: TaskListViewModel) {
        vm = CreateTaskViewModel(taskListVm: taskListVm)
    }
    
    var body: some View {
        Form {
            TextField("Task Name", text: $vm.taskName)
            Button("Save") {
                vm.addTask()
                
                guard vm.error == nil else {
                    showingError = true
                    return
                }
                
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Create Task")
        .alert("Error", isPresented: $showingError, actions: {
            Button("OK", role: .cancel) {vm.error = nil}
        }, message: {
            Text(vm.error ?? "")
        })
    }
}
