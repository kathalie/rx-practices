//
//  SortTasksView.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 02.04.2025.
//

import Foundation
import SwiftUI
import Combine

struct SortTasksView: View {
    @ObservedObject private var taskListVm: TaskListViewModel
    
    init(taskListVm: TaskListViewModel) {
        self.taskListVm = taskListVm
    }
    
    var body: some View {
        Menu {
            ForEach(SortOption.allCases, id: \.self) { option in
                Button(action: {
                    taskListVm.sortOption = option
                }) {
                    Text(option.rawValue)
                }
            }
        } label: {
            Label(
                taskListVm.sortOption.rawValue,
                systemImage: "arrow.up.arrow.down"
            )
            .padding()
        }
    }
}
