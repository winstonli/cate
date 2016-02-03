//
//  ProfileViewController.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit



class ProfileViewController: UITableViewController {
    
    @IBOutlet
    weak var name: UILabel?

    @IBOutlet
    weak var course: UILabel?
    
    @IBOutlet
    weak var motdView: UITextView?
    
    var modelListener: ModelListener!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        modelListener = ModelListener(onUserChanged: { [weak self] user in
            
            if let user = user {
                self?.name?.text = "\(user.firstName!) \(user.lastName!)"
                self?.course?.text = user.getCourseDescription()
            }
            
        }, onWorkChanged: nil, onTimetableChanged: nil, onPicReceived: nil, onMotdReceived: { [weak self] motd in
                
            self?.motdView?.text = motd
                
        })
        Model.get().listen(modelListener)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Model.get().pubSub.remove(modelListener)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let logoutAlert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Logout", style: .Destructive, handler: { (_) in
            Model.get().doLogout()
        }))
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { _ in
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }))
        logoutAlert.popoverPresentationController?.sourceView = cell
        logoutAlert.popoverPresentationController?.sourceRect = CGRect(origin: cell.contentView.center, size: CGSize(width: 1, height: 1))
        presentViewController(logoutAlert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
