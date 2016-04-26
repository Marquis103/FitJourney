//
//  DiaryEntryTableViewCell.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/22/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class DiaryEntryTableViewCell: UITableViewCell {

	@IBOutlet weak var entryImage: UIImageView!
	@IBOutlet weak var entryMoodImage: UIImageView!
	@IBOutlet weak var entryLocationLabel: UILabel!
	@IBOutlet weak var entryBodyLabel: UILabel!
	@IBOutlet weak var entryHeaderLabel: UILabel!
	
	static func heightForEntry(entry:DiaryEntry) -> CGFloat {
		let topMargin:CGFloat = 35.0
		let bottomMargin:CGFloat = 80.0
		
		let minHeight:CGFloat = 85.0
		
		let font = UIFont(name: "Helvetica Neue", size: 12.0)!
		
		//bounding box of entry body text
		let boundingBox:CGRect = (entry.body as NSString).boundingRectWithSize(CGSize(width: 202, height: CGFloat.max), options: [.UsesFontLeading, .UsesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: nil)
		
		return max(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin)
	}
	
	func configureCell(entry: DiaryEntry) {
		entryBodyLabel.text = entry.body
		entryLocationLabel.text = entry.location
		
		let date = NSDate(timeIntervalSince1970: entry.date)
		entryHeaderLabel.text = DiaryEntryDateFormatter.sharedDateFormatter.entryFormatter.stringFromDate(date)
		/*let formatter:NSDateFormatter = NSDateFormatter()
		formatter.dateFormat = "EEEE, MMMM d yyyy"
		
		
		entryHeaderLabel.text = formatter.stringFromDate(date)*/
		
		if let imageData = entry.imageData {
			entryImage.image = UIImage(data: imageData)
		} else {
			entryImage.image = UIImage(named: "icn_noimage")
		}
		
		if entry.location?.characters.count > 0 {
			entryLocationLabel.text = entry.location
		} else {
			entryLocationLabel.text = "No Location"
		}
		
		if entry.mood == DiaryEntry.DiaryEntryMood.Good.rawValue {
			entryMoodImage.image = UIImage(named: "icn_happy")
		} else if entry.mood == DiaryEntry.DiaryEntryMood.Average.rawValue {
			entryMoodImage.image = UIImage(named: "icn_average")
		} else if entry.mood == DiaryEntry.DiaryEntryMood.Bad.rawValue {
			entryMoodImage.image = UIImage(named: "icn_bad")
		}
		
		entryImage.layer.cornerRadius = CGRectGetWidth(entryImage.frame) / 2.0
	}
}
