 //
//  ViewController.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/18/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation

class DiaryEntryViewController: UIViewController {
	
	var entry:DiaryEntry?
	var date:NSDate?
	var locationManager: CLLocationManager?
	var location:String?
	
	var mood:Int! {
		didSet {
			setMoodPicked()
		}
	}
	
	@IBOutlet weak var lblCurrentWordCount: UILabel!
	@IBOutlet weak var lblMaxWordCount: UILabel!
	@IBOutlet weak var lblLocation: UILabel!
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
		entryTextField.delegate = self
		entryTextField.layoutManager.delegate = self
		entryTextField.layer.borderWidth = 2.0
		entryTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
		entryTextField.layer.cornerRadius = 5
		/*entryTextField.layer.masksToBounds = false
		entryTextField.layer.shadowColor = UIColor.blackColor().CGColor
		entryTextField.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
		entryTextField.layer.shadowRadius = 1.0*/
		
		
		if let entry = entry {
			entryTextField.text = entry.body
			mood = entry.mood
			date = NSDate(timeIntervalSince1970: entry.date)
			if let imageData = entry.imageData {
				imageButton.setImage(UIImage(data: imageData), forState: .Normal)
			}
			if let entryLocation = entry.location {
				location = entryLocation
				lblLocation.text = location
				
			}
		} else {
			mood = DiaryEntry.DiaryEntryMood.DiaryMoodAverage.rawValue
			date = NSDate()
			
			if CLLocationManager.locationServicesEnabled() {
				loadLocation()
			}
			
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
	func loadLocation() {
		locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
		locationManager?.requestWhenInUseAuthorization()
		locationManager?.startUpdatingLocation()
	}
	
	func dismissSelf() {
		presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func updateEntry() {
		entry?.body = entryTextField.text ?? ""
		entry?.imageData = UIImageJPEGRepresentation(imageButton.currentImage!, 0.80)
		entry?.mood = mood
		
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
			
			if let location = location {
				entry.location = location
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

extension DiaryEntryViewController: CLLocationManagerDelegate {
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location = locations.first
		
		if let location = location {
			locationManager?.stopUpdatingLocation()
			
			let geoCoder = CLGeocoder()
			
			geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
				guard error == nil else {
					print("there was an error getting the placemark")
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

extension DiaryEntryViewController:NSLayoutManagerDelegate {
	func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
		return 10
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
