//
//  DiaryEntryListViewControllerTableViewController.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/21/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import CoreData

class DiaryEntryTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

		do {
			try fetchedResultsController.performFetch()
		} catch let error as NSError {
			print("Error during fetch\n \(error)")
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if let sections = fetchedResultsController.sections {
			return sections.count
		}
		
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController.sections {
			let sectionInfo = sections[section]
			return sectionInfo.numberOfObjects
		}
		
        return 0
    }
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("entryCell", forIndexPath: indexPath) as! DiaryEntryTableViewCell
		
		let entry:DiaryEntry = fetchedResultsController.objectAtIndexPath(indexPath) as! DiaryEntry
		
		cell.configureCell(entry)
		
		return cell
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
	
	//MARK: TableViewControllerDelegate
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let sectionInfo = fetchedResultsController.sections {
			return sectionInfo[section].name
		}
		
		return ""
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let entry = fetchedResultsController.objectAtIndexPath(indexPath)
		
		return DiaryEntryTableViewCell.heightForEntry(entry as! DiaryEntry)
	}
	
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "editEntry" {
			let tableViewCell = sender as! UITableViewCell
			let indexPath = tableView.indexPathForCell(tableViewCell)!
			
			let destinationController = segue.destinationViewController as! UINavigationController
			let entryViewController = destinationController.topViewController as! DiaryEntryViewController
			
			entryViewController.entry = fetchedResultsController.objectAtIndexPath(indexPath)  as? DiaryEntry
		}
	}
}

extension DiaryEntryTableViewController: NSFetchedResultsControllerDelegate {
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

