import Foundation

class TaskSave {
    static let myKey = "my_task_key"
    
    // load from system
    static func load() -> [[Task]]?{
        guard let data = UserDefaults.standard.object(forKey: myKey) as? Data
            else{
                return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? [[Task]]
    }
    
    // save to system
    
    static func save(_ tasks: [[Task]]){
        // convert
        let data = NSKeyedArchiver.archivedData(withRootObject: tasks) as NSData
        
        // save with key
        UserDefaults.standard.set(data, forKey: myKey)
        UserDefaults.standard.synchronize()
    }
}
