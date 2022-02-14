//
//  CircleView.swift
//  HW12
//
//  Created by Artem Mazurkevich on 07.02.2022.
//

import UIKit

class CircleView: UIView {

    var position: Position = .topLeft
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width / 2
        layer.masksToBounds = true
        clipsToBounds = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
