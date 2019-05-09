//
//  SignUpViewController.swift
//  autolayout
//
//  Created by Hun Zaw on 3/19/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase

class userSignupVC: UIViewController {
    
    //static var myAccountType : String = ""
    
    struct myAccountType {
        static var isUser = "isUser"
        static var isValet = "isValet"
    }
    
    
    let topImageContainerView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let fillerContainerView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    lazy var avatarImageView: UIImageView = {
        
        //let avatar = UIImage(named: "avatar_icon")
        let avatar = UIImage(named: "noProfilePhoto")
        let avatarView = UIImageView(image: avatar)
        avatarView.translatesAutoresizingMaskIntoConstraints = false //enable autolayout for our image
        
        avatarView.layer.cornerRadius = 85
        avatarView.clipsToBounds = true
        avatarView.contentMode = .scaleAspectFit
        
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectAvatarImageView)))
        avatarView.isUserInteractionEnabled = true
        
        return avatarView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "Tap on the icon to select image!", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        
        attributedText.append(NSAttributedString(string: "\n\n\nFinish signing up by clicking the sign up button. You will be able to login as user or valet driver upon registration.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
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
        button.setTitle("SIGN UP", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        //button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        //handleRegister
        return button
    }()
    
    var profileUser = user()
    
    @objc private func handleNext() {
        print("next")
        //present(SignUpThreeViewController(), animated: true, completion: nil)
        print(profileUser.name)
        print(profileUser.email)
        print(profileUser.password)
        print("\n")
        print(profileUser.carModel)
        print(profileUser.carMake)
        print(profileUser.carYear)
        print(profileUser.carColor)
        print("\n")
        print(profileUser.cardNumber)
        print(profileUser.cardName)
        print(profileUser.cardExpiration)
        print(profileUser.cardCVV)
        print("\n")
        print(profileUser.licenseNumber)
        print(profileUser.licenseName)
        print(profileUser.licenseExpiration)
        print(profileUser.licenseDOB)
        
    }
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 4
        pc.numberOfPages = 4
        pc.currentPageIndicatorTintColor = .mainPink
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(red: 39/225.0, green: 74/225.0, blue: 110/225.0, alpha: 1)
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
    
    private func setupLayout(){
        
        //views added in the order of the layout top to bottom
        view.addSubview(topImageContainerView)
        view.addSubview(descriptionTextView)
        view.addSubview(fillerContainerView)
        topImageContainerView.addSubview(backButton)
        topImageContainerView.addSubview(avatarImageView)
        
        
        // ImageContainerViews are made with screen percentage
        // buttons, labels, and textView are constraint to ImageContainerView
        
        NSLayoutConstraint.activate([
            topImageContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
            ])
        
        
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: topImageContainerView.bottomAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 170),
            avatarImageView.widthAnchor.constraint(equalToConstant: 170)
            ])
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topImageContainerView.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: topImageContainerView.leadingAnchor),
            backButton.widthAnchor.constraint(equalTo: topImageContainerView.widthAnchor, multiplier: 0.2)
            ])
        
        NSLayoutConstraint.activate([
            fillerContainerView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor),
            fillerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fillerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fillerContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
            ])
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: fillerContainerView.bottomAnchor),
            descriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            descriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            descriptionTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ])
    }
    
    //Firebase, function to send verificaiton link to email
    func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            guard error == nil else {
                print("we got error with the email")
                return
            }
            
            print("we sent verification")
        })
    }
    

}
