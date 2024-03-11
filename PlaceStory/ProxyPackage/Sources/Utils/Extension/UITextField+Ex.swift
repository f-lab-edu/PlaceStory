//
//  File.swift
//  
//
//  Created by 최제환 on 3/12/24.
//

import UIKit

extension UITextField {
    public func addDoneToolbar() {
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneAction))
        
        toolbar.items = [
            flexibleSpaceButton,
            doneButton
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    @objc private func doneAction() {
        self.resignFirstResponder()
    }
}
