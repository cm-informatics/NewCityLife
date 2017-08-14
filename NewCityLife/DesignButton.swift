//
//  DesignButton.swift
//  NewCityLife
//
//  Created by Christian Mansch on 17.07.17.
//  Copyright © 2017 Christian Mansch. All rights reserved.
//

import UIKit


@IBDesignable class DesignButton: UIButton {
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}
