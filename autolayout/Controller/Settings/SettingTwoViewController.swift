//
//  SignUpViewController.swift
//  autolayout
//
//  Created by Hun Zaw on 3/19/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase

class SettingTwoViewController: UIViewController {
    
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
        let spartan = UIImage(named: "creditcard")
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
    
    let cardNumberBottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardNameBottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardExpirationBottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //let emailBottomLine = containerView()
    
    let cardNumberTextField = textFieldContainer(mytext: "1234 5678 1444 1345")
    let cardNameTextField = textFieldContainer(mytext: "First M Last")
    let cardExpirationTextField = textFieldContainer(mytext: "MM/YY")
    let cardCVVTextField = textFieldContainer(mytext: "CVV")
    
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
    
    var secondViewUser = userSetting()
    
    @objc private func handleNext() {
        
        let vcPass = SettingThreeViewController()
        
        vcPass.thirdViewUser.SSN = secondViewUser.SSN
        
        vcPass.thirdViewUser.carModel = secondViewUser.carModel
        vcPass.thirdViewUser.carMake = secondViewUser.carMake
        vcPass.thirdViewUser.carYear = secondViewUser.carYear
        vcPass.thirdViewUser.carColor = secondViewUser.carColor
        
        vcPass.thirdViewUser.cardNumber = cardNumberTextField.text!
        vcPass.thirdViewUser.cardName = cardNameTextField.text!
        vcPass.thirdViewUser.cardExpiration = cardExpirationTextField.text!
        vcPass.thirdViewUser.cardCVV = cardCVVTextField.text!
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
        fetchCreditCardInfo()
        self.hideKeyboardWhenTappedAround() 
    }
    
    fileprivate func setupBottomControls() {
        pageControl.currentPage = 2
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
        inputContainerView.addSubview(cardNumberTextField)
        inputContainerView.addSubview(cardNameTextField)
        inputContainerView.addSubview(cardExpirationTextField)
        inputContainerView.addSubview(cardCVVTextField)
        inputContainerView.addSubview(cardNumberBottomLine)
        inputContainerView.addSubview(cardNameBottomLine)
        inputContainerView.addSubview(cardExpirationBottomLine)
        
        inputContainerView.layer.cornerRadius = 5
        inputContainerView.layer.masksToBounds = true
        
        //initial placeholder text centered
        cardNumberTextField.textAlignment = .left
        cardNameTextField.textAlignment = .left
        cardExpirationTextField.textAlignment = .left
        cardCVVTextField.textAlignment = .left
        
        
        NSLayoutConstraint.activate([ // need X, Y, width, height
            inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ])
        
        NSLayoutConstraint.activate([
            cardNumberTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
            cardNumberTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            cardNumberTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9),
            cardNumberTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            cardNumberBottomLine.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor),
            cardNumberBottomLine.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            cardNumberBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.01),
            cardNumberBottomLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            cardNameTextField.topAnchor.constraint(equalTo: cardNumberBottomLine.topAnchor),
            cardNameTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            cardNameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9),
            cardNameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            cardNameBottomLine.topAnchor.constraint(equalTo: cardNameTextField.bottomAnchor),
            cardNameBottomLine.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            cardNameBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.01),
            cardNameBottomLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            cardExpirationTextField.topAnchor.constraint(equalTo: cardNameBottomLine.bottomAnchor),
            cardExpirationTextField.leadingAnchor.constraint(equalTo: cardNameBottomLine.leadingAnchor),
            cardExpirationTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.6),
            cardExpirationTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            cardCVVTextField.topAnchor.constraint(equalTo: cardNameBottomLine.bottomAnchor),
            cardCVVTextField.leadingAnchor.constraint(equalTo: cardExpirationTextField.trailingAnchor),
            cardCVVTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.3),
            cardCVVTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            cardExpirationBottomLine.topAnchor.constraint(equalTo: cardExpirationTextField.bottomAnchor),
            cardExpirationBottomLine.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            cardExpirationBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.009),
            cardExpirationBottomLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9)
            ])
        
    }
    
    private func fetchCreditCardInfo () {
        
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).child("CreditCard").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //user model has name, email, and profileImageUrl, etc stored in database
            //fetch anything stored in the database in this if statement
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                //grab the image url from firebase
                let cardNumber = dictionary["cardNumber"] as? String
                let cardName = dictionary["cardName"] as? String
                let cardExpiration = dictionary["cardExpiration"] as? String
                let cardCVV = dictionary["cardCVV"] as? String
                
                self.cardNumberTextField.text = cardNumber
                self.cardNameTextField.text = cardName
                self.cardExpirationTextField.text = cardExpiration
                self.cardCVVTextField.text = cardCVV
            }
            
        }, withCancel: nil)
    }
    
}
