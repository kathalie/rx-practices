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
                SearchAndSortBar
                if vm.tasks.isEmpty {
                    EmptyStateView
                } else {
                    TaskList
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    CreateTaskButton
                }
            }
            .alert("Error", isPresented: $showingError, actions: {
                Button("OK", role: .cancel) { vm.error = nil }
            }, message: {
                Text(vm.error ?? "")
            })
        }
    }
    
    private var SearchAndSortBar: some View {
        HStack {
            SearchBar
            SortMenu
        }
        .padding(.top, 10)
    }
    
    private var SearchBar: some View {
        TextField("Search tasks...", text: $vm.searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
    
    private var SortMenu: some View {
        Menu {
            ForEach(SortOption.allCases, id: \.self) { option in
                Button(action: {
                    vm.sortOption = option
                }) {
                    Text(option.rawValue)
                }
            }
        } label: {
            Label(
                vm.sortOption.rawValue,
                systemImage: "arrow.up.arrow.down"
            )
            .padding()
        }
    }
    
    private var CreateTaskButton: some View {
        NavigationLink(destination: TaskFormView()) {
            Image(systemName: "plus.circle.fill")
                .font(.title)
        }
    }
    
    private var EmptyStateView: some View {
        VStack {
            Spacer()
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray.opacity(0.5))
                .padding(.bottom, 10)
            
            Text("No tasks found")
                .font(.title2)
                .foregroundColor(.gray)
            Spacer()
        }
    }
    
    private var TaskList: some View {
        List {
            ForEach(vm.tasks) { task in
                TaskRow(task)
            }
            .onDelete(perform: vm.deleteTask)
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    private func TaskRow(_ task: TodoTask) -> some View {
        NavigationLink(destination: TaskFormView(taskToEdit: task)) {
            HStack {
                Button(action: { vm.toggleCompletion(for: task) }) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                        .font(.title)
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.name)
                        .font(.headline)
                        .strikethrough(task.isCompleted, color: .gray)
                        .foregroundColor(taskFgColor(for: task))
                    
                    Text(formattedTaskDate(for: task.dueDate))
                        .font(.subheadline)
                        .foregroundStyle(taskFgColor(for: task))
                }
                
                Spacer()
                
                Text(TaskPriority.getCase(with: task.priority)?.asString ?? TaskPriority.low.asString)
                    .padding(8)
                    .background(priorityColor(for: task.priority).opacity(0.2))
                    .foregroundColor(priorityColor(for: task.priority))
                    .clipShape(Capsule())
            }
            .padding(.vertical, 5)
        }
    }
    
    private func priorityColor(for priority: Int16) -> Color {
        switch TaskPriority.getCase(with: priority) ?? .low {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    private func taskFgColor(for task: TodoTask) -> Color {
        if task.isCompleted  { return Color.gray }
        return task.dueDate < Date() ? Color.accentColor : Color.black
    }
    
    private func formattedTaskDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        return formatter.string(from: date)
    }
}

