//
//  HVKStickerImageView.swift
//  ImageDemo
//
//  Created by Harsh Vardhan Kushwaha on 07/11/22.
//

import UIKit

public class HVKStickerImageView: UIImageView , UIGestureRecognizerDelegate {
    public var currentlyEditingLabel: HVKStickerView!
    fileprivate var labels: [HVKStickerView]!
    private var renderedView: UIView!
    
    fileprivate lazy var tapOutsideGestureRecognizer: UITapGestureRecognizer! = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HVKStickerImageView.tapOutside))
        tapGesture.delegate = self
        return tapGesture
        
    }()
    
    //MARK: init
    
    init() {
        super.init(frame: CGRect.zero)
        isUserInteractionEnabled = true
        labels = []
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        labels = []
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = true
        labels = []
    }
    
}

//MARK: Functions
extension HVKStickerImageView {
    
    public func addLabel() {
        if let label: HVKStickerView = currentlyEditingLabel {
            label.hideEditingHandlers()
        }
        
        let labelFrame = CGRect(x: self.bounds.midX - CGFloat(arc4random()).truncatingRemainder(dividingBy: 20),
                                    y: self.bounds.midY - CGFloat(arc4random()).truncatingRemainder(dividingBy: 20),
                                    width: 60, height: 50)
        let labelView = HVKStickerView(frame: labelFrame)
        labelView.setupTextLabel()
        labelView.delegate = self
        self.addSubview(labelView)
        currentlyEditingLabel = labelView
        adjustsWidthToFillItsContens(currentlyEditingLabel)
        labels.append(labelView)
        
        self.addGestureRecognizer(tapOutsideGestureRecognizer)
    }
    
    public func addImage(image:UIImage) {
        if let label: HVKStickerView = currentlyEditingLabel {
            label.hideEditingHandlers()
        }
        
        let labelFrame = CGRect(x: self.bounds.midX - CGFloat(arc4random()).truncatingRemainder(dividingBy: 20),
                                y: self.bounds.midY - CGFloat(arc4random()).truncatingRemainder(dividingBy: 20),
                                width: 60, height: 50)
        let labelView = HVKStickerView(frame: labelFrame)
        labelView.setupImageLabel()
        self.addSubview(labelView)
        currentlyEditingLabel = labelView
        adjustsWidthToFillItsContens(currentlyEditingLabel)
        labels.append(labelView)
        labelView.imageView?.image = image
        self.addGestureRecognizer(tapOutsideGestureRecognizer)
    }
    
    public func renderContentOnView() -> UIImage? {
        
        self.cleanup()
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return img
    }
    
    public func limitImageViewToSuperView() {
        if self.superview == nil {
            return
        }
        guard let imageSize = self.image?.size else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = true
        let aspectRatio = imageSize.width / imageSize.height
        
        if imageSize.width > imageSize.height {
            self.bounds.size.width = self.superview!.bounds.size.width
            self.bounds.size.height = self.superview!.bounds.size.width / aspectRatio
        }else {
            self.bounds.size.height = self.superview!.bounds.size.height
            self.bounds.size.width = self.superview!.bounds.size.height * aspectRatio
        }
    }
    
    // MARK: -
    
    func cleanup() {
        for label in labels {
            if let isEmpty = label.labelTextView?.text.isEmpty, isEmpty {
                label.closeTap(nil)
            } else {
                label.hideEditingHandlers()
            }
        }
    }
}

//MARK: Gesture
extension HVKStickerImageView {
    @objc func tapOutside() {
        if let _: HVKStickerView = currentlyEditingLabel {
            currentlyEditingLabel.hideEditingHandlers()
        }
        
    }
}

//MARK: stickerViewDelegate
extension HVKStickerImageView: HVKStickerViewDelegate {
    public func labelViewDidBeginEditing(_ label: HVKStickerView) {
        //labels.removeObject(label)
        
    }
    
    public func labelViewDidClose(_ label: HVKStickerView) {
        
    }
    
    public func labelViewDidShowEditingHandles(_ label: HVKStickerView) {
        currentlyEditingLabel = label
        
    }
    
    public func labelViewDidHideEditingHandles(_ label: HVKStickerView) {
        currentlyEditingLabel = nil
        
    }
    
    public func labelViewDidStartEditing(_ label: HVKStickerView) {
        currentlyEditingLabel = label
        
    }
    
    public func labelViewDidChangeEditing(_ label: HVKStickerView) {
        
    }
    
    public func labelViewDidEndEditing(_ label: HVKStickerView) {
        
        
    }
    
    public func labelViewDidSelected(_ label: HVKStickerView) {
        for labelItem in labels {
            labelItem.hideEditingHandlers()
        }
        label.showEditingHandles()
    }
    
}

//MARK: Set propeties
extension HVKStickerImageView: adjustFontSizeToFillRectProtocol {
    
    public var fontName: String! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.fontName = newValue
                adjustsWidthToFillItsContens(currentlyEditingLabel)
            }
        }
        get {
            return self.currentlyEditingLabel.labelTextView?.fontName
        }
    }
    
    //MARK: text Format
    
    public var textAlignment: NSTextAlignment! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.alignment = newValue
            }
            
        }
        get {
            return self.currentlyEditingLabel.labelTextView?.alignment
        }
    }
    
    public var lineSpacing: CGFloat! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.lineSpacing = newValue
                adjustsWidthToFillItsContens(currentlyEditingLabel)
            }
            
        }
        get {
            return self.currentlyEditingLabel.labelTextView?.lineSpacing
            
        }
    }
}
