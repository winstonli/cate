//
//  EventTableViewCell.swift
//  cate
//
//  Created by Winston Li on 25/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet
    weak var startTimeLabel: UILabel?
    
    @IBOutlet
    weak var endTimeLabel: UILabel?
    
    @IBOutlet
    weak var nameLabel: UILabel?
    
    @IBOutlet
    weak var typeLabel: UILabel?
    
    @IBOutlet
    weak var roomLabel: UILabel?
    
    @IBOutlet
    weak var lecturerLabel: UILabel?
    
    let dateFormatter: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateStyle = .NoStyle
        df.timeStyle = .ShortStyle
        df.timeZone = NSTimeZone(name: "UTC")
        return df
    }()
    
    @IBOutlet weak var exampleTime: UILabel?
    
    func setEventAs(event: Event, state: TimetableState, now: NSDate) {
        let colour = event.type.getColour()
        let canSelect = event.subject != nil && !event.subject!.notes.isEmpty
        userInteractionEnabled = canSelect
        nameLabel?.enabled = canSelect
        if state == .Today && event.isOccurring(now) {
            startTimeLabel?.text = "Now"
        } else {
            startTimeLabel?.text = dateFormatter.stringFromDate(event.getStartTimeAsDate())
        }
        startTimeLabel?.textColor = colour
        endTimeLabel?.text = dateFormatter.stringFromDate(event.getEndTimeAsDate())
        endTimeLabel?.textColor = colour
        exampleTime?.text = dateFormatter.stringFromDate(Event.dateFormatter.dateFromString("12:00")!)
        nameLabel?.text = event.subjectName
        typeLabel?.text = event.type.description
        typeLabel?.textColor = colour
        roomLabel?.text = event.rooms.joinWithSeparator(", ")
        lecturerLabel?.text = event.lecturers.joinWithSeparator("\n")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        onLayout?(self)
    }
    
    var onLayout: ((EventTableViewCell) -> ())?

}
