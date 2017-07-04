//
//  ViewPager.swift
//  Pager
//
//  Created by Lucas Oceano on 12/03/2015.
//  Copyright (c) 2015 Cheesecake. All rights reserved.
//

import Foundation
import UIKit.UITableView

public enum PagerTabLocation: Int {
    case None = 0
    case Top = 1
    case Bottom = 2
}

public enum PagerAnimation: Int {
    case None = 0
    case End = 1
    case During = 2
}

@objc public protocol PagerDelegate: NSObjectProtocol {
    @objc optional func didChangeTabToIndex(pager: PagerController, index: Int)
    @objc optional func didChangeTabToIndex(pager: PagerController, index: Int, previousIndex: Int)
    @objc optional func didChangeTabToIndex(pager: PagerController, index: Int, previousIndex: Int, swipe: Bool)
}


@objc public protocol PagerDataSource: NSObjectProtocol {
    func numberOfTabs(pager: PagerController) -> Int
    func tabViewForIndex(index: Int, pager: PagerController) -> UIView
    @objc optional func viewForTabAtIndex(index: Int, pager: PagerController) -> UIView
    @objc optional func controllerForTabAtIndex(index: Int, pager: PagerController) -> UIViewController
}


public class PagerController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    //public properties
    public var contentViewBackgroundColor: UIColor = UIColor.white
    public var indicatorColor: UIColor = UIColor.red
    public var tabsViewBackgroundColor: UIColor = UIColor.init(red: 0.50, green: 0.47, blue: 0.49, alpha: 1)
    public var dataSource: PagerDataSource!
    public var delegate: PagerDelegate?
    public var tabHeight: CGFloat = 44.0
    public var tabOffset: CGFloat = 56.0
    public var tabWidth: CGFloat = 128.0
    public var indicatorHeight: CGFloat = 5.0
    public var tabLocation: PagerTabLocation = PagerTabLocation.Top
    public var animation: PagerAnimation = PagerAnimation.During
    public var startFromSecondTab: Bool = false
    public var centerCurrentTab: Bool = false
    public var fixFormerTabsPositions: Bool = false
    public var fixLaterTabsPosition: Bool = false
    
    
    // Tab and content stuff
    internal var tabsView: UIScrollView?
    internal var pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    internal var actualDelegate: UIScrollViewDelegate?
    internal var contentView: UIView {
        let contentView = self.pageViewController.view
        contentView!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView!.backgroundColor = self.contentViewBackgroundColor
        contentView!.bounds = self.view.bounds
        contentView!.tag = 34
        
        return contentView!
    }
    
    
    // Tab and content cache
    internal var underlineStroke: UIView = UIView()
    internal var tabs: [UIView?] = []
    internal var contents: [UIViewController?] = []
    internal var tabCount: Int = 0
    internal var activeTabIndex: Int = 0
    internal var activeContentIndex: Int = 0
    internal var animatingToTab: Bool = false
    internal var defaultSetupDone: Bool = false
    internal var didTapOnTabView: Bool = false
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.defaultSettings()
    }
    
    
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.defaultSetupDone {
            self.defaultSetup()
        }
    }
    
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.layoutSubViews()
    }

    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func defaultSettings() {
        if let subViews = self.pageViewController.view?.subviews {
        
            for view in subViews{
                if let _ = view as? UIScrollView {
                    self.actualDelegate = (view as! UIScrollView).delegate
                    (view as! UIScrollView).delegate = self
                }
            }
        }
        
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
    }
    
    
    func defaultSetup() {
        // Empty tabs and contents
//        for tabView: UIView? in self.tabs! {
//            tabView.removeFromSuperview()
//        }
        
        self.tabs.removeAll(keepingCapacity: true)
        self.contents.removeAll(keepingCapacity: true)
        self.underlineStroke.removeFromSuperview()
        
        // Get tabCount from dataSource
        self.tabCount = self.dataSource!.numberOfTabs(pager: self)
        
        // Populate arrays with nil
        self.tabs = Array(repeating: nil, count: self.tabCount)
        for _ in 0 ..< self.tabCount{
        //for (var i: Int = 0; i < self.tabCount; i += 1) {
            self.tabs.append(nil)
        }
        
        self.contents = Array(repeating: nil, count: self.tabCount)
        for _ in 0 ..< self.tabCount{
        //for (var i: Int = 0; i < self.tabCount; i += 1) {
            self.contents.append(nil)
        }
        
        // Add tabsView
        if self.tabsView == nil {
            
            self.tabsView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.tabHeight))
            self.tabsView!.autoresizingMask = .flexibleWidth
            self.tabsView!.backgroundColor = self.tabsViewBackgroundColor
            self.tabsView!.scrollsToTop = false
            self.tabsView?.bounces = false
            self.tabsView!.showsHorizontalScrollIndicator = false
            self.tabsView!.showsVerticalScrollIndicator = false
            self.tabsView!.tag = 38
            
            self.view.insertSubview(self.tabsView!, at: 0)
        } else {
            self.tabsView = self.view.viewWithTag(38) as? UIScrollView
        }
        
        // Add tab views to _tabsView
        var contentSizeWidth: CGFloat = 0.0
        
        // Give the standard offset if fixFormerTabsPositions is provided as YES
        if (self.fixFormerTabsPositions) {
            // And if the centerCurrentTab is provided as YES fine tune the offset according to it
            if (self.centerCurrentTab) {
                contentSizeWidth = (self.tabsView!.frame.width - self.tabWidth) / 2.0
            } else {
                contentSizeWidth = self.tabOffset
            }
        }
        
        
        //for (var i: Int = 0; i < self.tabCount; i++) {
        for i in 0 ..< self.tabCount {
            let tabView: UIView? = self.tabViewAtIndex(index: i) as UIView?
            var frame: CGRect = tabView!.frame
            frame.origin.x = contentSizeWidth
            frame.size.width = self.tabWidth
            tabView!.frame = frame
            
            self.tabsView!.addSubview(tabView!)
            
            contentSizeWidth += tabView!.frame.width
            
            // To capture tap events
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PagerController.handleTapGesture(sender:)))
            tabView!.addGestureRecognizer(tapGestureRecognizer)
        }
        
        
        // Extend contentSizeWidth if fixLatterTabsPositions is provided YES
        if (self.fixLaterTabsPosition) {
            // And if the centerCurrentTab is provided as YES fine tune the content size according to it
            if (self.centerCurrentTab) {
                contentSizeWidth += (self.tabsView!.frame.width - self.tabWidth) / 2.0
            } else {
                contentSizeWidth += self.tabsView!.frame.width - self.tabWidth - self.tabOffset
            }
        }
        
        self.tabsView!.contentSize = CGSize(width: contentSizeWidth, height: self.tabHeight)
        
        self.view.insertSubview(self.contentView, at: 0)
        
        // Select starting tab
        let index: Int = self.startFromSecondTab ? 1 : 0
        self.selectTabAtIndex(index: index, swipe: true)
        
        if (self.tabCount > 0) {
            //creates the indicator
            var rect: CGRect = self.tabViewAtIndex(index: self.activeContentIndex)!.frame
            rect.origin.y = rect.size.height - self.indicatorHeight
            rect.size.height = self.indicatorHeight
            
            self.underlineStroke = UIView(frame: rect)
            self.underlineStroke.backgroundColor = self.indicatorColor
            self.tabsView!.addSubview(self.underlineStroke)
        }
        
        // Set setup done
        self.defaultSetupDone = true
    }
    
    
    func layoutSubViews() {
        let topLayoutGuide: CGFloat = 0.0
//        if  (self.navigationController?.navigationBar.translucent != false) {
//            topLayoutGuide = UIApplication.sharedApplication().statusBarHidden ? 0.0 : 20.0
//            topLayoutGuide += self.navigationController!.navigationBar.frame.size.height
//        }
        if self.tabsView != nil {
            var frame: CGRect = self.tabsView!.frame
            frame.origin.x = 0.0
            frame.origin.y = (self.tabLocation == .Top) ? topLayoutGuide : self.view.frame.height - self.tabHeight
            frame.size.width = self.view.frame.width
            frame.size.height = self.tabHeight
            self.tabsView!.frame = frame
            
            frame = self.contentView.frame
            frame.origin.x = 0.0
            frame.origin.y = (self.tabLocation == .Top) ? topLayoutGuide + self.tabsView!.frame.height : topLayoutGuide
            frame.size.width = self.view.frame.width
            
            frame.size.height = self.view.frame.height - (topLayoutGuide + self.tabsView!.frame.height)
            
            if (self.tabBarController != nil) {
                frame.size.height -= self.tabBarController!.tabBar.frame.height
            }
            
            self.contentView.frame = frame

        }
    }
    
    
    @IBAction func handleTapGesture(sender: UITapGestureRecognizer) {
        let tabView: UIView = sender.view!
        
        let index: Int = self.tabs.find {
            $0 as UIView? == tabView
            }!
        
        if (self.activeTabIndex != index) {
            self.selectTabAtIndex(index: index)
        }
    }
    
    
    public func reloadData() {
        self.defaultSetup()
        self.view.setNeedsDisplay()
    }
    
    
    public func selectTabAtIndex(index: Int) {
        self .selectTabAtIndex(index: index, swipe: false)
    }
    
    
    func indexForViewController(viewController: UIViewController) -> Int {
        for (index, element) in self.contents.enumerated() {
            if (element == viewController) {
                return index
            }
        }
        return 0
    }
    
    
    func selectTabAtIndex(index: Int, swipe: Bool) {
        if (index >= self.tabCount) {
            return
        }

        
        
        for view in (self.tabs[0]?.subviews)!{
            if let v = view as? UILabel {
                v.textColor = UIColor.white
            }
        }
        
        for view in (self.tabs[1]?.subviews)!{
            if let v = view as? UILabel {
                v.textColor = UIColor.white
            }
        }
        
        for view in (self.tabs[0]?.subviews)!{
            if view.tag == index{
                (view as! UILabel).textColor = UIColor(red: 212, green: 172, blue: 92)
            }
        }
        
        
        for view in (self.tabs[1]?.subviews)!{
            if view.tag == index{
                (view as! UILabel).textColor = UIColor(red: 212, green: 172, blue: 92)
            }
        }

        
        self.didTapOnTabView = !swipe
        self.animatingToTab = true
        
        let previousIndex: Int = self.activeTabIndex
        
        self.changeActiveTabIndex(newIndex: index)
        self.setActiveContentIndexValue(activeContentIndex: index)
        
        if self.delegate != nil {
            if (self.delegate!.responds(to: Selector(("didChangeTabToIndex:didChangeTabToIndex:")))) {
                self.delegate!.didChangeTabToIndex!(pager: self, index: index)
            } else if (self.delegate!.responds(to: Selector(("didChangeTabToIndex:didChangeTabToIndex:fromIndex:")))) {
                self.delegate!.didChangeTabToIndex!(pager: self, index: index, previousIndex: previousIndex)
            } else if (self.delegate!.responds(to: Selector(("didChangeTabToIndex:didChangeTabToIndex:fromIndex:didSwipe:")))) {
                self.delegate!.didChangeTabToIndex!(pager: self, index: index, previousIndex: previousIndex, swipe: swipe)
            }
        }
    }
    
    
    func changeActiveTabIndex(newIndex: Int) {
        
        self.activeTabIndex = newIndex
        
        let tabView: UIView = self.tabViewAtIndex(index: self.activeTabIndex)!
        var frame: CGRect = tabView.frame
        
        if (self.centerCurrentTab) {
            frame.origin.x += (frame.width / 2)
            frame.origin.x -= (self.tabsView!.frame.width / 2)
            
            if (frame.origin.x < 0) {
                frame.origin.x = 0
            }
            
            if ((frame.origin.x + frame.width) > self.tabsView!.contentSize.width) {
                frame.origin.x = (self.tabsView!.contentSize.width - self.tabsView!.frame.width)
            }
        } else {
            frame.origin.x -= self.tabOffset
            frame.size.width = self.tabsView!.frame.width
        }
        
        self.tabsView!.scrollRectToVisible(frame, animated: true)
    }
    
    
    func tabViewAtIndex(index: Int) -> TabView? {
        if (index >= self.tabCount) {
            return nil
        }
        
        if (self.tabs[index] as UIView?) == nil {
            let tabViewContent: UIView = self.dataSource.tabViewForIndex(index: index, pager: self)
            tabViewContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            
            let tabView: TabView = TabView(frame: CGRect(x: 0.0, y: 0.0, width: self.tabWidth, height: self.tabHeight))
            tabView.addSubview(tabViewContent)
            tabView.clipsToBounds = true
            tabViewContent.center = tabView.center
            
            // Replace the null object with tabView
            self.tabs[index] = tabView
        }
        
        return self.tabs[index] as? TabView
    }
    
    
    func setNeedsReloadOptions() {
        // We should update contentSize property of our tabsView, so we should recalculate it with the new values
        var contentSizeWidth: CGFloat = 0.0
        
        // Give the standard offset if fixFormerTabsPositions is provided as YES
        if (self.fixFormerTabsPositions) {
            // And if the centerCurrentTab is provided as YES fine tune the offset according to it
            if (self.centerCurrentTab) {
                contentSizeWidth = (self.tabsView!.frame.width - self.tabWidth) / 2.0
            } else {
                contentSizeWidth = self.tabOffset
            }
        }
        
        // Update every tab's frame
       // for (var i = 0; i < self.tabCount; i++) {
        for i in 0 ..< self.tabCount {
            let tabView = self.tabViewAtIndex(index: i)
            var frame: CGRect = tabView!.frame
            frame.origin.x = contentSizeWidth
            frame.size.width = self.tabWidth
            tabView?.frame = frame
            contentSizeWidth += tabView!.frame.width
        }
        
        // Extend contentSizeWidth if fixLatterTabsPositions is provided YES
        if (self.fixLaterTabsPosition) {
            
            // And if the centerCurrentTab is provided as YES fine tune the content size according to it
            if (self.centerCurrentTab) {
                contentSizeWidth += (self.tabsView!.frame.width - self.tabWidth) / 2.0
            } else {
                contentSizeWidth += self.tabsView!.frame.width - self.tabWidth - self.tabOffset
            }
        }
        // Update tabsView's contentSize with the new width
        self.tabsView!.contentSize = CGSize(width: contentSizeWidth, height: self.tabHeight)
    }
    
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if (index >= self.tabCount || index < 0) {
            return nil
        }
        
        if (self.contents[index] as UIViewController?) == nil {
            var viewController: UIViewController
            
            if (self.dataSource!.responds(to: #selector(PagerDataSource.controllerForTabAtIndex(index:pager:)))) {
                viewController = self.dataSource.controllerForTabAtIndex!(index: index, pager: self)
            } else if (self.dataSource!.responds(to: #selector(PagerDataSource.viewForTabAtIndex(index:pager:)))) {
                
                let view: UIView = self.dataSource.viewForTabAtIndex!(index: index, pager: self)
                
                // Adjust view's bounds to match the pageView's bounds
                let pageView: UIView = self.view.viewWithTag(34)!
                view.frame = pageView.bounds
                
                viewController = UIViewController()
                viewController.view = view
                
            } else {
                viewController = UIViewController()
                viewController.view = UIView()
            }
            self.contents[index] = viewController
            self.addChildViewController(viewController)
        }
        return self.contents[index]
    }
    
    
    //page data source

    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index: Int = self.indexForViewController(viewController: viewController)
        index += 1
        return self.viewControllerAtIndex(index: index)

    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index: Int = self.indexForViewController(viewController: viewController)
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    
    //page delegate
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let viewController: UIViewController = self.pageViewController.viewControllers![0] 
        let index: Int = self.indexForViewController(viewController: viewController)
        self.selectTabAtIndex(index: index, swipe: true)
    }
    
    
    func setActiveContentIndexValue(activeContentIndex: Int) {
        // Get the desired viewController
        var viewController: UIViewController? = self.viewControllerAtIndex(index: activeContentIndex)!
        if (viewController == nil) {
            viewController = UIViewController()
            viewController!.view = UIView()
            viewController!.view.backgroundColor = UIColor.clear
        }
        
        weak var wPageViewController: UIPageViewController? = self.pageViewController
        weak var wSelf: PagerController? = self
        
        if (activeContentIndex == self.activeContentIndex) {
            
            self.pageViewController.setViewControllers([viewController!], direction: .forward, animated: false, completion: {
                (completed: Bool) -> Void in
                wSelf!.animatingToTab = false
            })
            
        } else if (!(activeContentIndex + 1 == self.activeContentIndex || activeContentIndex - 1 == self.activeContentIndex)) {
            
            let direction: UIPageViewControllerNavigationDirection = (activeContentIndex < self.activeContentIndex) ? .reverse : .forward
            
            self.pageViewController.setViewControllers([viewController!], direction: direction, animated: true, completion: {
                (completed: Bool) -> Void in
                
                wSelf?.animatingToTab = false
                
                DispatchQueue.main.async(execute: { 
                    wPageViewController!.setViewControllers([viewController!], direction: direction, animated: false, completion: nil)
                })
            })
            
        } else {
            let direction: UIPageViewControllerNavigationDirection = (activeContentIndex < self.activeContentIndex) ? .reverse : .forward
            
            self.pageViewController.setViewControllers([viewController!], direction: direction, animated: true, completion: {
                (completed: Bool) -> Void in
                wSelf!.animatingToTab = true
            })
        }
        
        // Clean out of sight contents
        var index: Int = self.activeContentIndex - 1
        if (index >= 0 && index != activeContentIndex && index != activeContentIndex - 1) {
            self.contents[index] = nil
        }
        index = self.activeContentIndex
        if (index != activeContentIndex - 1 && index != activeContentIndex && index != activeContentIndex + 1) {
            self.contents[index] = nil
        }
        index = self.activeContentIndex + 1
        if (index < self.contents.count && index != activeContentIndex && index != activeContentIndex + 1) {
            self.contents[index] = nil
        }
        self.activeContentIndex = activeContentIndex
    }
    
    
    //UIScrollViewDelegate, Responding to Scrolling and Dragging
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidScroll(_:)))) {
                self.actualDelegate!.scrollViewDidScroll!(scrollView)
            }
        }
        
        let tabView: UIView = self.tabViewAtIndex(index: self.activeTabIndex)!
        
        if (!self.animatingToTab) {
            
            // Get the related tab view position
            var frame: CGRect = tabView.frame
            let movedRatio: CGFloat = (scrollView.contentOffset.x / scrollView.frame.width) - 1
            frame.origin.x += movedRatio * frame.width
            
            if (self.centerCurrentTab) {
                
                frame.origin.x += (frame.size.width / 2)
                frame.origin.x -= self.tabsView!.frame.width / 2
                frame.size.width = self.tabsView!.frame.width
                
                if (frame.origin.x < 0) {
                    frame.origin.x = 0
                }
                
                if ((frame.origin.x + frame.size.width) > self.tabsView!.contentSize.width) {
                    frame.origin.x = (self.tabsView!.contentSize.width - self.tabsView!.frame.width)
                }
            } else {
                
                frame.origin.x -= self.tabOffset
                frame.size.width = self.tabsView!.frame.width
            }
            
            self.tabsView!.scrollRectToVisible(frame, animated: false)
        }
        
        var rect: CGRect = tabView.frame
        
        let updateIndicator = {
            (newX: CGFloat) -> Void in
            rect.origin.x = newX
            rect.origin.y = self.underlineStroke.frame.origin.y
            rect.size.height = self.underlineStroke.frame.size.height
            self.underlineStroke.frame = rect
        }
        
        var newX: CGFloat
        let width: CGFloat = self.view.frame.width
        let distance: CGFloat = tabView.frame.size.width
        
        if (self.animation == PagerAnimation.During && !self.didTapOnTabView) {
            if (scrollView.panGestureRecognizer.translation(in: scrollView.superview!).x > 0) {
                let mov: CGFloat = width - scrollView.contentOffset.x
                newX = rect.origin.x - ((distance * mov) / width)
            } else {
                let mov: CGFloat = scrollView.contentOffset.x - width
                newX = rect.origin.x + ((distance * mov) / width)
            }
            updateIndicator(newX)
        } else if (self.animation == PagerAnimation.None) {
            newX = tabView.frame.origin.x
            updateIndicator(newX)
        } else if (self.animation == PagerAnimation.End || self.didTapOnTabView) {
            newX = tabView.frame.origin.x
            UIView.animate(withDuration: 0.35, animations: {
                () -> Void in
                updateIndicator(newX)
            })
        }
    }
    
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewWillBeginDragging(_:)))) {
                self.actualDelegate!.scrollViewWillBeginDragging!(scrollView)
            }
        }
    }
    
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)))) {
                self.actualDelegate!.scrollViewWillEndDragging!(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
            }
        }
    }
    
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:)))) {
                self.actualDelegate!.scrollViewDidEndDragging!(scrollView, willDecelerate: decelerate)
            }
        }
        self.didTapOnTabView = false
    }
    
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewShouldScrollToTop(_:)))) {
                return self.actualDelegate!.scrollViewShouldScrollToTop!(scrollView)
            }
        }
        return false
    }
    
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidScrollToTop(_:)))) {
                self.actualDelegate!.scrollViewDidScrollToTop!(scrollView)
            }
        }
    }
    
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewWillBeginDecelerating(_:)))) {
                self.actualDelegate!.scrollViewWillBeginDecelerating!(scrollView)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:)))) {
                self.actualDelegate!.scrollViewDidEndDecelerating!(scrollView)
            }
        }
        self.didTapOnTabView = false
    }
    
    
    //UIScrollViewDelegate, Managing Zooming
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.viewForZooming))) {
                return self.actualDelegate!.viewForZooming!(in: scrollView)
            }
        }
        return nil
    }
    
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewWillBeginZooming))) {
                self.actualDelegate?.scrollViewWillBeginZooming!(scrollView, with: view)
            }
        }
    }
    
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndZooming))) {
                self.actualDelegate?.scrollViewDidEndZooming!(scrollView, with: view, atScale: scale)
            }
        }
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidZoom(_:)))) {
                self.actualDelegate!.scrollViewDidZoom!(scrollView)
            }
        }
    }
    
    
    //UIScrollViewDelegate, Responding to Scrolling Animations
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndScrollingAnimation(_:)))) {
                self.actualDelegate!.scrollViewDidEndScrollingAnimation!(scrollView)
            }
        }
        self.didTapOnTabView = false
    }
    
    public func disableSwippe(){
        self.pageViewController.dataSource = nil
    }
}


class TabView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
}


extension Array {
    func find(includedElement: (Element) -> Bool) -> Int? {
        for (idx, element) in self.enumerated() {
            if includedElement(element) {
                return idx
            }
        }
        return 0
    }
}
