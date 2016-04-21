//
//  DiaryEntryListViewTests.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/21/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import XCTest
import CoreData

@testable import FitJourney

class DiaryEntryListTableViewControllerTests: XCTestCase {
	
	var diaryEntryTableView:DiaryEntryTableViewController!
	
    override func setUp() {
        super.setUp()
		
		diaryEntryTableView = DiaryEntryTableViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testNSFetchRequest() {
		let fetchRequest = diaryEntryTableView.entryListFetchRequest()
		XCTAssertNotNil(fetchRequest)
		XCTAssertEqual("\(fetchRequest.dynamicType)", "NSFetchRequest")
	}
	
	func testNSFetchResultsController() {
		let fetchedResultsController = diaryEntryTableView.fetchedResultsController
		
		XCTAssertNotNil(fetchedResultsController, "FetchedResultsController for diary entries should not be nil")
	}
}
