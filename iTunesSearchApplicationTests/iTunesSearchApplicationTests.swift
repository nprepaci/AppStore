//
//  iTunesSearchApplicationTests.swift
//  iTunesSearchApplicationTests
//
//  Created by Nicholas Repaci on 8/30/21.
//

import XCTest

class iTunesSearchApplicationTests: XCTestCase {
  
  func testAPI() {
    
    // Create an expectation for a background download task.
    let expectation = XCTestExpectation(description: "Test if API is returning data")
    
    // Create a URL for a web page to be downloaded.
    let url = URL(string: "https://itunes.apple.com/search?term=ibm&entity=software")!
    
    // Create a background task to download the web page.
    let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
      
      // Make sure we downloaded some data.
      XCTAssertNotNil(data, "No data was downloaded.")
      
      // Fulfill the expectation to indicate that the background task has finished successfully.
      expectation.fulfill()
    }
    
    // Start the download task.
    dataTask.resume()
    
    // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
    wait(for: [expectation], timeout: 10.0)
  }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

