//
//  DetailController.swift
//  Transitions
//
//  Created by Justin Hammenga on 02/07/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit

class DetailController: UIViewController, SharedElementsViewController {
    var sharedElementsTransitionCoordinator: SharedElementsTransitionCoordinator?
    var photoView: UIImageView?
    func sharedElements(receivedSharedElements: [SharedElementsTransitionItem]?, forTransition transition: SharedElementsTransition) {
        if let sharedElements = receivedSharedElements {
            UIView.animateWithDuration(transition.transitionDuration,
                delay: 0,
                options: transition.transitionAnimationCurve,
                animations: { _ in
                    for var i = 0 ; i < sharedElements.count ; i++ {
                        var sharedView = sharedElements[i].sharedView
                        sharedView.frame = CGRectMake(0, 64, sharedView.bounds.size.width, sharedView.bounds.size.height)
                        self.photoView = sharedView as? UIImageView
                    }
                },
                completion: { _ in
                    self.showContent()
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                })
        }
    }
    
    func showContent() {
        
        let label = UILabel(frame: CGRectMake(0, CGRectGetMaxY(photoView!.frame), view.bounds.size.width, 0))
        label.text = self.title
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.orangeColor()
        view.addSubview(label)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        UIView.animateWithDuration(0.3,
            delay: 0,
            options: .CurveEaseIn,
            animations: { _ in
                label.frame = CGRectMake(0, CGRectGetMaxY(self.photoView!.frame), self.view.bounds.size.width, 48)
            },
            completion: { _ in

            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "Detail"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("Detail will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("Detail did appear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("Detail will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("Detail did disappear")
    }
}
