import XCTest
@testable import ToDoApp

class TaskTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTask() {
        // The app is using MVC correctly and has unit tests for the model
        let task = Task(name: "Liz", done: true)
        
        XCTAssertEqual("Liz", task.name)
        XCTAssertEqual(true, task.done)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
