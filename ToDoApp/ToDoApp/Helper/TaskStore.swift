import Foundation

class TaskStore {
    // 2 arrays of tasks
    // ongoing task, completed tasks
    var tasks = [[Task](),[Task]()]
    
    // add task
    func add(_ task : Task, at index : Int, done : Bool = false){
        // get to the right row of the array
        let section = done ? 1 : 0
        // push the task to the row
        tasks[section].insert(task, at: index)        
    }
    
    // eliminate task
    
    func eliminate(at index : Int, done : Bool = false) -> Task{
        // get to the right row of the array
        let section = done ? 1 : 0
        
        return tasks[section].remove(at: index)
    }
}
