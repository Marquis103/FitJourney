//
//  DiaryEntryDateFormatter.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/26/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

struct DiaryEntryDateFormatter {
	static var sharedDateFormatter = DiaryEntryDateFormatter()
	
	lazy var entryFormatter:NSDateFormatter = {
		let entryFormatter = NSDateFormatter()
		
		entryFormatter.dateFormat = "EEEE MMMM d, yyyy"
		
		return entryFormatter
	}()
	
	/*lazy var listFormatter:NSDateFormatter = {
		let listFormatter = NSDateFormatter()
		
	}()*/
}
