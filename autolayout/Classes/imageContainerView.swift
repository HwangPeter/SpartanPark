//
//  imageContainerView.swift
//  autolayout
//
//  Created by Hun Zaw on 3/20/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import Foundation
import UIKit

public class imageContainerView : UIView {
    
    init() {
        //super.init(frame: UIScreen.main.bounds);
        //self.backgroundColor = nil
        //self.translatesAutoresizingMaskIntoConstraints = false
        //return;
        
        super.init(frame: UIScreen.main.bounds);
        let spartan = UIImage(named: "spartan_spirit")
        let spartanView = UIImageView(image: spartan)
        spartanView.translatesAutoresizingMaskIntoConstraints = false //enable autolayout for our image
        spartanView.contentMode = .scaleAspectFit
        return
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
}

