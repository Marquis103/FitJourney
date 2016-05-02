//
//  DiaryEntryImageView.swift
//  FitJourney
//
//  Created by Marquis Dennis on 5/1/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class DiaryEntryImageViewController: UIViewController {
	var imageData:NSData?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let imageData = imageData {
			postImageView.image = UIImage(data: imageData)
		}
	}
	
	@IBOutlet weak var postImageView: UIImageView!
	
}
