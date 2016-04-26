//
//  DiaryEntryTextView.swift
//  FitJourney
//
//  Created by Marquis Dennis on 4/26/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class DiaryEntryTextView: UITextView {
	
	@IBInspectable
	var borderWidth:CGFloat = 2.0 {
		didSet {
			layer.borderWidth = borderWidth
			setNeedsDisplay()
		}
	}
	
	@IBInspectable
	var borderColor:UIColor = UIColor.lightGrayColor() {
		didSet {
			layer.borderColor = borderColor.CGColor
			setNeedsDisplay()
		}
	}
	
	@IBInspectable
	var cornerRadius:CGFloat = 5.0 {
		didSet {
			layer.cornerRadius = cornerRadius
			setNeedsDisplay()
		}
	}
	
	func configureTextView() {
		layoutManager.delegate = self
		layer.borderWidth = 2.0
		layer.borderColor = UIColor.lightGrayColor().CGColor
		layer.cornerRadius = 5
		
		/*entryTextField.layer.masksToBounds = false
		entryTextField.layer.shadowColor = UIColor.blackColor().CGColor
		entryTextField.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
		entryTextField.layer.shadowRadius = 1.0*/
	}
}

extension DiaryEntryTextView:NSLayoutManagerDelegate {
	func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
		return 10
	}
}


