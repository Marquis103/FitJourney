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
	
	//MARK: FetchRequest
	func entryListFetchRequest() -> NSFetchRequest {
		let fetchRequest = NSFetchRequest(entityName: "DiaryEntry")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
		
		return fetchRequest
	}

	//MARK: NSFetchedResultsController
	lazy var fetchedResultsController:NSFetchedResultsController = {
		let coreData = CoreDataStack.defaultStack
		
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.entryListFetchRequest(), managedObjectContext: coreData.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		
		fetchedResultsController.delegate = self
		
		return fetchedResultsController
	}()
	
	//MARK: TableViewControllerDelegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("entryCell", forIndexPath: indexPath)

		let entry:DiaryEntry = fetchedResultsController.objectAtIndexPath(indexPath) as! DiaryEntry
		
		cell.textLabel?.text = entry.body

        return cell
    }
	
	

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DiaryEntryTableViewController: NSFetchedResultsControllerDelegate {
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		self.tableView.reloadData()
	}
}

