//
//  DeadlineTableViewCell.swift
//  cate
//
//  Created by Winston Li on 24/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

class DeadlineTableViewCell: UITableViewCell {

    @IBOutlet
    weak var nameLabel: UILabel?
    @IBOutlet
    weak var categoryLabel: UILabel?
    @IBOutlet
    weak var subjectNameLabel: UILabel?
    @IBOutlet
    weak var timeRemainingLabel: UILabel?
    @IBOutlet
    weak var timeProgressBar: UIProgressView?
    
    var timer: NSTimer?
    
    var d: Deadline?
    
    var u: Upcoming?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeProgressBar?.transform = CGAffineTransformMakeScale(-1.0, 1.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tryUpdateTime() {
        if let deadline = d {
            timeRemainingLabel?.text = deadline.timeRemainingAsString()
            let percent: Float = NSDate().remainingPercentageFrom(deadline.dueTime, start: deadline.startTime)
            let colour: UIColor = deadline.submitted ? UIColor.lightGrayColor() : ProgressColour.fromPercentage(percent);
            timeRemainingLabel?.textColor = colour
            timeProgressBar?.hidden = false
            timeProgressBar?.tintColor = colour
            timeProgressBar?.progress = percent
        }
        if let upcoming = u {
            timeRemainingLabel?.text = upcoming.timeRemainingAsString()
        }
    }
    
    func setDeadline(deadline: Deadline?) {
        d = deadline
        u = nil
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tryUpdateTime", userInfo: nil, repeats: true)
        
        selectionStyle = .Default
        nameLabel?.text = deadline?.name
        categoryLabel?.text = deadline?.category
        categoryLabel?.textColor = deadline?.type.color()
        subjectNameLabel?.text = deadline?.subject?.name!
        tryUpdateTime()
    }
    
    func setUpcoming(upcoming: Upcoming?) {
        d = nil
        u = upcoming
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tryUpdateTime", userInfo: nil, repeats: true)
        selectionStyle = .None
        nameLabel?.text = upcoming?.name
        categoryLabel?.text = upcoming?.category
        categoryLabel?.textColor = upcoming?.type.color()
        subjectNameLabel?.text = upcoming?.subject?.name
        timeRemainingLabel?.textColor = UIColor.darkGrayColor()
        timeProgressBar?.hidden = true
        tryUpdateTime()
    }

}
