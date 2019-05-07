import Foundation

class Task: NSObject, NSCoding{
    var name : String?
    var done : Bool?
    
    init(name : String, done : Bool = false) {
        self.name = name
        self.done = done
    }
    
    // persistent data
    
    private let nameKey = "name"
    private let doneKey = "done"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(done, forKey: doneKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: nameKey) as? String,
                let done = aDecoder.decodeObject(forKey: doneKey) as? Bool
            else {
                return
        }
        self.name = name
        self.done = done
    }
}
