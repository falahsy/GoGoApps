//
//  UIView+Extension.swift
//  cycle
//
//  Created by Azmi Muhammad on 23/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit
enum RadiusType {
    case rounded
    case quarter
    case custom(CGFloat)
}

extension UIView {
    
    fileprivate typealias Action = (() -> Void)?
    
    func setupRadius(type: RadiusType, isMaskToBounds: Bool = false) {
        var radius: CGFloat = 0.0
        
        switch type {
        case .rounded:
            radius = frame.width / 2
        case .quarter:
            radius = frame.width / 4
        case .custom(let value):
            radius = value
        }
        
        layer.cornerRadius = radius
        layer.masksToBounds = isMaskToBounds
    }
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    func tapGesture(action: (() -> Void)?) {
        isUserInteractionEnabled = true
        tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
}
