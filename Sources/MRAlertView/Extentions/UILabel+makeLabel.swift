//
//  UILabel+makeLabel.swift
//  
//
//  Created by MohammadReza Khatibi on 4/29/20.
//

import UIKit

extension UILabel {
    
    public class func make(_ text: String?, font: UIFont?,align: NSTextAlignment, color: UIColor) -> UILabel {
        let label = UILabel()
        
        label.text = text
        label.textColor = color
        label.font = font
        label.textAlignment = align
        label.numberOfLines = 0
        
        return label
    }
    
}
