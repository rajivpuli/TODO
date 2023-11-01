//
//  DBManager.swift
//  To-Do
//
//  Created by Rajiv Puli on 07/09/23.
//

import Foundation
import CoreData
import UIKit

class DBManager: NSObject {
    
    static let shared = DBManager()
    
    var managedContext: NSManagedObjectContext?
    
    private override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func fetchToDoData() -> [ToDoModel] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoModel")
        do {
            let items = try managedContext?.fetch(fetchRequest) as! [ToDoModel]
            return items
        } catch {
            print("error-Fetching data")
            return []
        }
    }
    
    func insertToDo(description: String) {
        let toDoModel = ToDoModel(context: managedContext!)
        toDoModel.todoDescription = description
        toDoModel.isCompleted = false
        do {
            try managedContext?.save()
        } catch {
            print("error-insert data")
        }
    }
    
    func update(toDoObj: ToDoModel, isCompleted: Bool) {
        toDoObj.isCompleted = isCompleted
        do {
            try managedContext?.save()
        } catch {
            print("error-update data")
        }
    }
    
    func delete(toDoObj: ToDoModel) {
        managedContext?.delete(toDoObj)
        do {
            try managedContext?.save()
        } catch {
            print("error-delete data")
        }
    }
    
}
