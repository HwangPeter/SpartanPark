//
//  SignUpViewController.swift
//  autolayout
//
//  Created by Hun Zaw on 3/19/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase

class SettingThreeViewController: UIViewController {
    
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
        let spartan = UIImage(named: "driver-license")
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
    
    let licenseNumberBottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let licenseNameBottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let licenseExpirationBottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //let emailBottomLine = containerView()
    
    let licenseNumberTextField = textFieldContainer(mytext: "DL: D1234567")
    let licenseNameTextField = textFieldContainer(mytext: "First M Last")
    let licenseExpirationTextField = textFieldContainer(mytext: "EXP DD/MM/YYYY")
    let licenseDOBTextField = textFieldContainer(mytext: "DOB DD/MM/YYYY")
    
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
    
    var thirdViewUser = userSetting()
    
    @objc private func handleNext() {
        //        print("next")
        //
        //        print(thirdViewUser.carMake)
        //        print(thirdViewUser.carModel)
        //        print(thirdViewUser.carYear)
        //        print(thirdViewUser.carColor)
        //
        //        print(thirdViewUser.cardNumber)
        //        print(thirdViewUser.cardName)
        //        print(thirdViewUser.cardExpiration)
        //        print(thirdViewUser.cardCVV)
        
        let vcPass = SettingFourViewController()
        
        vcPass.fourthViewUser.SSN = thirdViewUser.SSN
        
        vcPass.fourthViewUser.licenseNumber = licenseNumberTextField.text!
        vcPass.fourthViewUser.licenseName = licenseNameTextField.text!
        vcPass.fourthViewUser.licenseExpiration = licenseExpirationTextField.text!
        vcPass.fourthViewUser.licenseDOB = licenseDOBTextField.text!
        
        vcPass.fourthViewUser.carModel = thirdViewUser.carModel
        vcPass.fourthViewUser.carMake = thirdViewUser.carMake
        vcPass.fourthViewUser.carYear = thirdViewUser.carYear
        vcPass.fourthViewUser.carColor = thirdViewUser.carColor
        
        vcPass.fourthViewUser.cardNumber = thirdViewUser.cardNumber
        vcPass.fourthViewUser.cardName = thirdViewUser.cardName
        vcPass.fourthViewUser.cardExpiration = thirdViewUser.cardExpiration
        vcPass.fourthViewUser.cardCVV = thirdViewUser.cardCVV
        
        present(vcPass, animated: true, completion: nil)
    }
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 3
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
        fetchLicenseInfo()
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
        inputContainerView.addSubview(licenseNumberTextField)
        inputContainerView.addSubview(licenseNameTextField)
        inputContainerView.addSubview(licenseExpirationTextField)
        inputContainerView.addSubview(licenseDOBTextField)
        inputContainerView.addSubview(licenseNumberBottomLine)
        inputContainerView.addSubview(licenseNameBottomLine)
        inputContainerView.addSubview(licenseExpirationBottomLine)
        
        inputContainerView.layer.cornerRadius = 5
        inputContainerView.layer.masksToBounds = true
        
        //initial placeholder text centered
        licenseNumberTextField.textAlignment = .left
        licenseNameTextField.textAlignment = .left
        licenseExpirationTextField.textAlignment = .left
        licenseDOBTextField.textAlignment = .left
        
        
        NSLayoutConstraint.activate([ // need X, Y, width, height
            inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ])
        
        NSLayoutConstraint.activate([
            licenseNumberTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
            licenseNumberTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            licenseNumberTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9),
            licenseNumberTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            licenseNumberBottomLine.topAnchor.constraint(equalTo: licenseNumberTextField.bottomAnchor),
            licenseNumberBottomLine.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            licenseNumberBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.01),
            licenseNumberBottomLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            licenseNameTextField.topAnchor.constraint(equalTo: licenseNumberBottomLine.topAnchor),
            licenseNameTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            licenseNameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9),
            licenseNameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            licenseNameBottomLine.topAnchor.constraint(equalTo: licenseNameTextField.bottomAnchor),
            licenseNameBottomLine.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            licenseNameBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.01),
            licenseNameBottomLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            licenseExpirationTextField.topAnchor.constraint(equalTo: licenseNameBottomLine.bottomAnchor),
            licenseExpirationTextField.leadingAnchor.constraint(equalTo: licenseNameBottomLine.leadingAnchor),
            licenseExpirationTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.45),
            licenseExpirationTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            licenseDOBTextField.topAnchor.constraint(equalTo: licenseNameBottomLine.bottomAnchor),
            licenseDOBTextField.leadingAnchor.constraint(equalTo: licenseExpirationTextField.trailingAnchor),
            licenseDOBTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.45),
            licenseDOBTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            licenseExpirationBottomLine.topAnchor.constraint(equalTo: licenseExpirationTextField.bottomAnchor),
            licenseExpirationBottomLine.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            licenseExpirationBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.009),
            licenseExpirationBottomLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9)
            ])
        
    }
    
    private func fetchLicenseInfo () {
        
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).child("License").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //user model has name, email, and profileImageUrl, etc stored in database
            //fetch anything stored in the database in this if statement
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                //grab the image url from firebase
                let licenseNumber = dictionary["licenseNumber"] as? String
                let licenseName = dictionary["licenseName"] as? String
                let licenseExpiration = dictionary["licenseExpiration"] as? String
                let licenseDOB = dictionary["licenseDOB"] as? String
                
                self.licenseNumberTextField.text = licenseNumber
                self.licenseNameTextField.text = licenseName
                self.licenseExpirationTextField.text = licenseExpiration
                self.licenseDOBTextField.text = licenseDOB
            }
            
        }, withCancel: nil)
    }
    
}
