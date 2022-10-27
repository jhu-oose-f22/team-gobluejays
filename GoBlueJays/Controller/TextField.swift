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
    
}
