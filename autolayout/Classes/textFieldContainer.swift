//
//  textFieldContainer.swift
//  autolayout
//
//  Created by Hun Zaw on 3/21/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import Foundation
import UIKit

public class textFieldContainer : UITextField {
    
    var mytext: String
    
    init(mytext: String) {
        self.mytext = mytext
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        self.placeholder = mytext
        //textField.font = UIFont.systemFont(ofSize: 20)
        self.borderStyle = UITextField.BorderStyle.none
        //self.backgroundColor = UIColor(red: 255/225.0, green: 253/225.0, blue: 228/225.0, alpha: 1)
        self.backgroundColor = UIColor.white
        self.textAlignment = .center
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.clearButtonMode = UITextField.ViewMode.whileEditing
        self.translatesAutoresizingMaskIntoConstraints = false
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
