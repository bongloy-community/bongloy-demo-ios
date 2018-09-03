//
//  Button.swift
//  bongloy-demo-ios
//
//  Created by khomsovon on 9/3/18.
//  Copyright © 2018 bongloy. All rights reserved.
//

import UIKit

@IBDesignable
class HighlightingButton: UIButton {
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.updateView()
    }
    
    override func awakeFromNib() {
        self.updateView()
    }
    
    func updateView(){
        self.layer.borderColor = #colorLiteral(red: 0.5215686275, green: 0.7411764706, blue: 0.3176470588, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0.5215686275, green: 0.7411764706, blue: 0.3176470588, alpha: 1), for: UIControlState())
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
    }
}
