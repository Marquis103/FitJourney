//
//  DiaryEntryAlert.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/26/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class DiaryEntryAlert: UIAlertController {
	static func getUIDiaryAlert(withTitle title:String, message:String) -> DiaryEntryAlert{
		let alert = DiaryEntryAlert(title: title, message: message, preferredStyle: .Alert)
		let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alert.addAction(action)
		return alert
	}
	
	/*static func getUIDiaryActionSheet(withTitle title:String, message:String?) -> DiaryEntryAlert {
		let actionSheet = DiaryEntryAlert(title: title:, message: message, preferredStyle: .ActionSheet)
		
		let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (action) in
			promptForCamera()
		}
		
		let photosAction = UIAlertAction(title: "Photo Roll", style: .Default) { (action) in
			promptForPhotoLibrary()
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
			
		}
		
		actionSheet.addAction(cameraAction)
		actionSheet.addAction(photosAction)
		actionSheet.addAction(cancelAction)
		
		presentViewController(actionSheet, animated: true, completion: nil)
	}*/
}
