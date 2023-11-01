//
//  ToDoListViewModel.swift
//  To-Do
//
//  Created by Rajiv Puli on 07/09/23.
//

import Foundation

class ToDoListViewModel: ObservableObject {
    
    @Published var toDoList: [ToDoModel] = []
    
    func getToDoList() {
        toDoList = DBManager.shared.fetchToDoData()
        orderBasedStatus()
    }
    
    func createToDo(description: String) {
        DBManager.shared.insertToDo(description: description)
        getToDoList()
    }
    
    func updateToDo(data: ToDoModel, isCompleted: Bool) {
        DBManager.shared.update(toDoObj: data, isCompleted: isCompleted)
        getToDoList()
    }
    
    func remove(data: ToDoModel) {
        DBManager.shared.delete(toDoObj: data)
        getToDoList()
    }
    
    func orderBasedStatus() {
        let completedTasks = toDoList.filter({$0.isCompleted}).reversed()
        let notCompletedTasks = toDoList.filter({!$0.isCompleted}).reversed()
        var newList = [ToDoModel]()
        newList.append(contentsOf: notCompletedTasks)
        newList.append(contentsOf: completedTasks)
        toDoList = newList
    }
    
}
