//
//  ListCell\.swift
//  Transitions
//
//  Created by Justin Hammenga on 02/07/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    let photoView: UIImageView = UIImageView(frame: CGRectZero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        photoView.backgroundColor = UIColor.blueColor()
        contentView.addSubview(photoView)
    }
  
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height)
    }
}
