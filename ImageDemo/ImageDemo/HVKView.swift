//
//  HVKView.swift
//  ImageDemo
//
//  Created by Harsh Vardhan Kushwaha on 07/11/22.
//

import UIKit

class HVKView: UIView {
    //MARK: -
    //MARK: Gestures
    
    fileprivate lazy var moveGestureRecognizer: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HVKView.moveGesture(_:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    
    fileprivate lazy var panRotateGesture: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HVKView.rotateViewPanGesture(_:)))
        panRecognizer.delegate = self
        return panRecognizer
    }()
    
    //MARK: -
    //MARK: properties
    
    fileprivate var lastTouchedView: HVKView?
    
    var delegate: HVKViewDelegate?
    
    fileprivate var globalInset: CGFloat?
    
    fileprivate var initialBounds: CGRect?
    fileprivate var initialDistance: CGFloat?
    
    fileprivate var beginningPoint: CGPoint?
    fileprivate var beginningCenter: CGPoint?
    
    fileprivate var touchLocation: CGPoint?
    
    fileprivate var deltaAngle: CGFloat?
    fileprivate var beginBounds: CGRect?
    
    public var labelTextView: HVKTextView?
    public var rotateView: UIImageView?
    public var imageView: UIImageView?
    
    
    //MARK: -
    //MARK: didMoveToSuperView
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview != nil {
            self.showEditingHandles()
            self.refresh()
        }
    }
    
    //MARK: -
    //MARK: init
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if frame.size.width < 25 {
            self.bounds.size.width = 25
        }
        
        if frame.size.height < 25 {
            self.bounds.size.height = 25
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    private func setup() {
        
        self.setupCloseAndRotateView()
        
        self.addGestureRecognizer(moveGestureRecognizer)
        self.moveGestureRecognizer.require(toFail: closeTap)
        
        self.rotateView!.addGestureRecognizer(panRotateGesture)
        
        adjustsWidthToFillItsContens(self)
    }
    
    func setupTextLabel() {
        self.globalInset = 19
        
        self.backgroundColor = UIColor.clear
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.setupLabelTextView()
        self.setupBorder()
        
        self.insertSubview(labelTextView!, at: 0)
        
        self.setup()
        
        adjustsWidthToFillItsContens(self)
    }
    
    func setupImageLabel() {
        self.globalInset = 19
        
        self.backgroundColor = UIColor.clear
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.setupImageView()
        self.setupBorder()
        
        self.insertSubview(imageView!, at: 0)
        
        self.setup()
        
        var viewFrame = self.bounds
        viewFrame.size.width = 100
        viewFrame.size.height = 100
        self.bounds = viewFrame
    }
}

//MARK: -
//MARK: labelTextViewDelegate
extension HVKView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        if let delegate: HVKViewDelegate = delegate {
            if delegate.responds(to: #selector(HVKViewDelegate.labelViewDidStartEditing(_:))) {
                delegate.labelViewDidStartEditing!(self)
            }
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (!isShowingEditingHandles) {
            self.showEditingHandles()
        }
        //if textView.text != "" {
        //adjustsWidthToFillItsContens(self, labelView: labelTextView)
        //}
        
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text != "" {
            if labelTextView != nil {
                adjustsWidthToFillItsContens(self)
                labelTextView!.attributedText = NSAttributedString(string: labelTextView!.text, attributes: labelTextView!.textAttributes)
            }
            
            
        }
    }
}
//MARK: -
//MARK: GestureRecognizer
extension HVKView: UIGestureRecognizerDelegate, adjustFontSizeToFillRectProtocol {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == singleTapShowHide {
            return true
        }
        return false
    }
    
    
    @objc func contentTapped(_ recognizer: UITapGestureRecognizer) {
        if !isShowingEditingHandles {
            self.showEditingHandles()
            
            if let delegate: HVKViewDelegate = delegate {
                delegate.labelViewDidSelected!(self)
            }
        }
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer?) {
        self.removeFromSuperview()
        
        if let delegate: HVKViewDelegate = delegate {
            if delegate.responds(to: #selector(HVKViewDelegate.labelViewDidClose(_:))) {
                delegate.labelViewDidClose!(self)
            }
        }
    }
    
    @objc func moveGesture(_ recognizer: UIPanGestureRecognizer) {
        if !isShowingEditingHandles {
            self.showEditingHandles()
            
            if let delegate: HVKViewDelegate = delegate {
                delegate.labelViewDidSelected!(self)
            }
        }
        
        self.touchLocation = recognizer.location(in: self.superview)
        
        switch recognizer.state {
        case .began:
            beginningPoint = touchLocation
            beginningCenter = self.center
            
            self.center = self.estimatedCenter()
            beginBounds = self.bounds
            
            if let delegate: HVKViewDelegate = delegate {
                delegate.labelViewDidBeginEditing!(self)
            }
            
        case .changed:
            self.center = self.estimatedCenter()
            
            
            if let delegate: HVKViewDelegate = delegate {
                delegate.labelViewDidChangeEditing!(self)
            }
            
        case .ended:
            self.center = self.estimatedCenter()
            
            
            if let delegate: HVKViewDelegate = delegate {
                delegate.labelViewDidEndEditing!(self)
            }
            
        default:break
            
        }
    }
    
    @objc func rotateViewPanGesture(_ recognizer: UIPanGestureRecognizer) {
        touchLocation = recognizer.location(in: self.superview)
        
        let center = CalculateFunctions.CGRectGetCenter(self.frame)
        
        switch recognizer.state {
        case .began:
            deltaAngle = atan2(touchLocation!.y - center.y, touchLocation!.x - center.x) - CalculateFunctions.CGAffineTrasformGetAngle(self.transform)
            initialBounds = self.bounds
            initialDistance = CalculateFunctions.CGpointGetDistance(center, point2: touchLocation!)
            
            if let delegate: HVKViewDelegate = delegate {
                if delegate.responds(to: #selector(HVKViewDelegate.labelViewDidBeginEditing(_:))) {
                    delegate.labelViewDidBeginEditing!(self)
                }
            }
            
        case .changed:
            let ang = atan2(touchLocation!.y - center.y, touchLocation!.x - center.x)
            
            let angleDiff = deltaAngle! - ang
            self.transform = CGAffineTransform(rotationAngle: -angleDiff)
            self.layoutIfNeeded()
            
            //Finding scale between current touchPoint and previous touchPoint
            let scale = sqrtf(Float(CalculateFunctions.CGpointGetDistance(center, point2: touchLocation!)) / Float(initialDistance!))
            let scaleRect = CalculateFunctions.CGRectScale(initialBounds!, wScale: CGFloat(scale), hScale: CGFloat(scale))
            
            if scaleRect.size.width >= (1 + globalInset! * 2) && scaleRect.size.height >= (1 + globalInset! * 2) && self.labelTextView?.text != "" {
                //  if fontSize < 100 || CGRectGetWidth(scaleRect) < CGRectGetWidth(self.bounds) {
                if scale < 1 && (labelTextView?.fontSize ?? 0) <= 9 {
                    
                }else {
                    self.adjustFontSizeToFillRect(scaleRect, view: self)
                    self.bounds = scaleRect
                    self.adjustsWidthToFillItsContens(self)
                    self.refresh()
                }
            }
            
            if let delegate: HVKViewDelegate = delegate {
                if delegate.responds(to: #selector(HVKViewDelegate.labelViewDidChangeEditing(_:))) {
                    delegate.labelViewDidChangeEditing!(self)
                }
            }
        case .ended:
            if let delegate: HVKViewDelegate = delegate {
                if delegate.responds(to: #selector(HVKViewDelegate.labelViewDidEndEditing(_:))) {
                    delegate.labelViewDidEndEditing!(self)
                }
            }
            
            self.refresh()
            
            //self.adjustsWidthToFillItsContens(self, labelView: labelTextView)
        default:break
            
        }
    }
}

//MARK: -
//MARK: setup
extension HVKView {
    private func setupLabelTextView() {
        labelTextView = JLAttributedTextView(frame: self.bounds.insetBy(dx: globalInset!, dy: globalInset!))
        labelTextView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        labelTextView?.clipsToBounds = true
        labelTextView?.delegate = self
        labelTextView?.backgroundColor = UIColor.clear
        labelTextView?.tintColor = UIColor(red: 33, green: 45, blue: 59, alpha: 1)
        labelTextView?.isScrollEnabled = false
        labelTextView?.isSelectable = true
        labelTextView?.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    private func setupBorder() {
        border = CAShapeLayer(layer: layer)
        border?.strokeColor = borderColor?.cgColor
        border?.fillColor = nil
        border?.lineDashPattern = [10, 2]
        border?.lineWidth = 1
        
    }
    
    private func setupCloseAndRotateView() {
        closeView = UIImageView(frame: CGRect(x: 0, y: 0, width: globalInset! * 2 - 6, height: globalInset! * 2 - 6))
        closeView?.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        closeView?.contentMode = .scaleAspectFit
        closeView?.clipsToBounds = true
        closeView?.backgroundColor = UIColor.clear
        closeView?.isUserInteractionEnabled = true
        self.addSubview(closeView!)
        
        rotateView = UIImageView(frame: CGRect(x: self.bounds.size.width - globalInset! * 2, y: self.bounds.size.height - globalInset! * 2, width: globalInset! * 2 - 6, height: globalInset! * 2 - 6))
        rotateView?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        rotateView?.backgroundColor = UIColor.clear
        rotateView?.clipsToBounds = true
        rotateView?.contentMode = .scaleAspectFit
        rotateView?.isUserInteractionEnabled = true
        self.addSubview(rotateView!)
    }
    
    private func setupImageView() {
        imageView = UIImageView(frame: self.bounds.insetBy(dx: globalInset!, dy: globalInset!))
        imageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
        imageView?.backgroundColor = UIColor.clear
    }
}


//MARK: -
//MARK: Help funcitons
extension HVKView {
    
    fileprivate func refresh() {
        if let superView: UIView = self.superview {
            let transform: CGAffineTransform = superView.transform
            let scale = CalculateFunctions.CGAffineTransformGetScale(transform)
            let t = CGAffineTransform(scaleX: scale.width, y: scale.height)
            self.closeView?.transform = t.inverted()
            self.rotateView?.transform = t.inverted()
            
            if (isShowingEditingHandles) {
                if let border: CALayer = border {
                    self.labelTextView?.layer.addSublayer(border)
                    self.imageView?.layer.addSublayer(border)
                }
            }else {
                border?.removeFromSuperlayer()
            }
        }
    }
    
    public func hideEditingHandlers() {
        lastTouchedView = nil
        
        isShowingEditingHandles = false
        
        if enableClose {
            closeView?.isHidden = true
        }
        if enableRotate {
            rotateView?.isHidden = true
        }
        
        labelTextView?.resignFirstResponder()
        
        self.refresh()
        
        if let delegate : HVKViewDelegate = delegate {
            if delegate.responds(to: #selector(HVKViewDelegate.labelViewDidHideEditingHandles(_:))) {
                delegate.labelViewDidHideEditingHandles!(self)
            }
        }
    }
    
    public func showEditingHandles() {
        lastTouchedView?.hideEditingHandlers()
        
        isShowingEditingHandles = true
        
        lastTouchedView = self
        
        if enableClose {
            closeView?.isHidden = false
        }
        
        if enableRotate {
            rotateView?.isHidden = false
        }
        
        self.refresh()
        
        if let delegate: HVKViewDelegate = delegate {
            if delegate.responds(to: #selector(HVKViewDelegate.labelViewDidShowEditingHandles(_:))) {
                delegate.labelViewDidShowEditingHandles!(self)
            }
        }
    }
    
    fileprivate func estimatedCenter() -> CGPoint{
        let newCenter: CGPoint!
        var newCenterX = beginningCenter!.x + (touchLocation!.x - beginningPoint!.x)
        var newCenterY = beginningCenter!.y + (touchLocation!.y - beginningPoint!.y)
        
        if (enableMoveRestriction) {
            if (!(newCenterX - 0.5 * self.frame.width > 0 &&
                  newCenterX + 0.5 * self.frame.width < self.superview!.bounds.width)) {
                newCenterX = self.center.x;
            }
            if (!(newCenterY - 0.5 * self.frame.height > 0 &&
                  newCenterY + 0.5 * self.frame.height < self.superview!.bounds.height)) {
                newCenterY = self.center.y;
            }
            newCenter = CGPoint(x: newCenterX, y: newCenterY)
        }else {
            newCenter = CGPoint(x: newCenterX, y: newCenterY)
        }
        return newCenter
    }
}
