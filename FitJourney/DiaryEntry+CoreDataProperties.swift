//
//  DiaryEntry+CoreDataProperties.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/19/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DiaryEntry {

    @NSManaged var body: String
    @NSManaged var date: NSDate
    @NSManaged var mood: Int16
    @NSManaged var imageData: NSData?
    @NSManaged var location: String?

}
