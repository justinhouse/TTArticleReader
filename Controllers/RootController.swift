//
//  RootController.swift
//  Transitions
//
//  Created by Justin Hammenga on 02/07/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit

class RootController: UIViewController, UITableViewDelegate, UITableViewDataSource, SharedElementsViewController {
    let tableView: UITableView = UITableView(frame: CGRectZero, style: .Plain)
    var models: [String] = ["Beach", "Vulcano", "Sunset"]
    var images: [UIImage] = [UIImage]()
    var sharedElementsTransitionCoordinator: SharedElementsTransitionCoordinator?
    var currentPhotoView: UIImageView?
    
    func sharedElements(receivedSharedElements: [SharedElementsTransitionItem]?, forTransition transition: SharedElementsTransition) {
        if let sharedElements = receivedSharedElements {
            UIView.animateWithDuration(transition.transitionDuration,
                delay: 0,
                options: transition.transitionAnimationCurve,
                animations: { _ in
                    for var i = 0 ; i < sharedElements.count ; i++ {
                        var sharedView = sharedElements[i].sharedView
                        sharedView.frame = sharedElements[i].translatedFrame
                    }
                },
                completion: { _ in
                    for var i = 0 ; i < sharedElements.count ; i++ {
                        var sharedElement = sharedElements[i]
                        var sharedView = sharedElement.sharedView
                        sharedView.frame = sharedElement.initialFrame
                        sharedElement.initialParent.insertSubview(sharedElement.sharedView, atIndex: sharedElement.initialIndex)
                        self.navigationController?.setNavigationBarHidden(true, animated: true)
                    }
            })
        }
    }
    
    //MARK: - UITableViewDataSource & Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count * 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ListCell
        cell.photoView.image = images[indexPath.row % models.count]
        cell.textLabel?.text = models[indexPath.row % models.count]
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: ListCell = tableView.cellForRowAtIndexPath(indexPath) as! ListCell
        self.navigationController?.pushViewController(DetailController(), sharedViews: [cell.photoView], animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "Nieuws"
        
        images.append(UIImage(named: "beach")!)
        images.append(UIImage(named: "vulcano")!)
        images.append(UIImage(named: "sunset")!)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.registerClass(ListCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0))        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("Root will appear")
        
        println("Coordinator \(self.sharedElementsTransitionCoordinator)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("Root did appear")
        println("Coordinator \(self.sharedElementsTransitionCoordinator)")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("Root will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("Root did disappear")
    }
}
