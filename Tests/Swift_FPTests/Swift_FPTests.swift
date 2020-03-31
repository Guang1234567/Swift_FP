import XCTest
@testable import Swift_FP

final class Swift_FPTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.


        // note:
        // struct Int {
        //      init?(_ description: String)
        // }

        let name: String? = "5"
        if let r1: Int?? = name.map({ Int($0) }) {
            XCTAssertEqual(r1, 5)
        }

        XCTAssertEqual(
                name.apply {
                    print("---------> \($0)")
                },
                name
        )

        let name2: String? = "7"
        let r2: Int? = name2.let({ Int($0)! })
        XCTAssertEqual(r2, 7)

        let name3: String? = "8"
        let r3: Int?? = name3.let({ Int($0) })
        XCTAssertEqual(r3, 8)

        //let optionalNumberString: String? = "5"
        //let optionalNumber: Int? = optionalNumberString.map { Int($0)}
        //XCTAssertEqual(optionalNumber!, 5)
    }

    func testResultScopeFunc() {
        enum MyError1: Error {
            case Err_11
            case Err_12
        }

        enum MyError2: Error {
            case Err_21
            case Err_22
        }

        let r1: Result<Int, MyError1> = Result.success(3)
        XCTAssertEqual(
                r1.apply { (success: Int) in
                    print("result--------->success = \(success)")
                },
                r1
        )

        let r2: Result<Int, MyError1> = Result.success(3)
        XCTAssertEqual(
                r2.let {
                    $0 * 4
                },
                Result.success(3 * 4)
        )

        let r3: Result<Int, MyError1> = Result.failure(MyError1.Err_11)
        let err22: Result<Int, MyError2> = r3.letError {
            print("result_err---------> \($0)")
            if MyError1.Err_11 == $0 {
                return MyError2.Err_22
            } else {
                return MyError2.Err_21
            }
        }
        XCTAssertEqual(err22, Result.failure(MyError2.Err_22)
        )
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
