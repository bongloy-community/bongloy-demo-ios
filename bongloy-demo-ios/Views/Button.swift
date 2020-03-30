//
//  Button.swift
//  bongloy-demo-ios
//
//  Created by khomsovon on 9/3/18.
//

import UIKit

@IBDesignable
class HighlightingButton: UIButton {
    var highlightColor = UIColor(white: 0, alpha: 0.05)
    var disabledColor = UIColor.lightGray
    var enabledColor = #colorLiteral(red: 0.5215686275, green: 0.7411764706, blue: 0.3176470588, alpha: 1)
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.updateView()
    }
    
    override func awakeFromNib() {
        self.updateView()
    }
    
    override var isEnabled: Bool {
        didSet {
            let color = isEnabled ? enabledColor : disabledColor
            self.setTitleColor(color, for: UIControlState())
            self.layer.borderColor = color.cgColor
            self.highlightColor = color.withAlphaComponent(0.5)
        }
    }
    
    func updateView(){
        self.layer.borderColor = highlightColor.cgColor
        self.setTitleColor(highlightColor, for: UIControlState())
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        
    }
}
