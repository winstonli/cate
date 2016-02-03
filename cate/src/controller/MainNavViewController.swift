//
//  MainNavViewController.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

class MainNavViewController: UINavigationController {

    var modelListener: StateListener<ModelState>!
    
    var resetListener: StateListener<ModelState>!
    
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
        resetListener = StateListener<ModelState>(onStateChanged: { [unowned self] (from, to) in
            if to == .Auth && from != to {
                self.popToRootViewControllerAnimated(false)
            }
        })
        Model.get().stateMachine.listen(resetListener)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Model.get().stateMachine.unlisten(resetListener)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        modelListener = StateListener<ModelState>(onStateChanged: { [unowned self] (from, to) in
            if to == .NoAuth {
                self.performSegueWithIdentifier("presentLoginScreen", sender: self)
            } else if to == .Kick {
                let alert = UIAlertController(title: "Password Changed", message: "Your Imperial password has changed.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Login", style: .Default, handler: { (action) in
                    Model.get().stateMachine.state = .NoAuth
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        Model.get().stateMachine.listen(modelListener)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        Model.get().stateMachine.unlisten(modelListener)
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
