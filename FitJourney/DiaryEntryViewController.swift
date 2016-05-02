 //
//  ViewController.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/18/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import CoreLocation

class DiaryEntryViewController: UIViewController {
	
	//MARK: Properties
	var entry:DiaryEntry?
	var date:NSDate?
	var locationManager: CLLocationManager?
	var location:String?
	
	var mood:Int16! {
		didSet {
			setMoodPicked()
		}
	}
	
	private var pickedImage:UIImage? {
		didSet {
			imageButton.setImage(pickedImage, forState: .Normal)
		}
	}
	
	lazy var coreData:CoreDataStack = {
		return CoreDataStack.defaultStack
	}()
	
	//MARK: Outlets
	@IBOutlet weak var lblCurrentWordCount: UILabel!
	@IBOutlet weak var lblMaxWordCount: UILabel!
	@IBOutlet weak var lblLocation: UILabel!
	@IBOutlet var accessoryView: UIStackView!
	@IBOutlet weak var badMood: UIButton!
	@IBOutlet weak var averageMood: UIButton!
	@IBOutlet weak var goodMood: UIButton!
	@IBOutlet weak var entryDateLabel: UILabel!
	@IBOutlet weak var imageButton: UIButton!
	
	@IBOutlet weak var entryTextView: DiaryEntryTextView! {
		didSet {
			entryTextView.configureTextView()
			entryTextView.delegate = self
		}
	}
	
	//MARK: View Controller Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let _ = entry {
			populateView()
		} else {
			setViewDefaults()
			
			if CLLocationManager.locationServicesEnabled() {
				loadLocation()
			}
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		entryTextView.becomeFirstResponder()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "viewPostImage" {
			if let imageData = entry?.imageData {
				let destinationVC = segue.destinationViewController as! DiaryEntryImageViewController
				destinationVC.imageData = imageData
			}
			
		}
	}
	
	//MARK: Helper Functions
	func loadLocation() {
		locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
		locationManager?.requestWhenInUseAuthorization()
		locationManager?.startUpdatingLocation()
	}
	
	func populateView() {
		entryTextView.text = entry!.body
		mood = entry!.mood
		date = NSDate(timeIntervalSince1970: entry!.date)
		
		entryDateLabel.text = DiaryEntryDateFormatter.sharedDateFormatter.entryFormatter.stringFromDate(date!)
		entryTextView.inputAccessoryView = accessoryView
		imageButton.layer.cornerRadius = CGRectGetWidth(imageButton.frame) / 2.0
		
		if let imageData = entry!.imageData {
			imageButton.setImage(UIImage(data: imageData), forState: .Normal)
		}
		if let entryLocation = entry!.location {
			location = entryLocation
			lblLocation.text = location
			
		}
	}
	
	func setViewDefaults() {
		mood = DiaryEntry.DiaryEntryMood.Average.rawValue
		date = NSDate()
		
		entryDateLabel.text = DiaryEntryDateFormatter.sharedDateFormatter.entryFormatter.stringFromDate(date!)
		
		entryTextView.inputAccessoryView = accessoryView
		imageButton.layer.cornerRadius = CGRectGetWidth(imageButton.frame) / 2.0
	}
	
	func dismissSelf() {
		presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func promptForSource() {
		let actionSheet = UIAlertController(title: "Image Source", message: nil, preferredStyle: .ActionSheet)
		let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (action) in
			self.promptForCamera()
		}
		let photosAction = UIAlertAction(title: "Photo Roll", style: .Default) { (action) in
			self.promptForPhotoLibrary()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
		
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
		case DiaryEntry.DiaryEntryMood.Average.rawValue:
			averageMood.alpha = 1.0
			break
			
		case DiaryEntry.DiaryEntryMood.Good.rawValue:
			goodMood.alpha = 1.0
			break
			
		case DiaryEntry.DiaryEntryMood.Bad.rawValue:
			badMood.alpha = 1.0
			break
			
		default:
			break
		}
	}

	//MARK: IBActions
	@IBAction func segueToImageView(sender: UIButton) {
		guard entry != nil else {
			return
		}
		
		performSegueWithIdentifier("viewPostImage", sender: nil)
	}
	
	@IBAction func editPostImage(sender: UIButton) {
		if UIImagePickerController.isSourceTypeAvailable(.Camera) {
			promptForSource()
		} else {
			//if camera is not available
			promptForPhotoLibrary()
		}
	}
	
	
	@IBAction func doneAction(sender: UIBarButtonItem) {
		guard entryTextView.text.characters.count > 0 else {
			let alertController = DiaryEntryAlert.getUIDiaryAlert(withTitle: "Invalid Journal Entry", message: "Please enter text for journal entry")
			presentViewController(alertController, animated: true, completion: nil)
			return
		}
		
		if entry != nil {
			do {
				try entry?.saveEntry(withBody: entryTextView.text, mood: mood, image: imageButton.currentImage, location: nil)
			} catch let error as NSError {
				print(error)
				let alert = DiaryEntryAlert(title: "Save Error", message: "There was an error saving journal entry!  Please try again later.", preferredStyle: .Alert)
				
				presentViewController(alert, animated: true, completion: nil)
			}
		} else {
			do {
				let _ = try		DiaryEntry(context: coreData.managedObjectContext).saveEntry(withBody: entryTextView.text, mood: mood, image: pickedImage, location: location)
			} catch let error as NSError {
				print(error)
				let alert = DiaryEntryAlert(title: "Save Error", message: "There was an error saving journal entry!  Please try again later.", preferredStyle: .Alert)
				
				presentViewController(alert, animated: true, completion: nil)
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
			mood = DiaryEntry.DiaryEntryMood.Bad.rawValue
		} else if sender.tag == 999 {
			//user mood is average
			mood = DiaryEntry.DiaryEntryMood.Average.rawValue
		} else if sender.tag == 1000 {
			//user mood is good
			mood = DiaryEntry.DiaryEntryMood.Good.rawValue
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

extension DiaryEntryViewController: CLLocationManagerDelegate {
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location = locations.first
		
		if let location = location {
			locationManager?.stopUpdatingLocation()
			
			let geoCoder = CLGeocoder()
			
			geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
				guard error == nil else {
					let alert = DiaryEntryAlert(title: "Location Error", message: "There was an error calculating location!", preferredStyle: .Alert)
					
					self.presentViewController(alert, animated: true, completion: nil)
					
					return
				}
				let placemark = placemarks?.first
				
				if let placemark = placemark {
					if let name = placemark.name {
						self.lblLocation.text = name
						self.location = name
					}
				}
			})
		}
	}
}


extension DiaryEntryViewController:UITextViewDelegate {
	func textViewDidChange(textView: UITextView) {
		let charCount = textView.text.characters.count
		
		if charCount > 0 && charCount < 435 {
			lblCurrentWordCount.text = String(charCount)
			lblCurrentWordCount.textColor = UIColor(red: 80.0/255.0, green: 141.0/255.0, blue: 15.0/255.0, alpha: 1.0)
			
		} else if charCount >= 435 && charCount <= 450 {
			lblCurrentWordCount.text = String(charCount)
			lblCurrentWordCount.textColor = UIColor.redColor()
		} else {
			textView.deleteBackward()
			lblCurrentWordCount.text = String(charCount - 1)
			lblCurrentWordCount.textColor = UIColor.redColor()
		}
	}
	
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		let currentCharacterLength = textView.text.characters.count ?? 0
		if range.length + range.location > currentCharacterLength {
			return false
		}
		
		let newLength = currentCharacterLength + text.characters.count - range.length
		return newLength <= 450
	}
}




