//
//  MainTabBarVC.swift
//  cate
//
//  Created by Winston Li on 22/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    var modelStateListener: StateListener<ModelState>!
    
    @IBOutlet
    weak var pageVCNavView: UIView?
    
    @IBOutlet
    weak var todayNavView: UIView?
    
    @IBOutlet
    weak var deadlinesLabel: UILabel?
    
    @IBOutlet
    weak var deadlinesCenterX: NSLayoutConstraint?
    
    @IBOutlet
    weak var tutorialsLabel: UILabel?
    
    @IBOutlet
    weak var tutorialsCenterX: NSLayoutConstraint?
    
    @IBOutlet
    weak var pageControl: UIPageControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        modelStateListener = StateListener<ModelState>(onStateChanged: { [unowned self] (from, to) in
            if from != nil && from != to && to == .Auth {
                self.selectedIndex = 0
            }
        })
        Model.get().stateMachine.listen(modelStateListener)
        setNavViewForTabIndex(selectedIndex)
        let pageVC = viewControllers![0] as! WorkPageViewController
        self.tutorialsLabel?.alpha = 0.0
        pageVC.onScroll = { [weak self] (percent, fromPage, toPage) in
            let enteringOffset = ((1 - percent) * self!.pageVCNavView!.frame.width / 2)
            let exitingOffset = percent < 0.0 ? ((percent / 2) * self!.pageVCNavView!.frame.width / 2) : (percent * self!.pageVCNavView!.frame.width / 2)
            let enteringAlpha = percent < 0.25 ? 0 : min(1.0, (percent - 0.25) * 4)
            let exitingAlpha = percent < 0.25 ? 1 : max(0.0, 1 - ((percent - 0.25) * 4))
            switch fromPage {
            case 0:
                self?.deadlinesCenterX?.constant = -exitingOffset
                self?.deadlinesLabel?.alpha = exitingAlpha
                self?.tutorialsCenterX?.constant = enteringOffset
                self?.tutorialsLabel?.alpha = enteringAlpha
            case 1:
                self?.deadlinesCenterX?.constant = -enteringOffset
                self?.deadlinesLabel?.alpha = enteringAlpha
                self?.tutorialsCenterX?.constant = exitingOffset
                self?.tutorialsLabel?.alpha = exitingAlpha
            default:
                fatalError()
            }
        }
        pageVC.onPageChange = { [weak self] (fromPage, toPage) in
            self?.pageControl?.currentPage = toPage
        }
        let currentPage = pageVC.currentPage
        pageVC.onScroll!(0.0, currentPage, 1 - currentPage)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Model.get().stateMachine.unlisten(modelStateListener)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setNavViewForTabIndex(index: Int) {
        let hide = [todayNavView, pageVCNavView]
        let show = [pageVCNavView, todayNavView]
        hide[index]?.hidden = true
        show[index]?.hidden = false
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        setNavViewForTabIndex(tabBar.items!.indexOf(item)!)
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

