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
                    NavigationLink(destination: TaskFormView(taskToEdit: task).environmentObject(vm)) {
                        HStack {
                            Button(action: { vm.toggleCompletion(for: task) }) {
                                Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text(task.name)
                                .strikethrough(task.isCompleted)
                        }
                    }
                    .background(taskBgColor(for: task))
                }
                .onDelete(perform: vm.deleteTask)
            }
            .navigationTitle("Todo List")
            .toolbar {
                NavigationLink("+", destination: TaskFormView().environmentObject(vm))
                
            }
            .alert("Error", isPresented: $showingError, actions: {
                Button("OK", role: .cancel) {vm.error = nil}
            }, message: {
                Text(vm.error ?? "")
            })
        }
        .onAppear {
            vm.loadTasks()
        }
        .onChange(of: vm.error) {
            showingError = vm.error != nil
        }
    }
    
    func taskBgColor(for task: TodoTask) -> Color {
        switch TaskPriority.getCase(with: task.priority) ?? .low {
        case .low: return Color.green
        case .medium: return Color.yellow
        case .high: return Color.red
        }
    }
}
