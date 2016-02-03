//
//  TutorialsVC.swift
//  cate
//
//  Created by Winston Li on 22/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

class TutorialsViewController: UITableViewController {

    var modelListener: ModelListener!
    
    var relevantSubjects: [Subject]?
    var tutorialsPerSubject: [[Tutorial]]?
    
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
            self.relevantSubjects = work?.subjects.filter({ subject in
                !subject.notes.isEmpty || (!subject.tutorials.filter({ tutorial in
                    tutorial.specUrl != nil
                }).isEmpty)
            })
            var tutorialsPerSubject: [[Tutorial]] = []
            self.relevantSubjects!.forEach({ subject in
                tutorialsPerSubject.append(subject.tutorials.filter({ tutorial in
                    tutorial.specUrl != nil
                }))
            })
            self.tutorialsPerSubject = tutorialsPerSubject
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard relevantSubjects != nil else {
            return 0
        }
        return relevantSubjects!.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let subject = relevantSubjects![indexPath.section]
        let index = subject.notes.isEmpty ? indexPath.row : indexPath.row - 1
        if index < 0 {
            performSegueWithIdentifier("tutorialsToNotesSegue", sender: subject)
        } else {
            performSegueWithIdentifier("tutorialsToResourceSegue", sender: tutorialsPerSubject![indexPath.section][index])
        }
    }
    
    /* TODO: hide those without spec */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "tutorialsToNotesSegue":
            let notesVC = segue.destinationViewController as! NotesViewController
            let subject = sender as! Subject
            notesVC.setSubjectAs(subject)
        case "tutorialsToResourceSegue":
            let resourceVC = segue.destinationViewController as! ResourceViewController
            let tutorial = sender as! Tutorial
            resourceVC.setResourceAs(tutorial.createResource())
        default:
            fatalError("invalid segue")
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard relevantSubjects != nil && tutorialsPerSubject != nil else {
            return 0
        }
        let subject = relevantSubjects![section]
        let notes = subject.notes.isEmpty ? 0 : 1
        return tutorialsPerSubject![section].count + notes
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let subject = relevantSubjects![section]
        let name = subject.name
        if tutorialsPerSubject![section].isEmpty {
            return name
        }
        return "\(name) (\(tutorialsPerSubject![section].count))"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tutorialTableViewCell", forIndexPath: indexPath) as! TutorialTableViewCell
        let subject = relevantSubjects![indexPath.section]
        let tutorials: [Tutorial] = tutorialsPerSubject![indexPath.section]
        
        let row = indexPath.row
        
        if subject.notes.isEmpty {
            cell.setTutorial(tutorials[row])
        } else {
            if row == 0 {
                cell.setNotes()
            } else {
                cell.setTutorial(tutorials[row - 1])
            }
        }

        return cell
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
