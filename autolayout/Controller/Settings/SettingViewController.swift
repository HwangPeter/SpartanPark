//
//  SignUpViewController.swift
//  autolayout
//
//  Created by Hun Zaw on 3/19/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    
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
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    lazy var profileImageView: UIImageView = {
        
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
        
        attributedText.append(NSAttributedString(string: "\n\n\nFinish saving by clicking the save button. You will see the changes for both user or valet driver.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
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
        button.setTitle("SAVE", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        //handleRegister
        return button
    }()
    
    var fifthViewUser = userSetting()
    
    @objc private func handleNext() {
        print("next")
        
        print(fifthViewUser.name)
        print(fifthViewUser.email)
        print(fifthViewUser.password)
        print("\n")
    
        print(fifthViewUser.carModel)
        print(fifthViewUser.carMake)
        print(fifthViewUser.carYear)
        print(fifthViewUser.carColor)
        print("\n")
        print(fifthViewUser.cardNumber)
        print(fifthViewUser.cardName)
        print(fifthViewUser.cardExpiration)
        print(fifthViewUser.cardCVV)
        print("\n")
        print(fifthViewUser.licenseNumber)
        print(fifthViewUser.licenseName)
        print(fifthViewUser.licenseExpiration)
        print(fifthViewUser.licenseDOB)
        
    }
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 4
        pc.numberOfPages = 6
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
        fetchProfilePhoto()
        self.hideKeyboardWhenTappedAround() 
    }
    
    fileprivate func setupBottomControls() {
        pageControl.currentPage = 5
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
        topImageContainerView.addSubview(profileImageView)
        
        
        // ImageContainerViews are made with screen percentage
        // buttons, labels, and textView are constraint to ImageContainerView
        
        NSLayoutConstraint.activate([
            topImageContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
            ])
        
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: topImageContainerView.bottomAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 170),
            profileImageView.widthAnchor.constraint(equalToConstant: 170)
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
