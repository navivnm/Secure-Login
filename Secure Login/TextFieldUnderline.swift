//
//  TextFieldUnderline.swift
//  Secure Login
//
//  Created by Naveen Vijay on 2019-06-19.
//  Copyright © 2019 Naveen Vijay. All rights reserved.
//
import UIKit

extension UITextField
{
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.cyan.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

