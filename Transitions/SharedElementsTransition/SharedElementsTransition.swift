//
//  SharedElementsTransition.swift
//  Transitions
//
//  Created by Justin Hammenga on 02/07/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit

class SharedElementsTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var presenting: Bool = false
    var sharedElements: [SharedElementsTransitionItem]?
    var transitionContext: UIViewControllerContextTransitioning?
    
    var transitionDuration: NSTimeInterval {
        return transitionDuration(transitionContext!)
    }
    
    var transitionAnimationCurve: UIViewAnimationOptions {
        return (self.presenting) ? .CurveEaseOut : .CurveEaseIn
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        if self.presenting {
            return 0.3
        } else {
            return 0.3
        }
    }
    
    func animateTransition(context: UIViewControllerContextTransitioning) {
        
        transitionContext = context
        
        var fromViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        var toViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey)!

        if(presenting){
            presentNewViewController(context.containerView(), duration: transitionDuration(context), fromViewController: fromViewController, toViewController: toViewController)
        } else {
            returnToViewController(context.containerView(), duration: transitionDuration(context), fromViewController: fromViewController, toViewController: toViewController)
        }
    }
    
    func presentNewViewController(containerView: UIView, duration: NSTimeInterval, fromViewController: UIViewController, toViewController: UIViewController) {
        // Set frames of ViewControllers to same size.
        // Disable interaction on sending ViewController
        // Store original backgroundColor of receiving ViewController
        // Set backgroundColor of receiving ViewController to transparent
        toViewController.view.frame = fromViewController.view.frame
        fromViewController.view.userInteractionEnabled = false
        let originalColor = toViewController.view.backgroundColor
        toViewController.view.backgroundColor = UIColor.clearColor()

        // Add both ViewController to the transitionView
        containerView.addSubview(fromViewController.view)
        containerView.addSubview(toViewController.view)
        
        // Add all sharedElements to the receiving ViewController View (with translated positionsm, relative to the root)
        if sharedElements != nil {
            for var i = 0 ; i < sharedElements!.count ; i++ {
                var element = sharedElements![i]
                element.sharedView.frame = element.translatedFrame
                toViewController.view.addSubview(element.sharedView)
            }
        }
        
        // Start the actual animated transition
        // Based on transitionStyle this transition automatically fades the receiving ViewController to an opacity of 0%
        // The receiving ViewController is assumed to implement the SharedElementsViewController protocol to receive shared elements
        // It is the receiving ViewController's responsibility to position the shared elements as they wish
        // When the transition completes fade the receiving ViewController background to it's original color and opacity
        
        let receivingViewController = toViewController as! SharedElementsViewController
        receivingViewController.sharedElements?(sharedElements, forTransition: self)
        
        UIView.animateWithDuration(duration,
            delay: 0,
            options: self.transitionAnimationCurve,
            animations: { _ in
                fromViewController.view.alpha = 0
                toViewController.view.backgroundColor = UIColor.whiteColor()
                
            },
            completion: { _ in
                self.showBackgroundColor(toViewController, color: originalColor!)
                self.completeTransition();
            })
    }
    
    func returnToViewController(containerView: UIView, duration: NSTimeInterval, fromViewController: UIViewController, toViewController: UIViewController) {
        // Set frames of ViewControllers to same size.
        // Disable interaction on sending ViewController (send from current to previous)
        // Re-enable interaction on receiving ViewController (receive from current)
        toViewController.view.userInteractionEnabled = true
        fromViewController.view.userInteractionEnabled = false
        
        // Add both ViewController to the transitionView
        containerView.addSubview(toViewController.view)
        containerView.addSubview(fromViewController.view)
        
        // Add all sharedElements to the receiving ViewController View (with translated positions, relative to the root)
        if sharedElements != nil {
            for var i = 0 ; i < sharedElements!.count ; i++ {
                var element = sharedElements![i]
                element.sharedView.frame = containerView.convertRect(element.sharedView.frame, toView: containerView)
                containerView.addSubview(element.sharedView)
            }
        }
        
        // Start the actual animated transition
        // This transition fades the receiving ViewController to an opacity of 100%
        // The receiving ViewController is assumed to implement the SharedElementsViewController protocol to receive shared elements
        // It is the receiving ViewController's responsibility to position the shared elements as they wish
        // When the transition completes fade the receiving ViewController background to it's original color and opacity

        let receivingViewController = toViewController as! SharedElementsViewController
        receivingViewController.sharedElements?(sharedElements, forTransition: self)

        
        UIView.animateWithDuration(self.transitionDuration(transitionContext!),
            delay: 0,
            options: self.transitionAnimationCurve,
            animations: { _ in
                fromViewController.view.alpha = 0
                toViewController.view.alpha = 1
                if self.sharedElements != nil {
                    for var i = 0 ; i < self.sharedElements!.count ; i++ {
                        var element = self.sharedElements![i]
                        element.sharedView.frame = element.translatedFrame
                    }
                }
            },
            completion: { _ in
                self.completeTransition()
            })
    }
    
    func showBackgroundColor(viewController: UIViewController, color: UIColor) {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.fromValue = viewController.view.backgroundColor!.CGColor
        animation.toValue = color.CGColor
        viewController.view.layer.addAnimation(animation, forKey: "backgroundColor")
    }
    
    func completeTransition() {
        if let context = self.transitionContext {
            var receivingViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey) as! SharedElementsViewController
            context.completeTransition(true)
            receivingViewController.sharedElementsTransitionCoordinator = nil
            if !self.presenting {
                if let window = UIApplication.sharedApplication().keyWindow {
                    if let viewController = window.rootViewController {
                        window.addSubview(viewController.view)
                    }
                }
            }
        }
    }
}

class SharedElementsTransitionItem {
    let sharedView: UIView
    let initialParent: UIView
    let initialFrame: CGRect
    let initialIndex: Int
    let translatedFrame: CGRect
    
    init(sharedView aSharedView: UIView, fromViewController viewController: UIViewController) {
        sharedView = aSharedView
        initialParent = sharedView.superview!
        initialFrame = sharedView.frame
        initialIndex = (initialParent.subviews as NSArray).indexOfObject(sharedView)
        translatedFrame  = viewController.view.convertRect(initialFrame, fromView: initialParent)
    }
}
