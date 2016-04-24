 //
//  ViewController.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/18/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import QuartzCore

class DiaryEntryViewController: UIViewController {
	
	var entry:DiaryEntry?
	var date:NSDate?
	
	var mood:Int! {
		didSet {
			setMoodPicked()
		}
	}
	
	@IBOutlet var accessoryView: UIStackView!
	@IBOutlet weak var badMood: UIButton!
	@IBOutlet weak var averageMood: UIButton!
	@IBOutlet weak var goodMood: UIButton!
	@IBOutlet weak var entryDateLabel: UILabel!
	@IBOutlet weak var imageButton: UIButton!
	private var pickedImage:UIImage? {
		didSet {
			imageButton.setImage(pickedImage, forState: .Normal)
		}
	}
	
	lazy var coreData:CoreDataStack = {
		return CoreDataStack.defaultStack
	}()
	
	//MARK: Outlets
	@IBOutlet weak var entryTextField: UITextView!
	
	//MARK: View Controller Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let entry = entry {
			entryTextField.text = entry.body
			mood = entry.mood
			date = NSDate(timeIntervalSince1970: entry.date)
		} else {
			mood = DiaryEntry.DiaryEntryMood.DiaryMoodAverage.rawValue
			date = NSDate()
		}
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "EEEE MMMM d, yyyy"
		entryDateLabel.text = dateFormatter.stringFromDate(date!)
		entryTextField.inputAccessoryView = accessoryView
		imageButton.layer.cornerRadius = CGRectGetWidth(imageButton.frame) / 2.0
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		entryTextField.becomeFirstResponder()
	}
	
	//MARK: Helper Functions
	func dismissSelf() {
		presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func updateEntry() {
		entry?.body = entryTextField.text ?? ""
		
		do {
			try coreData.saveContext()
		} catch let error as NSError {
			print("show alert controller here \(error)")
		}
	}
	
	func promptForSource() {
		let actionSheet = UIAlertController(title: "Image Source", message: nil, preferredStyle: .ActionSheet)
		
		let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (action) in
			self.promptForCamera()
		}
		
		let photosAction = UIAlertAction(title: "Photo Roll", style: .Default) { (action) in
			self.promptForPhotoLibrary()
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
			
		}
		
		actionSheet.addAction(cameraAction)
		actionSheet.addAction(photosAction)
		actionSheet.addAction(cancelAction)
		
		presentViewController(actionSheet, animated: true, completion: nil)
		
		
	}
	
	func promptForCamera() {
		let imagePicker = UIImagePickerController()
		imagePicker.sourceType = .Camera
		imagePicker.delegate = self
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func promptForPhotoLibrary() {
		let imagePicker = UIImagePickerController()
		imagePicker.sourceType = .PhotoLibrary
		imagePicker.delegate = self
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func setMoodPicked() {
		badMood.alpha = 0.5
		averageMood.alpha = 0.5
		goodMood.alpha = 0.5
		
		switch mood {
		case DiaryEntry.DiaryEntryMood.DiaryMoodAverage.rawValue:
			averageMood.alpha = 1.0
			break
			
		case DiaryEntry.DiaryEntryMood.DiaryMoodGood.rawValue:
			goodMood.alpha = 1.0
			break
			
		case DiaryEntry.DiaryEntryMood.DiaryMoodBad.rawValue:
			badMood.alpha = 1.0
			break
			
		default:
			break
		}
	}

	//MARK: IBActions
	
	@IBAction func addImageToPost(sender: UIButton) {
		if UIImagePickerController.isSourceTypeAvailable(.Camera) {
			promptForSource()
		} else {
			//if camera is not available
			promptForPhotoLibrary()
		}
	}
	
	@IBAction func doneAction(sender: UIBarButtonItem) {
		if entry != nil {
			updateEntry()
		} else {
			//save context
			let entry = DiaryEntry(context: coreData.managedObjectContext)
			entry.body = entryTextField.text!
			entry.date = NSDate().timeIntervalSince1970
			if let image = pickedImage {
				entry.imageData = UIImageJPEGRepresentation(image, 0.80)
			} else {
				entry.imageData = UIImageJPEGRepresentation(UIImage(named: "icn_noimage")!, 0.80)
			}
			
			if let mood = mood {
				entry.mood = mood
			} else {
				entry.mood = DiaryEntry.DiaryEntryMood.DiaryMoodAverage.rawValue
			}
			
			do {
				try coreData.saveContext()
			} catch let error as NSError {
				print("show alert controller here \(error)")
			}
		}
		
		dismissSelf()
	}
	
	@IBAction func cancelAction(sender: UIBarButtonItem) {
		dismissSelf()
	}
	
	
	@IBAction func moodPicked(sender: UIButton) {
		if sender.tag == 998 {
			//user mood is bad
			mood = DiaryEntry.DiaryEntryMood.DiaryMoodBad.rawValue
		} else if sender.tag == 999 {
			//user mood is average
			mood = DiaryEntry.DiaryEntryMood.DiaryMoodAverage.rawValue
		} else if sender.tag == 1000 {
			//user mood is good
			mood = DiaryEntry.DiaryEntryMood.DiaryMoodGood.rawValue
		}
	}
}

extension DiaryEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		let image = info[UIImagePickerControllerOriginalImage] as! UIImage
		self.pickedImage = image
		dismissViewControllerAnimated(true, completion: nil)
	}
	
}
