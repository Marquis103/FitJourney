//
//  DiaryEntryTableViewControllerDataSource.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/26/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import CoreData

class DiaryEntryTableViewControllerDataSource: NSObject, UITableViewDataSource {
	weak var tableView:UITableView!
	
	init(withTableView tableView:UITableView) {
		super.init()
		self.tableView = tableView
		self.tableView.dataSource = self
		self.tableView.delegate = self
		//performFetch()
	}
	
	func performFetch() {
		do {
			try fetchedResultsController.performFetch()
		} catch let error as NSError {
			tableView = nil
			print("Error during fetch\n \(error)")
		}
	}
	
	//MARK: FetchRequest
	func entryListFetchRequest() -> NSFetchRequest {
		let fetchRequest = NSFetchRequest(entityName: "DiaryEntry")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
		
		return fetchRequest
	}
	
	//MARK: NSFetchedResultsController
	lazy var fetchedResultsController:NSFetchedResultsController = {
		let coreData = CoreDataStack.defaultStack
		
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.entryListFetchRequest(), managedObjectContext: coreData.managedObjectContext, sectionNameKeyPath: "sectionName", cacheName: nil)
		
		fetchedResultsController.delegate = self
		
		return fetchedResultsController
	}()
	
	//MARK: UITableViewDataSource
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if let sections = fetchedResultsController.sections {
			return sections.count
		}
		
		return 0
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController.sections {
			let sectionInfo = sections[section]
			return sectionInfo.numberOfObjects
		}
		
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("entryCell", forIndexPath: indexPath) as! DiaryEntryTableViewCell
		
		let entry:DiaryEntry = fetchedResultsController.objectAtIndexPath(indexPath) as! DiaryEntry
		
		cell.configureCell(entry)
		
		return cell
	}
}

extension DiaryEntryTableViewControllerDataSource: UITableViewDelegate {
	//MARK: TableViewControllerDelegate
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			let entry = fetchedResultsController.objectAtIndexPath(indexPath)
			
			let coreData = CoreDataStack.defaultStack
			
			coreData.managedObjectContext.deleteObject(entry as! NSManagedObject)
			
			do {
				try coreData.saveContext()
			} catch let error as NSError {
				print(error)
			}
		}
	}
	
	func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		
		let v = view as! UITableViewHeaderFooterView
		v.textLabel?.textColor = UIColor(red: 46.0/255.0, green: 80.0/255.0, blue: 120.0/255.0, alpha: 1.0)
		v.backgroundView?.backgroundColor = UIColor(red: 185.0/255.0, green: 202.0/255.0, blue: 223.0/255.0, alpha: 1.0)
		
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let sectionInfo = fetchedResultsController.sections {
			return sectionInfo[section].name
		}
		
		return ""
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let entry = fetchedResultsController.objectAtIndexPath(indexPath)
		
		return DiaryEntryTableViewCell.heightForEntry(entry as! DiaryEntry)
	}
}

extension DiaryEntryTableViewControllerDataSource: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		tableView.beginUpdates()
	}
	
	func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
		switch(type) {
		case .Delete:
			tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
			break
		case .Insert:
			tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
			break
		case .Update:
			tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
			break
		default:
			break
		}
		
	}
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.endUpdates()
	}
	
	func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
		switch type {
		case .Insert:
			tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
			break
			
		case .Delete:
			tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
			break
			
		default:
			break
			
		}
	}
}
