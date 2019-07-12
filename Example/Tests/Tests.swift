import XCTest
import Stem
import BLFoundation

class Foo: NSObject {
    var a: String = "a"
}



class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        print(RunTime.print.ivars(from: Foo.self))
        let foo = Foo()
        print(foo.value(forKey: "a")!)
        XCTAssert(true, "Pass")
    }

    func testUIApplication() {
        print(UIApplication.shared.st.info)
    }
    
}
