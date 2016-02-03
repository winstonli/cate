//
//  ResourceViewController.swift
//  cate
//
//  Created by Winston Li on 24/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit
import Alamofire

class ResourceViewController: UIViewController, UIWebViewDelegate {

    static let mime: [String: String] = [
        "application/ppt": "ppt",
        "application/pptx": "pptx",
        "application/doc": "doc",
        "application/docx": "docx",
        "application/xls": "xls",
        "application/xlsx": "xlsx"
    ]
    
    @IBOutlet
    weak var nameLabel: UILabel!
    
    @IBOutlet
    weak var subjectNameLabel: UILabel!
    
    @IBOutlet
    weak var webView: UIWebView?
    
    @IBOutlet
    weak var spinner: UIActivityIndicatorView?
    
    @IBOutlet
    weak var backButton: UIBarButtonItem?
    
    @IBOutlet
    weak var forwardButton: UIBarButtonItem?
    
    var resource: Resource?
    
    var needsLoading: Bool = false
    
    @IBOutlet
    weak var toolbar: UIToolbar?
    
    @IBOutlet
    weak var constraintWithToolbar: NSLayoutConstraint?
    
    @IBOutlet
    weak var constraintWithoutToolbar: NSLayoutConstraint?
    
    var lastOfficeFile: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setResourceAs(resource: Resource) {
        self.resource = resource
        needsLoading = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = resource?.name
        subjectNameLabel.text = resource?.subjectName
        if needsLoading {
            tryLoad(animated)
            needsLoading = false
        }
    }
    
    private func tryLoad(animated: Bool) {
        let auth = Model.get().auth
        guard auth != nil else {
            return
        }
        let user = auth!.username
        let pass = auth!.password
        if let resource = resource {
            
            if animated {
                startSpin()
            }
            if let fileType = resource.fileType {
                if fileType == "url" {
                    webView?.loadRequest(NSURLRequest(URL: NSURL(string: resource.url)!))
                    toolbar?.hidden = false
                    constraintWithToolbar?.active = true
                    constraintWithoutToolbar?.active = false
                    return
                }
            }
            toolbar?.hidden = true
            constraintWithToolbar?.active = false
            constraintWithoutToolbar?.active = true
            let u = NSURL(string: resource.url)!
            let baseUrl = NSURL(string: "/", relativeToURL: u)!.absoluteURL
            let request = Alamofire.request(.GET, resource.url)
            let auth: Alamofire.Request;
            let isAuthingToCate = baseUrl.absoluteString.hasPrefix("https://cate.doc.ic.ac.uk")
            if isAuthingToCate {
                auth = request.authenticate(user: user, password: pass)
            } else {
                auth = request
            }
            auth.responseData { [weak self] response in
                let statusCode: Int? = response.response?.statusCode ?? response.result.error?.code
                guard statusCode != nil && statusCode > 0 && (statusCode! < 400 || statusCode! > 499) else {
                    if animated {
                        self?.stopSpin()
                    }
                    if isAuthingToCate {
                        Model.get().onAuthKick()
                    } else {
                        self?.receivedAuthErrorForUrl(resource.url)
                    }
                    return
                }
                guard response.data != nil && response.response != nil && response.response!.MIMEType != nil else {
                    if animated {
                        self?.stopSpin()
                    }
                    self?.receivedErrorForUrl(resource.url)
                    return
                }
                if response.result.isSuccess && response.data != nil {
                    let mime = response.response!.MIMEType!
                    if let ext = ResourceViewController.mime[mime] {
                        self?.tryDeleteLastFile()
                        let path = "\(NSTemporaryDirectory())\(resource.name)_\(resource.subjectName).\(ext)"
                        response.data!.writeToFile(path, atomically: true)
                        self?.lastOfficeFile = path
                        let fileUrl = NSURL(fileURLWithPath: path)
                        let fileUrlRequest = NSURLRequest(URL: fileUrl)
                        self?.webView?.loadRequest(fileUrlRequest)
                        return
                    }
                    self?.webView?.loadData(response.data!, MIMEType: response.response!.MIMEType!, textEncodingName: "utf-8", baseURL: baseUrl)
                    if animated {
                        self?.stopSpin()
                    }
                } else {
                    self?.tryLoad(animated)
                }
            }
        }
    }
    
    private func tryDeleteLastFile() {
        if let lastOfficeFile = self.lastOfficeFile {
            _ = try? NSFileManager.defaultManager().removeItemAtPath(lastOfficeFile)
            self.lastOfficeFile = nil
        }
    }
    
    func receivedAuthErrorForUrl(url: String) {
        makeAlertToOpenInSafari(url, title: "Authentication Error", message: "\(url)\n\nThe external URL failed with an authentication error. Cate will never send your authentication details to an external site.", cancel: "Cancel")
    }
    
    func receivedErrorForUrl(url: String) {
        makeAlertToOpenInSafari(url, title: "Error Loading Page", message: "There was an error loading \(url)", cancel: "Cancel")
    }
    
    func makeAlertToOpenInSafari(url: String, title: String, message: String, cancel: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "Open in Safari", style: .Default, handler: { [weak self] action in
            self?.goBack()
            self?.openUrl(url)
        })
        let cancelAction = UIAlertAction(title: cancel, style: .Cancel, handler: { [weak self] action in
            self?.goBack()
        })
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction
    func refreshButtonPressed(sender: AnyObject) {
        webView?.reload()
    }
    
    @IBAction
    func backButtonPressed(sender: AnyObject) {
        webView?.goBack()
    }
    
    @IBAction
    func forwardButtonPressed(sender: AnyObject) {
        webView?.goForward()
    }
    
    
    @IBAction
    func safariButtonPressed(sender: AnyObject) {
        openUrl(resource!.url)
    }
    
    private func openUrl(url: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    private func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func startSpin() {
        spinner?.startAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    private func stopSpin() {
        spinner?.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        stopSpin()
        tryDeleteLastFile()
        backButton?.enabled = webView.canGoBack
        forwardButton?.enabled = webView.canGoForward
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        backButton?.enabled = webView.canGoBack
        forwardButton?.enabled = webView.canGoForward
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        tryDeleteLastFile()
        stopSpin()
        backButton?.enabled = webView.canGoBack
        forwardButton?.enabled = webView.canGoForward
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        backButton?.enabled = webView.canGoBack
        forwardButton?.enabled = webView.canGoForward
        return true
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
