//
//  GradientView.swift
//  autolayout
//
//  Created by Hun Zaw on 4/18/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import Foundation
import UIKit

public class GradientView : UIView {
    
    let gradient = CAGradientLayer()
    
    init() {
        super.init(frame: UIScreen.main.bounds);
        
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: 414, height: 130)
        gradient.colors = [UIColor.white.cgColor, UIColor.init(white: 1.0, alpha: 0.0).cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.locations = [0.8, 1.0]
        self.layer.addSublayer(gradient)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        return
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
}

