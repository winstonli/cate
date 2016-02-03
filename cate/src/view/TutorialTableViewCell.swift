//
//  TutorialTableViewCell.swift
//  cate
//
//  Created by Winston Li on 24/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

class TutorialTableViewCell: UITableViewCell {

    @IBOutlet
    weak var nameLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTutorial(tutorial: Tutorial?) {
        nameLabel?.textColor = UIColor.blackColor()
        nameLabel?.text = tutorial?.name
        let enabled = tutorial?.specUrl != nil
        userInteractionEnabled = enabled
        nameLabel?.enabled = enabled
    }
    
    func setNotes() {
        nameLabel?.textColor = tintColor
        nameLabel?.text = "View notes"
        userInteractionEnabled = true
        nameLabel?.enabled = true
    }

}
