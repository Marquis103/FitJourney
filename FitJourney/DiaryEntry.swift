//
//  DiaryEntry.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/19/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import CoreData


class DiaryEntry: NSManagedObject {
	var sectionName: String {
		let entrySectionDate = NSDate(timeIntervalSince1970: self.date)
		
		let formatter = NSDateFormatter()
		formatter.dateFormat = "MMM yyyy"
		
		
		return formatter.stringFromDate(entrySectionDate)
	}
	
	enum DiaryEntryMood: Int16 {
		case Good = 0
		case Average = 1
		case Bad = 2
	}

	override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
		super.init(entity: entity, insertIntoManagedObjectContext: context)
	}
	
	init(context: NSManagedObjectContext) {
		let entryEntity = NSEntityDescription.entityForName("DiaryEntry", inManagedObjectContext: context)!
		super.init(entity: entryEntity, insertIntoManagedObjectContext: context)
	}
	
	func saveEntry(context: NSManagedObjectContext) {
		
	}
	
	func saveEntry(withBody text:String, mood:Int16, image: UIImage?, location:String?) throws {
		self.body = text
		self.mood = mood
		
		if self.date == 0.0 {
			self.date = NSDate().timeIntervalSince1970
		}
		if self.location == nil {
			self.location = location ?? "No Location"
		}
		
		if let image = image {
			self.imageData = UIImageJPEGRepresentation(image, 0.80)
		} else {
			self.imageData = UIImageJPEGRepresentation(UIImage(named: "icn_noimage")!, 0.80)
		}
		
		do {
			try self.managedObjectContext?.save()
		} catch let error as NSError {
			throw error
			//print("show alert controller here \(error)")
		}
	}
}
