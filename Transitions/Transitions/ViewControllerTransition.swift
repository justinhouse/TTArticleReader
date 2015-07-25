//
//  ViewControllerTransition.swift
//  Transitions
//
//  Created by Justin Hammenga on 04/06/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit

class ViewControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var presenting: Bool = false
    var context: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        if self.presenting {
            return 0.5
        } else {
            return 0.5
        }
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var endFrame =  UIScreen.mainScreen().bounds
        var fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        toController!.view.frame = endFrame
        toController!.view.alpha = 0
        
        if(presenting){
            fromController!.view.userInteractionEnabled = false
            
            transitionContext.containerView().addSubview(fromController!.view)
            transitionContext.containerView().addSubview(toController!.view)
            
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.71, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { _ in
                    toController!.view.alpha = 1
                }, completion: { _ in
                    transitionContext.completeTransition(true)
                })
            
        } else {
            toController!.view.userInteractionEnabled = true
            fromController!.view.userInteractionEnabled = false
            
            transitionContext.containerView().addSubview(toController!.view)
            transitionContext.containerView().addSubview(fromController!.view)
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, options: .CurveEaseIn, animations: { _ in
                    fromController!.view.alpha = 0
                }, completion: { _ in
                    transitionContext.completeTransition(true)
                    if let window = UIApplication.sharedApplication().keyWindow {
                        if let viewController = window.rootViewController {
                            window.addSubview(viewController.view)
                        }
                    }
                })
        }
    }
}