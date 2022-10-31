//
//  TextField.swift
//  GoBlueJays
//
//  Created by Thomas Yu on 10/27/22.
//

import UIKit

class TextField: UITextField, UITextFieldDelegate{
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false; //disables long press options on the textfield
    }
    
}
