//
//  AATextView.swift
//  AlgoAccessUI
//
//  Created by perwyl on 23/9/15.
//  Copyright (c) 2015 algoaccess. All rights reserved.
//

import Foundation
import UIKit

class AATextView: UITextView {
    
    var floatingLabel: UILabel!
    
    var floatingLabelTextFont: UIFont!
    var floatingLabelTextColor: UIColor!
    var floatingLabelActiveTextColor: UIColor!
    var floatingLabelYPadding: CGFloat!
    var floatingLabelXPadding: CGFloat!
    
    var isFloatingFontDefault = true
    var floatingLabelShouldLockToTop = true
    
    var startingTextContainerInsetTop: CGFloat!
    
    var animateEvenIfNotFirstResponder: Bool!
    var floatingLabelShowAnimationDuration: NSTimeInterval!
    var floatingLabelHideAnimationDuration: NSTimeInterval!
    
    var adjustClearButtonRect: Bool!
    var keepBaseline: Bool!
    
    var placeholderLabel: UILabel!
    var placeholder: String!
    
    var placeholderYPadding: CGFloat!
    var placeholderXPadding: CGFloat!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.grayColor().CGColor
        
        colorSchemeSetup()
        
        commitInit()
   
    }
    
    func setPlaceholderText(text: String){
        
        placeholder = text
        placeholderLabel.text = placeholder
        floatingLabel.text = placeholder
        
        if floatingLabelShouldLockToTop {
             floatingLabel.frame = CGRectMake(floatingLabel.frame.origin.x, floatingLabel.frame.origin.y, self.frame.size.width, floatingLabel.frame.size.height)
        }
        
        self.setNeedsLayout()
    }
    
    func commitInit(){
        
        startingTextContainerInsetTop = self.textContainerInset.top
        floatingLabelShouldLockToTop = true
        self.textContainer.lineFragmentPadding = 0
        
        placeholderLabel = UILabel(frame: self.frame)
        
        if self.font == nil {
            self.font = placeholderLabel.font;
        }
        
        placeholderLabel.font = self.font
        placeholderLabel.text = self.placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        placeholderLabel.backgroundColor = UIColor.clearColor()
        placeholderLabel.textColor = defaultiOSPlaceholderColor()
        
        self.insertSubview(placeholderLabel, atIndex: 0)
    
        
        floatingLabel = UILabel()
        floatingLabel.alpha = 0.0
        
        self.addSubview(floatingLabel)
        
        floatingLabelTextFont = defaultFloatingLabelFont()
        
        floatingLabel.font = floatingLabelTextFont
        floatingLabel.textColor = floatingLabelTextColor
        
        animateEvenIfNotFirstResponder = false
        floatingLabelShowAnimationDuration = 0.3
        floatingLabelHideAnimationDuration = 0.3
 
        
        adjustClearButtonRect = true
        isFloatingFontDefault = true
        
        floatingLabelXPadding = 1
        floatingLabelYPadding = 1
        
        placeholderYPadding = 1
        placeholderXPadding = 1
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "layoutSubviews", name: UITextViewTextDidChangeNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "layoutSubviews", name: UITextViewTextDidBeginEditingNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "layoutSubviews", name: UITextViewTextDidEndEditingNotification, object: self)
        
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        adjustTextContainerInsetTop()
        
        var floatingLabelSize = floatingLabel.sizeThatFits(floatingLabel.superview!.bounds.size)
        
        floatingLabel.frame = CGRectMake(floatingLabel.frame.origin.x, floatingLabel.frame.origin.y, floatingLabelSize.width, floatingLabelSize.height)
        
        var placeholderLabelSize = placeholderLabel.sizeThatFits(placeholderLabel.superview!.bounds.size)
        
        placeholderLabel.alpha = count(self.text) > 0 ? 0.0 : 1.0
        placeholderLabel.frame = CGRectMake(textRect().origin.x, textRect().origin.y, placeholderLabelSize.width, placeholderLabelSize.height)
        
        updateOriginForTextAlignment()
        
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
    
    func defaultiOSPlaceholderColor() -> UIColor {
        
        return UIColor.lightGrayColor().colorWithAlphaComponent(0.65)
    }
    
    func adjustTextContainerInsetTop(){
        
        self.textContainerInset = UIEdgeInsetsMake(self.startingTextContainerInsetTop + floatingLabel.font.lineHeight + placeholderYPadding, self.textContainerInset.left, self.textContainerInset.bottom, self.textContainerInset.right)
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
    
    func textRect() -> CGRect {
        var rect = UIEdgeInsetsInsetRect(self.bounds, self.contentInset)
        
        rect.origin.x += self.textContainer.lineFragmentPadding
        rect.origin.y += self.textContainerInset.top
        
        
        return CGRectIntegral(rect)
    }
    
    func defaultFloatingLabelFont() -> UIFont {
        
        var textFieldFont = placeholderLabel.font
        
        if self.placeholderLabel.attributedText != nil && self.placeholderLabel.attributedText.length > 0 {
            textFieldFont = self.placeholderLabel.attributedText!.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as! UIFont
        }
        
        return UIFont(name: textFieldFont.fontName, size: textFieldFont.pointSize * 0.7)!
    }
    
    
    func updateOriginForTextAlignment(){
        
        var floatingLabelOriginX = textRect().origin.x ;
        var placeholderLabelOriginX = floatingLabelOriginX
        
        switch self.textAlignment {
            
        case .Center:
            floatingLabelOriginX = self.frame.size.width/2 - floatingLabel.frame.size.width/2
            placeholderLabelOriginX = self.frame.size.width/2 - placeholderLabel.frame.size.width/2
        
        
        case .Right:
            floatingLabelOriginX = self.frame.size.width - floatingLabel.frame.size.width
            placeholderLabelOriginX = self.frame.size.width - placeholderLabel.frame.size.width - self.textContainerInset.right
        
        default:
            break
        }

       floatingLabel.frame = CGRectMake(floatingLabelOriginX + floatingLabelXPadding, floatingLabel.frame.origin.y, floatingLabel.frame.size.width, floatingLabel.frame.size.height)
        
       placeholderLabel.frame = CGRectMake(placeholderLabelOriginX, placeholderLabel.frame.origin.y, placeholderLabel.frame.size.width, placeholderLabel.frame.size.height)
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