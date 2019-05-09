//
//  SignUpViewController.swift
//  autolayout
//
//  Created by Hun Zaw on 3/19/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase

class SettingOneViewController: UIViewController {
    
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
        let spartan = UIImage(named: "car")
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
    
    let carMakeBottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let carModelBottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let carYearBottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //let emailBottomLine = containerView()
    
    let carMakeTextField = textFieldContainer(mytext: "Car Make")
    let carModelTextField = textFieldContainer(mytext: "Car Model")
    let carYearTextField = textFieldContainer(mytext: "Car Year")
    let carColorTextField = textFieldContainer(mytext: "Car Color")
    
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
    
    var firstViewUser = userSetting()
    
    @objc private func handleNext() {
        //print("next")
        
        //        print(secondViewUser.name)
        //        print(secondViewUser.email)
        //        print(secondViewUser.password)
        
        let vcPass = SettingTwoViewController()
        
        vcPass.secondViewUser.SSN = firstViewUser.SSN
        
        vcPass.secondViewUser.carMake = carMakeTextField.text!
        vcPass.secondViewUser.carModel = carModelTextField.text!
        vcPass.secondViewUser.carYear = carYearTextField.text!
        vcPass.secondViewUser.carColor = carColorTextField.text!
        
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
        fetchCarInfo()
        self.hideKeyboardWhenTappedAround() 
    }
    
    fileprivate func setupBottomControls() {
        pageControl.currentPage = 1
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
        inputContainerView.addSubview(carMakeTextField)
        inputContainerView.addSubview(carModelTextField)
        inputContainerView.addSubview(carYearTextField)
        inputContainerView.addSubview(carColorTextField)
        inputContainerView.addSubview(carMakeBottomLine)
        inputContainerView.addSubview(carModelBottomLine)
        inputContainerView.addSubview(carYearBottomLine)
        
        inputContainerView.layer.cornerRadius = 5
        inputContainerView.layer.masksToBounds = true
        
        //initial placeholder text centered
        carMakeTextField.textAlignment = .left
        carModelTextField.textAlignment = .left
        carYearTextField.textAlignment = .left
        carColorTextField.textAlignment = .left
        
        
        NSLayoutConstraint.activate([ // need X, Y, width, height
            inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ])
        
        NSLayoutConstraint.activate([
            carMakeTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
            carMakeTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            carMakeTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9),
            carMakeTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            carMakeBottomLine.topAnchor.constraint(equalTo: carMakeTextField.bottomAnchor),
            carMakeBottomLine.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            carMakeBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.01),
            carMakeBottomLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            carModelTextField.topAnchor.constraint(equalTo: carMakeBottomLine.topAnchor),
            carModelTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            carModelTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9),
            carModelTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            carModelBottomLine.topAnchor.constraint(equalTo: carModelTextField.bottomAnchor),
            carModelBottomLine.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            carModelBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.01),
            carModelBottomLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            carYearTextField.topAnchor.constraint(equalTo: carModelBottomLine.bottomAnchor),
            carYearTextField.leadingAnchor.constraint(equalTo: carModelBottomLine.leadingAnchor),
            carYearTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.45),
            carYearTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            carColorTextField.topAnchor.constraint(equalTo: carModelBottomLine.bottomAnchor),
            carColorTextField.leadingAnchor.constraint(equalTo: carYearTextField.trailingAnchor),
            carColorTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.45),
            carColorTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            carYearBottomLine.topAnchor.constraint(equalTo: carColorTextField.bottomAnchor),
            carYearBottomLine.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            carYearBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.009),
            carYearBottomLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9)
            ])
        
    }
    
    private func fetchCarInfo () {

        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).child("Car").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //user model has name, email, and profileImageUrl, etc stored in database
            //fetch anything stored in the database in this if statement
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                //grab the image url from firebase
                let carMake = dictionary["carMake"] as? String
                let carModel = dictionary["carModel"] as? String
                let carYear = dictionary["carYear"] as? String
                let carColor = dictionary["carColor"] as? String
                
                self.carMakeTextField.text = carMake
                self.carModelTextField.text = carModel
                self.carYearTextField.text = carYear
                self.carColorTextField.text = carColor
            }
            
        }, withCancel: nil)
    }
    
}
