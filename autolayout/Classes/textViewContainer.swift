//
//  textViewContainer.swift
//  autolayout
//
//  Created by Hun Zaw on 3/21/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import Foundation
import UIKit

public class textViewContainer : UITextView {
    
    var mytext: String
    
    init(mytext: String) {
        self.mytext = mytext
        super.init(frame: CGRect.zero, textContainer: nil)
        self.text = mytext
        self.backgroundColor = nil
        self.textColor = UIColor(red: 0/225.0, green: 85/225.0, blue: 162/225.0, alpha: 1)
        self.textAlignment = .center
        self.isEditable = false
        self.isScrollEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
        return
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
}
