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
	
	func testTableViewSectionName() {
		let coreData = CoreDataStack.defaultStack
		
		let entry = DiaryEntry(context: coreData.managedObjectContext)
		
		entry.body = "testTableViewControllerSectionName"
		let components = NSDateComponents()
		components.month = 1
		components.year = 2015
		
		let calendar = NSCalendar.currentCalendar()
		let date = calendar.dateFromComponents(components)!
		entry.date = date.timeIntervalSince1970
		entry.mood = Int16(DiaryEntry.DiaryEntryMood.DiaryMoodGood.rawValue)
		
		
		XCTAssertEqual(entry.sectionName, "Jan 2015", "Entry section name should equal ")
		
	}
	
	
}
