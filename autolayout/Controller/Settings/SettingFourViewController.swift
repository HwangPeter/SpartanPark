//
//  SignUpViewController.swift
//  autolayout
//
//  Created by Hun Zaw on 3/19/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase

class SettingFourViewController: UIViewController {
    
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
    let passwordTextField = textFieldSecureContainer(mytext: "Current Password")
    let emailTextField = textFieldContainer(mytext: "Email address")
    
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
    
    var fourthViewUser = userSetting()
    
    @objc private func handleNext() {
        
        let vcPass = SettingViewController()
        
        vcPass.fifthViewUser.SSN = fourthViewUser.SSN
        
        vcPass.fifthViewUser.name = nameTextField.text!
        vcPass.fifthViewUser.email = emailTextField.text!
        vcPass.fifthViewUser.password = passwordTextField.text!
        
        vcPass.fifthViewUser.licenseNumber = fourthViewUser.licenseNumber
        vcPass.fifthViewUser.licenseName = fourthViewUser.licenseName
        vcPass.fifthViewUser.licenseExpiration = fourthViewUser.licenseExpiration
        vcPass.fifthViewUser.licenseDOB = fourthViewUser.licenseDOB
        
        vcPass.fifthViewUser.carModel = fourthViewUser.carModel
        vcPass.fifthViewUser.carMake = fourthViewUser.carMake
        vcPass.fifthViewUser.carYear = fourthViewUser.carYear
        vcPass.fifthViewUser.carColor = fourthViewUser.carColor
        
        vcPass.fifthViewUser.cardNumber = fourthViewUser.cardNumber
        vcPass.fifthViewUser.cardName = fourthViewUser.cardName
        vcPass.fifthViewUser.cardExpiration = fourthViewUser.cardExpiration
        vcPass.fifthViewUser.cardCVV = fourthViewUser.cardCVV
        
        present(vcPass, animated: true, completion: nil)
        
        
    }
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 6
        pc.currentPageIndicatorTintColor = .mainPink
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupBottomControls()
        setupLayout()
        fetchUserInfo()
        self.hideKeyboardWhenTappedAround() 
    }
    
    fileprivate func setupBottomControls() {
        pageControl.currentPage = 4
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
            emailTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9),
            emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
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
        
        emailTextField.isUserInteractionEnabled = false
        
    }
    
    private func fetchUserInfo () {
        
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //user model has name, email, and profileImageUrl, etc stored in database
            //fetch anything stored in the database in this if statement
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                //grab the image url from firebase
                let name = dictionary["name"] as? String
                let email = dictionary["email"] as? String
                
                self.nameTextField.text = name
                self.emailTextField.text = email
            }
            
        }, withCancel: nil)
    }
    
    func getNameTextField () -> String? {
        return nameTextField.text
    }
    
}
