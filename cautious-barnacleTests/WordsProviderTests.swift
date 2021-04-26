//
//  WordsProviderTests.swift
//  cautious-barnacleTests
//
//  Created by Konstantin Khetagurov on 24.04.2021.
//

import XCTest
@testable import cautious_barnacle

class WordsProviderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPagination() throws {
        
        let service = WordsServiceMock()
        let provider = WordsProviderImp(wordsService: service)
        provider.loadWords(matching: "Hello")
//        XCTAssertFalse(provider.state.words.isEmpty, provider.state)
        XCTAssertTrue(provider.state.nextPage == 2)
        
        provider.loadWords(matching: "Hello")
        XCTAssertEqual(provider.state.nextPage, 3)
        
        provider.loadWords(matching: "Hello")
        XCTAssertEqual(provider.state.nextPage, 4)
    }
}
