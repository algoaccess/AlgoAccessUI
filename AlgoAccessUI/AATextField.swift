//
//  AATextField.swift
//  AlgoAccessUI
//
//  Created by perwyl on 23/9/15.
//  Copyright (c) 2015 algoaccess. All rights reserved.
//

import Foundation
import UIKit

enum UNIT_TYPE: String {
    case TYPE_EMPTY = " "
    case TYPE_MM = "MM"
    case TYPE_CM = "CM"
    case TYPE_DEG = "˚C"
    
    init(){
        self = TYPE_EMPTY
    }
}

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
    
    var isRequired = false
    
    var rightViewLabel: UILabel!
    var isRequiredLabel: UILabel!
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.grayColor().CGColor

        
        colorSchemeSetup()
        
        commitInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.grayColor().CGColor
        
        colorSchemeSetup()
        
        commitInit()
        
    }
    
    func commitInit(){
        floatingLabel = UILabel()
        floatingLabel.alpha = 0.0
        
        isRequiredLabel = UILabel()
        isRequiredLabel.alpha = 1
        
        rightViewLabel = UILabel()
        rightViewLabel.alpha = 0.0
        
        
        addSubview(floatingLabel)
        addSubview(isRequiredLabel)
        addSubview(rightViewLabel)
        
        isRequiredLabel.font = defaultFloatingLabelFont()
        isRequiredLabel.textColor = UIColor.greenColor()
        
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
    
    func setupTextField(isRequired: Bool, rightView: UNIT_TYPE){
        
        if isRequired {
            isRequiredLabel.text = "Required"
        }else{
            isRequiredLabel.text = ""
        }
        
        self.setNeedsLayout()
        
        if rightView != UNIT_TYPE.TYPE_EMPTY {
            rightViewLabel.alpha = 1
            rightViewLabel.text = rightView.rawValue
            
           
        }
        
        setNeedsLayout()

    }
    
    
    
    override func layoutSubviews() {
    
        super.layoutSubviews()
        
        updateOriginForTextAlignment()
        
        let floatingLabelSize = floatingLabel.sizeThatFits(floatingLabel.superview!.bounds.size)
        
        floatingLabel.frame = CGRectMake(floatingLabel.frame.origin.x, floatingLabel.frame.origin.y, floatingLabelSize.width, floatingLabelSize.height)
        
        let isRequiredLabelSize = isRequiredLabel.sizeThatFits(isRequiredLabel.superview!.bounds.size)
        
        print("isRequiredLabelSIze \(isRequiredLabelSize)", terminator: "")
        
        isRequiredLabel.frame = CGRectMake(isRequiredLabel.frame.origin.x ,  isRequiredLabel.frame.origin.y, isRequiredLabelSize.width, isRequiredLabelSize.height)
        
        isRequiredLabel.textAlignment = NSTextAlignment.Right
        isRequiredLabel.textColor = UIColor.grayColor()
        
        print("isRequiredLabel \(isRequiredLabel.text)")
        
        let firstResponder = self.isFirstResponder()
        
        if firstResponder && self.text?.characters.count > 0 {
            floatingLabel.textColor = floatingLabelTextColor
        }else {
            floatingLabel.textColor = UIColor.grayColor()
        }
        
     
        if (self.text?.characters.count == 0 ) {
            
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
            textFieldFont = self.attributedPlaceholder!.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as? UIFont
        }
        
        if self.attributedText != nil && self.attributedText?.length > 0 {
            textFieldFont = self.attributedText?.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as? UIFont
        }
        
        return UIFont(name: textFieldFont!.fontName, size: textFieldFont!.pointSize * 0.7)!
    }

    
    func updateOriginForTextAlignment(){
        
        let textRect = self.textRectForBounds(self.bounds)
        
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
        
        isRequiredLabel.frame = CGRectMake(orginX + self.frame.width - 60, textRect.origin.y , floatingLabel.frame.size.width, floatingLabel.frame.size.height)
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
            
            UIView.animateWithDuration(floatingLabelShowAnimationDuration, delay: 0.0, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
                
                self.floatingLabel.alpha = 1.0
                self.floatingLabel.frame = CGRectMake(self.floatingLabel.frame.origin.x, self.placeholderYPadding, self.floatingLabel.frame.size.width, self.floatingLabel.frame.size.height)
                
                
                }, completion: nil )
            
        }else {
            floatingLabel.alpha = 1.0
            floatingLabel.frame = CGRectMake(floatingLabel.frame.origin.x, placeholderYPadding, floatingLabel.frame.size.width, floatingLabel.frame.size.height)
        }
    }

    
}