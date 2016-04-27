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
	var diaryEntryDataSource:DiaryEntryTableViewControllerDataSource!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		diaryEntryDataSource = DiaryEntryTableViewControllerDataSource(withTableView: tableView)
		diaryEntryDataSource.performFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// MARK: - Navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "editEntry" {
			let tableViewCell = sender as! UITableViewCell
			let indexPath = tableView.indexPathForCell(tableViewCell)!
			
			let destinationController = segue.destinationViewController as! UINavigationController
			let entryViewController = destinationController.topViewController as! DiaryEntryViewController
			
			entryViewController.entry = diaryEntryDataSource.fetchedResultsController.objectAtIndexPath(indexPath)  as? DiaryEntry
		}
	}
}

