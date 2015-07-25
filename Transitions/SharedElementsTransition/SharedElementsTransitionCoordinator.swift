//
//  SharedElementsTransitionCoordinator.swift
//  Transitions
//
//  Created by Justin Hammenga on 02/07/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit

@objc protocol SharedElementsViewController {
    var sharedElementsTransitionCoordinator: SharedElementsTransitionCoordinator? {get set }
    optional func sharedElements(receivedSharedElements: [SharedElementsTransitionItem]?, forTransition: SharedElementsTransition)
}

class SharedElementsTransitionCoordinator: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    var controllerTransitionSharedElements: [SharedElementsTransitionItem]?
    var fromViewController: UIViewController?
    var toViewController: UIViewController?
    var sharedViews: [UIView]?
    var sharedElements: [SharedElementsTransitionItem]?    
    
    init (fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, sharedViews views: [UIView]) {
        super.init()
        fromViewController = fromVC
        toViewController = toVC
        sharedViews = views
        sharedElements = createSharedElements(sharedViews, fromViewController: fromVC)
    }
    
    func createSharedElements(sharedViews: [UIView]?, fromViewController fromVC: UIViewController) -> [SharedElementsTransitionItem]? {
        if(sharedViews != nil) {
            var items = [SharedElementsTransitionItem]()
            for var i = 0 ; i < sharedViews!.count ; i++ {
                let item = SharedElementsTransitionItem(sharedView: sharedViews![i], fromViewController: fromViewController!)
                items.append(item)
            }
            return items
        }
        
        return nil
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = SharedElementsTransition()
        transition.sharedElements = sharedElements
        transition.presenting = true
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SharedElementsTransition()
    }
    
    // MARK: - UINavigationController Delegate
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = SharedElementsTransition()
        transition.sharedElements = sharedElements
        transition.presenting = (operation == .Push)
        return transition
    }
}

// MARK: -
extension UINavigationController {
    func pushViewController(viewController: UIViewController, sharedViews: [UIView], animated: Bool) -> SharedElementsTransitionCoordinator {
        let transitionCoordinator = SharedElementsTransitionCoordinator(
            fromViewController: self.topViewController,
            toViewController: viewController,
            sharedViews: sharedViews)
        
        var fromViewController: SharedElementsViewController = self.topViewController as! SharedElementsViewController
        fromViewController.sharedElementsTransitionCoordinator = transitionCoordinator
        
        self.delegate = transitionCoordinator
        self.pushViewController(viewController, animated: animated)
        
        return transitionCoordinator
    }
}
