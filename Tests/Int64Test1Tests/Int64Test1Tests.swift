import XCTest
@testable import Int64Test1

final class Int64Test1Tests: XCTestCase {
    struct 猫: Codable {
        var weight: Double?
        var name: String?
    }
    
    class 狗: Codable {
        var height: String?
        var name: String?
    }
    
    func testStruct1() throws {
        let name = "mao"
        let weight = 6.6
        
        let json: [String: Any] = [
            "weight": weight,
            "name": name
        ]
        let miao : 猫 = try json.translateToModel()
        XCTAssert(miao.name == name)
        XCTAssert(miao.weight == weight)
    }
    
    func testClass1() throws {
        let name = "wow"
        let height = 110.1
        
        let json: [String: Any] = [
            "height": height,
            "name": name
        ]
        
        let wow : 狗 = try json.translateToModel()
        XCTAssert(wow.name == name)
        XCTAssert(Double(wow.height ?? "") == height)
    }
    
    func testList1() throws {
        struct DD: Codable {
            var name: String?
            var age: Int64?
        }
        
        let jsonString = """
        [{
            "name" : "hahhahah",
            "age" :  1517213741861863222
        },
        {
            "name" : "hahhahah",
            "age" :  "1517213741861863222"
        }]
        """
        let data = jsonString.data(using: .utf8)!
        
        let dd : [DD] = try JSONDecoder().decode([DD].self, from: data)
        XCTAssert(dd.first?.age == 1517213741861863222)
        XCTAssert(dd.last?.age == 1517213741861863222)
    }
    
    func testDefault1() throws { //注意默认值
        struct pp: Codable {
            var name: String
            var age: Int
        }
        let name = "pp"
        //            let age = "6" // 报错
        let age = 6
        let json : [String: Any] = [
            "age": age,
            "name": name
        ]
        let p: pp = try json.translateToModel()
        XCTAssert(p.name == name)
//            XCTAssert(mouse.age == Int(age)) // 报错
        XCTAssert(p.age == age)
    }
    
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        XCTAssertEqual(Int64Test1().text, "Hello, World!")
//    }
//
//    static var allTests = [
//        ("testExample", testExample),
//    ]
}
