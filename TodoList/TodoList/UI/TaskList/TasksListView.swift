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
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        vm.$error
            .map {$0 != nil}
            .assign(to: \.showingError, on: self)
            .store(in: &cancellables)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search tasks...", text: $vm.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    SortTasksView(taskListVm: vm)
                }
                List {
                    ForEach(vm.tasks) { task in
                        NavigationLink(destination: TaskFormView(taskToEdit: task).environmentObject(vm)) {
                            HStack {
                                Button(action: { vm.toggleCompletion(for: task) }) {
                                    Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                VStack(alignment: .leading) {
                                    Text(task.name)
                                        .strikethrough(task.isCompleted)
                                        .font(.title2)
                                    Text(formattedTaskDate(for: task.dueDate))
                                        .font(.title3)
                                }
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
        }
    }
    
    func taskBgColor(for task: TodoTask) -> Color {
        switch TaskPriority.getCase(with: task.priority) ?? .low {
        case .low: return Color.green
        case .medium: return Color.yellow
        case .high: return Color.red
        }
    }
    
    func formattedTaskDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"

        return formatter.string(from: date)
    }
}

