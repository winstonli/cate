//
//  TodayVC.swift
//  cate
//
//  Created by Winston Li on 22/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

enum TimetableState {
    case Hidden
    case Today
    case Next
}

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private static let dateFormatter: NSDateFormatter = {
        let df = NSDateFormatter()
        df.calendar = UTCCalendar.cal
        df.dateFormat = "EEEE, d MMMM"
        return df
    }()
    
    var modelListener: ModelListener!
    
    var timetable: Timetable?
    var hadEvents: Bool = false
    var today: [Event]?
    var next: (DayDesc, [Event])?
    
    var state: TimetableState = .Hidden
    
    var now: NSDate = NSDate()
    
    @IBOutlet
    weak var tableView: UITableView?
    
    @IBOutlet
    weak var todayLabel: UILabel!
    
    @IBOutlet
    weak var todaySubLabel: UILabel!
//    @IBOutlet
//    weak var datePicker: UIDatePicker?
    
    @IBOutlet
    weak var hiddenLabel: UILabel?
    
    private func reloadTimetable(timetable: Timetable) {
        self.timetable = timetable
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "d/M/y H:m"
        
//        let now = formatter.dateFromString("29/01/2016 18:00")!
        resolveTimetable()
    }
    
    private func resolveTimetable() {
        if let timetable = self.timetable {
            let now = NSDate()
//            let now = datePicker!.date
            self.now = now
            let (today, hadEvents) = timetable.getForTime(now)
            let (nextDay, nextEvents) = timetable.getNextDay(now)
            self.hadEvents = hadEvents
            self.today = today
            self.next = (nextDay, nextEvents)
            if today.isEmpty && nextEvents.isEmpty {
                state = .Hidden
            } else if today.isEmpty {
                state = .Next
            } else {
                state = .Today
            }
            let hideTableView = state == .Hidden
            tableView?.alpha = hideTableView ? 0.2 : 1.0
            hiddenLabel?.hidden = !hideTableView
            todayLabel.text = TodayViewController.dateFormatter.stringFromDate(now)
            self.tableView?.reloadData()
        }
    }
    
    @IBAction
    func datePickerChanged(sender: AnyObject) {
        resolveTimetable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView!.rowHeight = UITableViewAutomaticDimension
        tableView!.estimatedRowHeight = 64
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    var first: Bool = true
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        first = true
        modelListener = ModelListener(onUserChanged: nil, onWorkChanged: nil, onTimetableChanged: { [unowned self] timetable in
            self.reloadTimetable(timetable!)
        }, onPicReceived: nil, onMotdReceived: nil)
        Model.get().listen(modelListener)
        let selection = tableView?.indexPathForSelectedRow
        if let selection = selection {
            tableView?.deselectRowAtIndexPath(selection, animated: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadTimetable(timetable!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        first = false
        Model.get().pubSub.remove(modelListener)
        modelListener = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return state == .Hidden ? 0 : 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == 0 && state != .Hidden)
        return state == .Today ? today!.count : next!.1.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        assert(section == 0 && state != .Hidden)
        return state == .Today ? "Today" : next!.0.description
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView!.contentInset = UIEdgeInsets(
            top: topLayoutGuide.length,
            left: 0.0,
            bottom: bottomLayoutGuide.length,
            right: 0.0
        )
        tableView!.scrollIndicatorInsets = UIEdgeInsets(
            top: topLayoutGuide.length,
            left: 0.0,
            bottom: bottomLayoutGuide.length,
            right: 0.0
        )
    }
    
    var lowestInset: CGFloat = 100.0
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard today != nil else {
            return 0.0
        }
        if today!.isEmpty {
            todaySubLabel.hidden = false
            if hadEvents {
                todaySubLabel.text = "No more events today"
            } else {
                todaySubLabel.text = "No events today"
            }
            return todaySubLabel.frame.maxY
        } else {
            todaySubLabel.hidden = true
            return todayLabel.frame.maxY
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventTableViewCell", forIndexPath: indexPath) as! EventTableViewCell
        
        let event: Event
        switch state {
        case .Today:
            event = today![indexPath.row]
        case .Next:
            event = next!.1[indexPath.row]
        default:
            fatalError()
        }
        cell.setEventAs(event, state: state, now: now)
        let currentInset = cell.exampleTime!.frame.maxX + 10
        lowestInset = min(lowestInset, currentInset)
        tableView.separatorInset.left = lowestInset
        // Configure the cell...

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let subject: Subject
        switch state {
        case .Today:
            subject = today![indexPath.row].subject!
        case .Next:
            subject = next!.1[indexPath.row].subject!
        default:
            fatalError()
        }
        performSegueWithIdentifier("todayToNotesSegue", sender: subject)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "todayToNotesSegue" {
            let notesVC = segue.destinationViewController as! NotesViewController
            let subject = sender as! Subject
            notesVC.setSubjectAs(subject)
            return
        }
        fatalError()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
