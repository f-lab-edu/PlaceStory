//
//  File.swift
//  
//
//  Created by 최제환 on 1/3/24.
//

import UIKit

public protocol ModalAdaptivePresentationControllerDelegate: AnyObject {
    func presentationControllerDidDismiss()
}

public final class ModalAdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
    
    public weak var delegate: ModalAdaptivePresentationControllerDelegate?
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.presentationControllerDidDismiss()
    }
}
