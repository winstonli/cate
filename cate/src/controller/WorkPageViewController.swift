//
//  WorkPageVC.swift
//  cate
//
//  Created by Winston Li on 16/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import UIKit

class WorkPageViewController: UIPageViewController,
                              UIPageViewControllerDataSource,
                              UIPageViewControllerDelegate,
                              UIScrollViewDelegate {

    var pages: [UIViewController]! = nil
    
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        delegate = self
        dataSource = self
        
        let page1: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("deadlines")
        let page2: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("tutorials")
        pages = [page1, page2];
        
        setViewControllers([page1], direction: .Forward, animated: false, completion: nil)
        
        navigationItem.title = "Deadlines"
        
        for v in view.subviews {
            if v.isKindOfClass(UIScrollView) {
                (v as! UIScrollView).delegate = self
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if (viewController == pages[0]) {
            return nil
        } else if (viewController == pages[1]) {
            return pages[0]
        }
        fatalError("unknown view controller: " + viewController.description)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if (viewController == pages[0]) {
            return pages[1];
        } else if (viewController == pages[1]) {
            return nil;
        }
        fatalError("unknown view controller: " + viewController.description);
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let fromPage = currentPage
            currentPage = 1 - pages.indexOf(previousViewControllers[0])!
            onPageChange?(fromPage, currentPage)
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let total = view.frame.width
        let percentage: CGFloat
        if currentPage == 0 {
            percentage = (scrollView.contentOffset.x - total) / total
        } else {
            percentage = (total - scrollView.contentOffset.x) / total
        }
        onScroll?(percentage, currentPage, 1 - currentPage)
    }
    
    var onScroll: ((CGFloat, Int, Int) -> ())?
    var onPageChange: ((Int, Int) -> ())?
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
