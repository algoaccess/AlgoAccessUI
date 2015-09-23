//
//  AATextField.swift
//  AlgoAccessUI
//
//  Created by perwyl on 23/9/15.
//  Copyright (c) 2015 algoaccess. All rights reserved.
//

import Foundation
import UIKit

class AATextField: UITextField {
    
    var floatingLabel: UILabel!

    var floatingLabelTextFont: UIFont!
    var floatingLabelTextColor: UIColor!
    var floatingLabelActiveTextColor: UIColor!
    var floatingLabelYPadding: CGFloat!
    var floatingLabelXPadding: CGFloat!
    
    var isFloatingFontDefault = true
    
    var animateEvenIfNotFirstResponder: Bool!
    var floatingLabelShowAnimationDuration: NSTimeInterval!
    var floatingLabelHideAnimationDuration: NSTimeInterval!
    
    var adjustClearButtonRect: Bool!
    var keepBaseline: Bool!
    
    var placeholderYPadding: CGFloat!
    var placeholderXPadding: CGFloat!
    
    var highBorder = false 
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.grayColor().CGColor

        
        colorSchemeSetup()
        
        commitInit()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.grayColor().CGColor
        
        colorSchemeSetup()
        
        commitInit()
        
    }
    
    func commitInit(){
        floatingLabel = UILabel()
        floatingLabel.alpha = 0.0
        
        self.addSubview(floatingLabel)
        
        floatingLabelTextFont = defaultFloatingLabelFont()
        
        floatingLabel.font = floatingLabelTextFont
        floatingLabel.textColor = floatingLabelTextColor
        
        animateEvenIfNotFirstResponder = false
        floatingLabelShowAnimationDuration = 0.3
        floatingLabelHideAnimationDuration = 0.3
        
        updateFloatingLabelText(self.placeholder!)
        
        adjustClearButtonRect = true
        isFloatingFontDefault = true
        
        floatingLabelXPadding = 1
        floatingLabelYPadding = 1
        
        placeholderYPadding = 1
        placeholderXPadding = 1
    }
    
    
    override func layoutSubviews() {
    
        super.layoutSubviews()
        
        updateOriginForTextAlignment()
        
        var floatingLabelSize = floatingLabel.sizeThatFits(floatingLabel.superview!.bounds.size)
        
        floatingLabel.frame = CGRectMake(floatingLabel.frame.origin.x, floatingLabel.frame.origin.y, floatingLabelSize.width, floatingLabelSize.height)
        
        var firstResponder = self.isFirstResponder()
        
        if firstResponder && count(self.text) > 0 {
            floatingLabel.textColor = floatingLabelTextColor
        }else {
            floatingLabel.textColor = UIColor.grayColor()
        }
        
     
        if (count(self.text) == 0 ) {
            
            hideFloatingLabel(firstResponder)
        }else {
            showFloatingLabel(firstResponder)
            
        }
    }
    
    
    func colorSchemeSetup(){
        
        updateFloatingLabelTextColor(UIColor.blueColor())
    }
    
    func updateFloatingLabelTextColor(color: UIColor){
        
        floatingLabelTextColor = color
    }
    
    func updateFloatingLabelText(text: String){
        floatingLabel.text = text
        
        self.setNeedsLayout()
    }
    
    func defaultFloatingLabelFont() -> UIFont {
        
        var textFieldFont = self.font
        
        if self.attributedPlaceholder != nil && self.attributedPlaceholder?.length > 0 {
            textFieldFont = self.attributedPlaceholder!.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as! UIFont
        }
        
        if self.attributedText != nil && self.attributedText?.length > 0 {
            textFieldFont = self.attributedText?.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as! UIFont
        }
        
        return UIFont(name: textFieldFont.fontName, size: textFieldFont.pointSize * 0.7)!
    }

    
    func updateOriginForTextAlignment(){
        
        var textRect = self.textRectForBounds(self.bounds)
        
        var orginX = textRect.origin.x
        
        switch self.textAlignment {
            
        case .Center:
            orginX = textRect.origin.x + (textRect.size.width/2) - floatingLabel.frame.size.width/2
        case .Right:
            orginX = textRect.origin.x + textRect.size.width - floatingLabel.frame.size.width
        default:
            break
        }
        
        floatingLabel.frame = CGRectMake(orginX + floatingLabelXPadding, floatingLabel.frame.origin.y, floatingLabel.frame.size.width, floatingLabel.frame.size.height)
    }
    
    func hideFloatingLabel(animated: Bool){
        
        if animated || animateEvenIfNotFirstResponder == true {
            
            UIView.animateWithDuration(floatingLabelHideAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                
                self.floatingLabel.alpha = 0.0
                self.floatingLabel.frame = CGRectMake(self.floatingLabel.frame.origin.x, self.floatingLabel.font.lineHeight + self.placeholderYPadding, self.floatingLabel.frame.size.width, self.floatingLabel.frame.size.height)
            
                
            }, completion: nil )
            
        }else {
            floatingLabel.alpha = 0.0
            floatingLabel.frame = CGRectMake(floatingLabel.frame.origin.x, floatingLabel.font.lineHeight + placeholderYPadding, floatingLabel.frame.size.width, floatingLabel.frame.size.height)
        }
        
    }
    
    func showFloatingLabel(animated: Bool){
        
        if animated || animateEvenIfNotFirstResponder == true {
            
            UIView.animateWithDuration(floatingLabelShowAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState | UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                self.floatingLabel.alpha = 1.0
                self.floatingLabel.frame = CGRectMake(self.floatingLabel.frame.origin.x, self.placeholderYPadding, self.floatingLabel.frame.size.width, self.floatingLabel.frame.size.height)
                
                
                }, completion: nil )
            
        }else {
            floatingLabel.alpha = 1.0
            floatingLabel.frame = CGRectMake(floatingLabel.frame.origin.x, placeholderYPadding, floatingLabel.frame.size.width, floatingLabel.frame.size.height)
        }
    }

    
}