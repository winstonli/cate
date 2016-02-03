//
//  DeadlinesVC.swift
//  cate
//
//  Created by Winston Li on 22/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

class DeadlinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var modelListener: ModelListener!
    
    var deadlines: [Deadline]?
    var submitted: [Deadline]?
    var upcoming: [Upcoming]?
    
    var sections: [[AnyObject]]?
    
    @IBOutlet
    weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 64
        once = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        modelListener = ModelListener(onUserChanged: nil, onWorkChanged: { [unowned self] work in
            guard work != nil else {
                return
            }
            let work = work!
            let deadlines: [Deadline] = work.deadlines.filter({ deadline in
                !deadline.submitted
            })
            let submitted = work.deadlines.filter({ deadline in
                deadline.submitted
            })
            let upcoming = work.upcoming
            self.deadlines = deadlines
            self.submitted = submitted
            self.upcoming = upcoming
            self.sections = submitted.isEmpty ? [deadlines, upcoming] : [deadlines, submitted, upcoming]
            self.tableView?.reloadData()
        }, onTimetableChanged: nil, onPicReceived: nil, onMotdReceived: nil)
        Model.get().listen(modelListener)
        let selection = tableView?.indexPathForSelectedRow
        if let selection = selection {
            tableView?.deselectRowAtIndexPath(selection, animated: true)
        }
    }
    
    var once = true
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView!.contentInset = UIEdgeInsets(top: self.parentViewController!.topLayoutGuide.length, left: 0, bottom: self.parentViewController!.bottomLayoutGuide.length, right: 0)
        tableView!.scrollIndicatorInsets = UIEdgeInsets(top: self.parentViewController!.topLayoutGuide.length, left: 0, bottom: self.parentViewController!.bottomLayoutGuide.length, right: 0)
        if once {
            tableView?.setContentOffset(CGPoint(x: 0, y: -self.parentViewController!.topLayoutGuide.length), animated: false)
            once = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
        guard submitted != nil else {
            return 0 /* Happens on initial load if nobody is logged in */
        }
        return submitted!.isEmpty ? 2 : 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections![section].count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("deadlineTableViewCell", forIndexPath: indexPath) as! DeadlineTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.setDeadline(deadlines?[indexPath.row])
        case 1:
            if submitted!.isEmpty {
                cell.setUpcoming(upcoming?[indexPath.row])
            } else {
                cell.setDeadline(submitted?[indexPath.row])
            }
        case 2:
            cell.setUpcoming(upcoming?[indexPath.row])
        default:
            fatalError("invalid section: \(indexPath.section)")
        }
        // Configure the cell...

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.section == 0 || indexPath.section == 1 && !submitted!.isEmpty else {
            return
        }
        let deadline = sections![indexPath.section][indexPath.row]
        performSegueWithIdentifier("deadlineToExerciseSegue", sender: deadline)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "deadlineToExerciseSegue" && segue.destinationViewController.isKindOfClass(ExerciseViewController) {
            let exerciseVC = segue.destinationViewController as! ExerciseViewController
            let deadline = sender as! Deadline
            exerciseVC.setExerciseAs(deadline)
            return
        }
        fatalError("unknown segue")
    }
    
    static let sectionTitles: [String] = ["Deadlines (%i)", "Later this term (%i)"]
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let count: Int
        switch section {
        case 0:
            count = deadlines!.count
            if count == 0 {
                return "No deadlines"
            } else {
                return "Deadlines (\(count))"
            }
        case 1:
            if submitted!.isEmpty {
                fallthrough
            } else {
                return "Submitted"
            }
        case 2:
            count = upcoming!.count
            if count == 0 {
                return "No more deadlines this term"
            } else {
                return "Later this term"
            }
        default:
            fatalError("invalid section \(section)")
        }
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
