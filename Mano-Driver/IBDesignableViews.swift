//
//  IBDesignableViews.swift
//  Mano
//
//  Created by Leandro Wauters on 9/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.contentMode = .scaleAspectFill
        layer.cornerRadius = bounds.height / 2.0
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        clipsToBounds = true
        
    }
}

@IBDesignable
class ManoLogoLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        font = UIFont(name: "ArialRoundedMTBold", size: 50)
        
    }
}
@IBDesignable
class AlertView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.3019607843, blue: 0.4431372549, alpha: 1)
        layer.cornerRadius = 30
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        clipsToBounds = true
        
    }
}

@IBDesignable
class BorderView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
}

@IBDesignable
class BorderButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
    }
}
@IBDesignable
class Rounder10Button: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        clipsToBounds = true
        
    }
}
