//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    var createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    var id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {

    static var favoritesKey: String{
        return "Favorites"
    }
    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task], forKey key: String) {

        // TODO: Save the array of tasks
        let defaults = UserDefaults.standard
        let encodedData = try! JSONEncoder().encode(tasks)
        defaults.set(encodedData, forKey: key)
        
    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks(forKey key: String) -> [Task] {
        
        // TODO: Get the array of saved tasks from UserDefaults
        let defaults = UserDefaults.standard
        
        if let data = defaults.data(forKey: key){
            let decodedTasks = try! JSONDecoder().decode([Task].self, from: data)
            return decodedTasks
        }

        return [] // 👈 replace with returned saved tasks
    }

    // Add a new task or update an existing task with the current task.
    func save() {

        // TODO: Save the current task
        var newTask = Task.getTasks(forKey: Task.favoritesKey)
        
        if let i = newTask.firstIndex(where: { $0.id == self.id}){
            newTask.remove(at: i)
            newTask.insert(self, at: i)
            Task.save(newTask, forKey: Task.favoritesKey)
        }
        else{
            newTask.append(self)
            Task.save(newTask, forKey: Task.favoritesKey)
        }
        //Task.save(newTask, forKey: Task.favoritesKey)
        
    }
}
