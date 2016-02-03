//
//  ExerciseTableViewCell.swift
//  cate
//
//  Created by Winston Li on 24/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet
    weak var exLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setSpec() {
        exLabel?.text = "View spec"
        exLabel?.textColor = tintColor
    }
    
    func setNote(note: Note?) {
        exLabel?.text = note?.specName
        exLabel?.textColor = UIColor.blackColor()
        let enabled = note?.specLink != nil
        userInteractionEnabled = enabled
        exLabel?.enabled = enabled
    }
    
}
