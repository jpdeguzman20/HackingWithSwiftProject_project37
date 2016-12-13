//
//  GradientVIew.swift
//  Project37
//
//  Created by Jonathan Deguzman on 12/13/16.
//  Copyright © 2016 Jonathan Deguzman. All rights reserved.
//

import UIKit

@IBDesignable class GradientVIew: UIView {

    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black
    
    // We'll be using a CAGradientLayer for drawing the gradient.
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    // When the view lays out the subviews, it should apply the colors of the gradient.
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}
