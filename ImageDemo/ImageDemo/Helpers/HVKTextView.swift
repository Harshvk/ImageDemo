//
//  HVKTextView.swift
//  ImageDemo
//
//  Created by Harsh Vardhan Kushwaha on 07/11/22.
//

import UIKit

public class HVKTextView: UITextView {
    
    
    public private(set) var textAttributes: [NSAttributedString.Key: AnyObject] = [:]
    
    //MARK: Alpha
    public var textAlpha: CGFloat = 1 {
        didSet {
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
        }
    }
    
    //MARK: Font
    
    public var fontName: String = "HelveticaNeue" {
        didSet {
            let font = UIFont(name: fontName, size: fontSize)
            textAttributes[NSAttributedString.Key.font] = font
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
            self.font = font
        }
    }
    
    public var fontSize: CGFloat = 20 {
        didSet {
            let font = UIFont(name: fontName, size: fontSize)
            textAttributes[NSAttributedString.Key.font] = font
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
            self.font = font
        }
    }
    
    
    //MARK: Paragraph style
    public var paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle() {
        didSet {
            textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
    }

    public var alignment: NSTextAlignment {
        get {
            return paragraphStyle.alignment
        }
        set {
            paragraphStyle.alignment = newValue
            textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
        }
    }
    
    public var lineSpacing: CGFloat {
        get {
            return paragraphStyle.lineSpacing
        }
        
        set {
            paragraphStyle.lineSpacing = newValue
            textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
            
        }
    }
    
    public var paragraphSpacing: CGFloat {
        get {
            return paragraphStyle.paragraphSpacing
        }
        
        set {
            paragraphStyle.paragraphSpacing = newValue
            textAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            self.attributedText = NSAttributedString(string: self.text, attributes: textAttributes)
        }
    }
}

//MARK: CGRect of Cursor
extension HVKTextView {
    override public func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        originalRect.size.height = self.font!.pointSize - self.font!.descender
        return originalRect
    }
}
