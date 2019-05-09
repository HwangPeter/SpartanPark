//
//  SignUpViewController.swift
//  autolayout
//
//  Created by Hun Zaw on 3/19/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase

class valetInfoSignupVC: UIViewController {
    
    let backButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.backgroundColor = nil
        button.setImage(UIImage(named: "back-button3"), for: .normal)
        button.showsTouchWhenHighlighted = true
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func backButtonClicked(){
        print("Back Button Clicked")
        //present(ViewController(), animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    let topImageContainerView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let spartanImageView: UIImageView = {
        let spartan = UIImage(named: "spartan_spirit")
        let imageView = UIImageView(image: spartan)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let inputContainerView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailBottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordBottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameBottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //let emailBottomLine = containerView()
    
    let nameTextField = textFieldContainer(mytext: "First Last")
    let passwordTextField = textFieldSecureContainer(mytext: "Password")
    let emailTextField = textFieldContainer(mytext: "SJSU Email")
    let emailDoamin = textFieldContainer(mytext: "Email Domain")
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrev() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    var infoSignupUser = valet()
    
    @objc private func handleNext() {
        
        let vcPass = valetSignupVC()
        
        let myDomain = "@sjsu.edu"
        let myEmail = emailTextField.text! as String
        let newString = myEmail + myDomain
        
        vcPass.profileUser.name = nameTextField.text!
        vcPass.profileUser.email = newString
        //vcPass.profileUser.email = emailTextField.text!
        vcPass.profileUser.password = passwordTextField.text!
        
        vcPass.profileUser.licenseNumber = infoSignupUser.licenseNumber
        vcPass.profileUser.licenseName = infoSignupUser.licenseName
        vcPass.profileUser.licenseExpiration = infoSignupUser.licenseExpiration
        vcPass.profileUser.licenseDOB = infoSignupUser.licenseDOB
        
        vcPass.profileUser.SSN = infoSignupUser.SSN
        
        vcPass.profileUser.cardNumber = infoSignupUser.cardNumber
        vcPass.profileUser.cardName = infoSignupUser.cardName
        vcPass.profileUser.cardExpiration = infoSignupUser.cardExpiration
        vcPass.profileUser.cardCVV = infoSignupUser.cardCVV
        
        present(vcPass, animated: true, completion: nil)
        
        
    }
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 5
        pc.currentPageIndicatorTintColor = .mainPink
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupBottomControls()
        setupLayout()
        self.hideKeyboardWhenTappedAround()
    }
    
    fileprivate func setupBottomControls() {
        pageControl.currentPage = 3
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    private func setupLayout() {
        
        view.addSubview(topImageContainerView)
        topImageContainerView.addSubview(spartanImageView)
        topImageContainerView.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            topImageContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
            ])
        
        NSLayoutConstraint.activate([
            spartanImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
            spartanImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor),
            spartanImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.6)
            ])
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topImageContainerView.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: topImageContainerView.leadingAnchor),
            backButton.widthAnchor.constraint(equalTo: topImageContainerView.widthAnchor, multiplier: 0.2)
            ])
        
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailDoamin)
        inputContainerView.addSubview(emailBottomLine)
        inputContainerView.addSubview(passwordTextField)
        inputContainerView.addSubview(passwordBottomLine)
        inputContainerView.addSubview(nameBottomLine)
        
        inputContainerView.layer.cornerRadius = 5
        inputContainerView.layer.masksToBounds = true
        
        //initial placeholder text centered
        nameTextField.textAlignment = .left
        emailTextField.textAlignment = .left
        passwordTextField.textAlignment = .left
        emailDoamin.textAlignment = .left
        emailDoamin.text = "@sjsu.edu"
        
        
        NSLayoutConstraint.activate([ // need X, Y, width, height
            inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ])
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
            nameTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9),
            nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            nameBottomLine.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameBottomLine.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            nameBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.01),
            nameBottomLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: nameBottomLine.topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: nameBottomLine.leadingAnchor),
            emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.50),
            emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            emailDoamin.topAnchor.constraint(equalTo: nameBottomLine.topAnchor),
            emailDoamin.leadingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            emailDoamin.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.40),
            emailDoamin.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            emailBottomLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailBottomLine.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            emailBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.01),
            emailBottomLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailBottomLine.bottomAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9),
            passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            passwordBottomLine.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            passwordBottomLine.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            passwordBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.009),
            passwordBottomLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9)
            ])
        
    }
    
    func getNameTextField () -> String? {
        return nameTextField.text
    }
    
}
