//
//  NotesTableViewCell.swift
//  cate
//
//  Created by Winston Li on 25/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet
    weak var nameLabel: UILabel?
    
    func setNote(note: Note) {
        nameLabel?.text = note.specName
        let enabled = note.specLink != nil
        userInteractionEnabled = enabled
        nameLabel?.enabled = enabled
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
