//
//  ViewControllerCircleTransition.swift
//  Transitions
//
//  Created by Justin Hammenga on 04/06/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit

class ViewControllerCircleTransition: ViewControllerTransition {

    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        context = transitionContext
        var endFrame =  UIScreen.mainScreen().bounds
        var fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        toController!.view.frame = endFrame
        
        if(presenting){
            fromController!.view.userInteractionEnabled = false
            
            transitionContext.containerView().addSubview(fromController!.view)
            transitionContext.containerView().addSubview(toController!.view)
            
            let bounds = toController!.view.bounds
            let event = ViewControllerTransitionEvent()
            event.handler = { _ in
                self.context?.completeTransition(true)
            }
            animate(smallPath(bounds), toPath: largePath(bounds), targetView: toController!.view, event: event)
            
        } else {
            toController!.view.userInteractionEnabled = true
            fromController!.view.userInteractionEnabled = false
            
            transitionContext.containerView().addSubview(toController!.view)
            transitionContext.containerView().addSubview(fromController!.view)
            
            let bounds = toController!.view.bounds
            let event = ViewControllerTransitionEvent()
            event.handler = { _ in
                self.context?.completeTransition(true)
                if let window = UIApplication.sharedApplication().keyWindow {
                    if let viewController = window.rootViewController {
                        window.addSubview(viewController.view)
                    }
                }
            }
            animate(largePath(bounds), toPath: smallPath(bounds), targetView: fromController!.view, event: event)
         }
    }
    
    func animate(fromPath: CGPath, toPath: CGPath, targetView: UIView, event: ViewControllerTransitionEvent ) {
        
        let mask = CAShapeLayer()
        mask.path = fromPath
        targetView.layer.mask = mask
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.toValue = toPath
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.fillMode = kCAFillModeBoth
        animation.removedOnCompletion = false
        animation.setValue(event, forKey: "event")
        mask.addAnimation(animation, forKey: animation.keyPath)
    }
    
    func originForSize(size: CGFloat, bounds:CGRect) -> CGPoint {
        return CGPointMake(bounds.size.width / 2 - size / 2, bounds.size.height / 2 - size / 2)
    }
    
    func smallPath(bounds: CGRect) -> CGPath {
        let size: CGFloat = 4
        let pathBounds = CGRectMake(
            originForSize(size, bounds: bounds).x,
            originForSize(size, bounds: bounds).y,
            size,
            size)
        
        let path = UIBezierPath(roundedRect: pathBounds, cornerRadius: size / 2)
        return path.CGPath
    }
    
    func largePath(bounds: CGRect) -> CGPath {
        let size: CGFloat = (bounds.size.height > bounds.size.width) ? bounds.size.height * 1.5 : bounds.size.width * 1.5
        let pathBounds = CGRectMake(
            originForSize(size, bounds: bounds).x,
            originForSize(size, bounds: bounds).y,
            size,
            size)
        
        let path = UIBezierPath(roundedRect: pathBounds, cornerRadius: size / 2)
        return path.CGPath
    }
    
    override func animationDidStop(animation: CAAnimation!, finished flag: Bool) {
        if let event = animation.valueForKey("event") as? ViewControllerTransitionEvent {
            if let completionHandler = event.handler {
                completionHandler()
            }
        }
    }
}
