//
//  CoreDataStackTests.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/19/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import XCTest
import CoreData

@testable import FitJourney

class CoreDataStackTests: XCTestCase {
	
	var coreData: CoreDataStack!
	
    override func setUp() {
        super.setUp()
		
        coreData = CoreDataStack.defaultStack
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	///Test if the coredatastack singleton instance is not nil
	func testCoreDataStackSingleton() {
		XCTAssertNotNil(coreData, "CoreDataStack instance should not be nil")
    }
	
	///Test if managed object context is not nil
	func testManagedObjectContext() {
		XCTAssertNotNil(coreData.managedObjectContext, "Managed object context should not be nil")
	}
	
	func testGetPersistentStoreCoordinator() {
		XCTAssertNotNil(coreData.persistentStoreCoordinator, "Persistent store coordinator should not be nil")
	}
	
	func testCoreDataStackModuleName() {
		XCTAssertEqual(CoreDataStack.moduleName, "FitJourney")
	}
	
	func testSaveContext() {
		//create a diary object
		let diary = DiaryEntry(context: coreData.managedObjectContext)
		diary.body = "Test Body"
		diary.date = NSDate()
		diary.mood = Int16(DiaryEntry.DiaryEntryMood.DiaryMoodAverage.rawValue)
		
		do {
			try coreData.saveContext()
		} catch let error as NSError {
			print("show alert controller here \(error)")
		}
		
 		XCTAssertEqual(coreData.managedObjectContext.registeredObjects.count, 1)
		
	}
	
	func testClearManagedObjectContext() {
		let fetchRequest = NSFetchRequest(entityName: "DiaryEntry")
		let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		
		batchDelete.resultType = .ResultTypeCount
		
		do {
			try coreData.managedObjectContext.executeRequest(batchDelete)
		} catch let error as NSError {
			print(error)
			XCTAssertTrue(false)
			return
		}
		
		XCTAssertEqual(coreData.managedObjectContext.registeredObjects.count, 0)
	}
}
