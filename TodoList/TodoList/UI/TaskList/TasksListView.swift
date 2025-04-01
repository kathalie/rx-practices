//
//  TodoTasksListView.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 01.04.2025.
//

import Foundation
import SwiftUI
import Combine

struct TaskListView: View {
    @ObservedObject private var vm = TaskListViewModel()
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.tasks) { task in
                    NavigationLink(destination: EditTaskView(taskToEdit: task, taskListVm: vm)) {
                        HStack {
                            Button(action: { vm.toggleCompletion(for: task) }) {
                                Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text(task.name)
                        }
                    }
                }
                .onDelete(perform: vm.deleteTask)
            }
            .navigationTitle("Todo List")
            .toolbar {
                NavigationLink("+", destination: CreateTaskView(taskListVm: vm))
            }
            .alert("Error", isPresented: $showingError, actions: {
                Button("OK", role: .cancel) {vm.error = nil}
            }, message: {
                Text(vm.error ?? "")
            })
        }
        .onChange(of: vm.error) { _ in
            showingError = vm.error != nil
        }
    }
}
