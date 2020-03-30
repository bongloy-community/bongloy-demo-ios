//
//  TextField.swift
//  bongloy-demo-ios
//
//  Created by khomsovon on 9/3/18.
//

import UIKit

@IBDesignable
class TextField: UITextField {
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            self.textColor = color
        }
    }
    
    func updateView(){
        if let image = leftImage {
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 20, height: 20))
            imageView.image = image
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 20))
            view.addSubview(imageView)
            leftView = view
        }else{
            leftViewMode = .never
        }
    }
}
