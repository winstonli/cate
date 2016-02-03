//
//  LoginViewController.swift
//  cate
//
//  Created by Winston Li on 22/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

enum LoginState {
    case FormReady
    case FormWaiting
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet
    weak var username: UITextField?
    
    @IBOutlet
    weak var password: UITextField?
    
    @IBOutlet
    weak var button: UIButton?
    
    @IBOutlet
    weak var spinner: UIActivityIndicatorView?
    
    var stateMachine: StateMachine<LoginState>!
    
    var loginStateListener: StateListener<LoginState>!
    
    var modelStateListener: StateListener<ModelState>!
    
    var loginTimer: NSTimer?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doInit()
    }
    
    func doInit() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stateMachine = StateMachine<LoginState>(state: .FormReady)
        loginStateListener = StateListener<LoginState>(onStateChanged: { [unowned self] (from, to) in
            if let f: LoginState = from {
                if f != to {
                    switch to {
                    case .FormReady:
                        self.username?.enabled = true
                        self.password?.enabled = true
                        self.setLoginButtonEnabled()
                    case .FormWaiting:
                        self.username?.enabled = false
                        self.password?.enabled = false
                        self.setLoginButtonEnabled()
                    }
                }
            }
            
        }
        )
        modelStateListener = StateListener<ModelState>(onStateChanged: { [unowned self] (from, to) in
            switch to {
            case .NoAuth:
                self.spinner?.stopAnimating()
                self.button?.hidden = false
                self.stateMachine.state = .FormReady
            case .AuthPendingUser:
                self.spinner?.startAnimating()
                self.button?.hidden = true
            case .AuthPendingData:
                self.spinner?.startAnimating()
                self.button?.hidden = true
            case .Auth:
                self.spinner?.stopAnimating()
                self.button?.hidden = false
                self.dismissViewControllerAnimated(true, completion: {
                    self.stateMachine.state = .FormReady
                })
            default:
                break
            }
            if from == .Failed {
                let alert = UIAlertController(title: "Invalid Login", message: "The username or password you entered is incorrect. Try again.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        )
        stateMachine.listen(loginStateListener)
        Model.get().stateMachine.listen(modelStateListener)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stateMachine.unlisten(loginStateListener)
        Model.get().stateMachine.unlisten(modelStateListener)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBOutlet
    weak var kbHeight: NSLayoutConstraint!
    
    var oldKbHeight: CGFloat?
    
    func keyboardWillChangeFrame(n: NSNotification) {
        if let kbHeight = n.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height {
            if oldKbHeight != nil && abs(kbHeight - oldKbHeight!) >= 100 {
                self.kbHeight.constant = kbHeight
                view.layoutIfNeeded()
            }
            oldKbHeight = kbHeight
        }
    }
    
    func keyboardWillHide(n: NSNotification) {
        self.kbHeight.constant = 0
        view.layoutIfNeeded()
    }
    
    @IBAction
    func textFieldChanged(sender: AnyObject) {
        setLoginButtonEnabled()
    }
    
    private func setLoginButtonEnabled() {
        button?.enabled = !username!.text!.isEmpty && !password!.text!.isEmpty
    }
    
    @IBAction
    func loginButtonPressed() {
        guard username?.text != "abc99" else {
            let abc99 = UIAlertController(title: "Hilarious", message: "Do you have friends?", preferredStyle: .Alert)
            abc99.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
            abc99.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
            presentViewController(abc99, animated: true, completion: nil)
            return
        }
        stateMachine.state = .FormWaiting
        Model.get().doLogin(username!.text!, password: password!.text!)
        loginTimer?.invalidate()
        loginTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "loginTimeout", userInfo: nil, repeats: false)
    }
    
    func loginTimeout() {
        if stateMachine.state == .FormWaiting {
            let alert = UIAlertController(title: "Login Failed", message: "Unable to reach the network. Try again later.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            Model.get().onConnectTimeout()
        }
    }
    
    @IBAction
    func usernameFieldNext(sender: AnyObject) {
        password?.becomeFirstResponder()
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
