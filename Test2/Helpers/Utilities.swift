//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField, colorName: String) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor(named: colorName)?.cgColor
        
        textfield.borderStyle = .none
        
        textfield.backgroundColor = .none
        
        textfield.layer.cornerRadius = 5.0
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleImageView(_ imageView:UIImageView, colorName: String) {
        
        
        imageView.layer.borderWidth = 3
        
        imageView.layer.borderColor = UIColor(named: colorName)?.cgColor
        
        imageView.layer.cornerRadius = 5.0
        
        
    }
    
    static func styleLabel(_ label: UILabel,colorName: String) {
        label.textColor=UIColor(named: colorName)
    }
    
    static func styleButton(_ button:UIButton,colorName: String) {
        
        button.backgroundColor = UIColor(named: colorName)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor(named: "fonts")
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
