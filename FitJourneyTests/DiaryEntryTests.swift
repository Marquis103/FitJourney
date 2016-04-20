//
//  DiaryEntryTests.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/19/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import XCTest
import CoreData

@testable import FitJourney

class DiaryEntryTests: XCTestCase {

	var coreData:CoreDataStack!
	
    override func setUp() {
        super.setUp()
		
		coreData = CoreDataStack.defaultStack
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit_DiaryEntry() {
		let entry = DiaryEntry(context: coreData.managedObjectContext)
		
		XCTAssertNotNil(entry)
    }
}
