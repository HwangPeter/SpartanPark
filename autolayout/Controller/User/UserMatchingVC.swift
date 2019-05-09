//
//  MatchingViewController.swift
//  autolayout
//
//  Created by Peter Hwang on 4/16/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase

class UserMatchingVC: UIViewController {
    var currentVC:UserMapVC?
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Matching..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor(red: 255/225.0, green: 255/225.0, blue: 255/225.0, alpha: 1)
        return label
    }()
    
    let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    let pulsingLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        setupLayers()
        
        view.layer.addSublayer(shapeLayer)
        animateStroke()
        //view.layer.addSublayer(pulsingLayer)
        //animatePulsingLayer()
        view.addSubview(textLabel)
        textLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 300)
        textLabel.center = view.center
        
        view.addSubview(cancelButton)
        setupCancelButton()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
    }
    
    private func setupCancelButton() {
        let buttonWidth = CGFloat(180), buttonHeight = CGFloat(60)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.backgroundColor = UIColor.clear
        //        cancelButton.layer.borderColor = UIColor.red.cgColor
        //        cancelButton.layer.borderWidth = 7/UIScreen.main.nativeScale
        cancelButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        cancelButton.layer.cornerRadius = cancelButton.frame.width/2
    }
    
    private func setupLayers() {
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 120, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red: 0/225.0, green: 90/225.0, blue: 167/225.0, alpha: 1).cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.opacity = 0.8
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor(white: 0, alpha: 0.8).cgColor
        shapeLayer.strokeEnd = 0
        
    }
    
    private func animateStroke() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 1.2
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        shapeLayer.add(animation, forKey: "Circling")
        
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.toValue = UIColor.white.cgColor
        colorAnimation.duration = 2
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        colorAnimation.autoreverses = true
        colorAnimation.repeatCount = Float.infinity
        shapeLayer.add(colorAnimation, forKey: "Coloring")
        
        let widthAnimation = CABasicAnimation(keyPath: "lineWidth")
        widthAnimation.toValue = 25
        widthAnimation.duration = 1.2
        widthAnimation.fillMode = .forwards
        widthAnimation.isRemovedOnCompletion = false
        //widthAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        widthAnimation.autoreverses = true
        widthAnimation.repeatCount = Float.infinity
        shapeLayer.add(widthAnimation, forKey: "Pulsing")
    }
    
    
    @objc func cancelButtonClicked() {
        let uid = Auth.auth().currentUser?.uid
        
        let requestRef = Database.database().reference().child("ongoingRequests").child(uid!)
        requestRef.removeAllObservers()
        requestRef.removeValue()
        let mapVC = currentVC
        mapVC?.currentVC = mapVC
        dismiss(animated: true, completion: nil)
    }
    
    func matchFound() {
        dismiss(animated: true, completion: nil)
    }
}
