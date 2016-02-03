//
//  ExerciseViewController.swift
//  cate
//
//  Created by Winston Li on 24/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

class ExerciseViewController: UITableViewController {

    @IBOutlet
    weak var exerciseNameLabel: UILabel?
    @IBOutlet
    weak var subjectNameLabel: UILabel?
    
    var deadline: Deadline?
    
    func setExerciseAs(deadline: Deadline) {
        self.deadline = deadline
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        exerciseNameLabel?.text = deadline?.name
        subjectNameLabel?.text = deadline?.subject?.name
        let selection = tableView?.indexPathForSelectedRow
        if let selection = selection {
            tableView?.deselectRowAtIndexPath(selection, animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.deadline != nil else {
            return 0
        }
        let deadline = self.deadline!
        switch section {
        case 0:
            return deadline.specUrl == nil ? 0 : 1
        case 1:
            return deadline.subject!.notes.count
        default:
            fatalError("unknown section \(section)")
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exerciseTableViewCell", forIndexPath: indexPath) as! ExerciseTableViewCell

        let section = indexPath.section
        switch section {
        case 0:
            cell.setSpec()
        case 1:
            cell.setNote(deadline!.subject!.notes[indexPath.row])
        default:
            fatalError("invalid section \(section)")
        }
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return deadline?.specUrl == nil ? "No spec available" : "Spec"
        case 1:
            let count = deadline!.subject!.notes.filter({ note in
                note.specLink != nil
            }).count
            return count == 0 ? "No notes available" : "Notes (\(count))"
        default:
            fatalError("unknown section \(section)")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let resource: Resource
        let section = indexPath.section
        switch section {
        case 0:
            resource = deadline!.createResource()
        case 1:
            resource = deadline!.subject!.notes[indexPath.row].createResource()
        default:
            fatalError("unknown section \(section)")
        }
        performSegueWithIdentifier("exerciseToResourceSegue", sender: resource)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "exerciseToResourceSegue" && segue.destinationViewController.isKindOfClass(ResourceViewController) {
            let resourceVC = segue.destinationViewController as! ResourceViewController
            let resource = sender as! Resource
            resourceVC.setResourceAs(resource)
            return
        }
        fatalError("unknown segue")
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
