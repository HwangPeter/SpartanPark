//
//  containerView.swift
//  autolayout
//
//  Created by Hun Zaw on 3/20/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import Foundation
import UIKit

public class containerView : UIView {
    
    init() {
        super.init(frame: UIScreen.main.bounds);
        self.backgroundColor = nil
        self.translatesAutoresizingMaskIntoConstraints = false   
        return;
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
}
