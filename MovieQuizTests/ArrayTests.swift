//
//  File.swift
//  MovieQuizTests
//
//  Created by Ivan Kuninets on 1/31/25.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        let array = [1, 1, 2, 3, 4, 5]
        let value = array[safe: 2]
  
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
     
        let array = [1, 1, 2, 3, 4, 5]
        let value = array[safe: 20]
        XCTAssertNil(value)
    }
}
