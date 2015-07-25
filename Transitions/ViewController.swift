//
//  ViewController.swift
//  Transitions
//
//  Created by Justin Hammenga on 04/06/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var colors = [UIColor]()
    var controllerType: Int = 0
    var targetColor: UIColor = UIColor.whiteColor()
    
    init(type: Int) {
        super.init(nibName: nil, bundle: nil)
        colors.append(UIColor.whiteColor())
        colors.append(UIColor.redColor())
        colors.append(UIColor.whiteColor())
        colors.append(UIColor.orangeColor())
        colors.append(UIColor.whiteColor())
        colors.append(UIColor.yellowColor())
        colors.append(UIColor.whiteColor())
        colors.append(UIColor.greenColor())
        colors.append(UIColor.whiteColor())
        colors.append(UIColor.purpleColor())
        colors.append(UIColor.whiteColor())
        colors.append(UIColor.blueColor())
        controllerType = type
        targetColor = colors[type]
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func dismissController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func presentController() {
        var nextType = (controllerType + 1 == colors.count) ? 0 : controllerType + 1
        var controller = ViewController(type: nextType)
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
        
        self.presentViewController(controller, animated: true, completion: { _ in
            println("shown")
        })
    }
    
    func didTapScreen(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.locationInView(view)
        if location.y < view.center.y {
            dismissController()
        } else {
            presentController()
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = ViewControllerCircleTransition()
        transition.presenting = true
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ViewControllerCircleTransition()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = targetColor
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "didTapScreen:")
        view.addGestureRecognizer(tapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

