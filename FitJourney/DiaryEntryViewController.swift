//
//  ViewController.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/18/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class DiaryEntryViewController: UIViewController {
	
	//MARK: Outlets
	@IBOutlet weak var entryTextField: UITextField!
	
	//MARK: View Controller Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK: Helper Functions
	func dismissSelf() {
		presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}

	//MARK: IBActions
	@IBAction func doneAction(sender: UIBarButtonItem) {
		let coreData = CoreDataStack.defaultStack
		
		//save context
		let entry = DiaryEntry(context: coreData.managedObjectContext)
		entry.body = entryTextField.text!
		entry.date = NSDate()
		
		do {
			try coreData.saveContext()
		} catch let error as NSError {
			print("show alert controller here \(error)")
		}
	
		dismissSelf()
	}
	
	@IBAction func cancelAction(sender: UIBarButtonItem) {
		dismissSelf()
	}
}

