//
//  ViewController.swift
//  autolayout
//
//  Created by Hun Zaw on 3/18/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    let nameContainerView = containerView()
    let imageContainerView = containerView()
    
    let buttonContainerView: UIView = {
        let view = UIView(frame: CGRect.zero)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameTextView: UITextView = {
        
        let myText = UITextView(frame: CGRect.zero, textContainer: nil)
        myText.text = "Spartan Park"
        myText.backgroundColor = nil
        myText.textColor = UIColor(red: 0/225.0, green: 85/225.0, blue: 162/225.0, alpha: 1)
        //myText.textColor = UIColor(red: 229/255.0, green: 168/255.0, blue: 35/255.0, alpha: 1)
        myText.textAlignment = .center
        myText.isEditable = false
        myText.isScrollEnabled = false
        
        myText.layer.shadowOpacity = 0.4
        myText.layer.shadowColor = UIColor.darkGray.cgColor
        myText.layer.shadowOffset = CGSize(width: 0, height: 5)
        myText.layer.shadowRadius = 6.0
        
        myText.translatesAutoresizingMaskIntoConstraints = false
        return myText
        
    }()
    
    let spartanImageView: UIImageView = {
        
        let spartan = UIImage(named: "spartan_spirit")
        let spartanView = UIImageView(image: spartan)
        spartanView.translatesAutoresizingMaskIntoConstraints = false //enable autolayout for our image
        spartanView.contentMode = .scaleAspectFit
        return spartanView
    }()
    
    let loginButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        //button.backgroundColor = UIColor(red: 39/225.0, green: 74/225.0, blue: 110/225.0, alpha: 1)
        button.backgroundColor = nil
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let userSignupButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        //button.backgroundColor = UIColor(red: 39/225.0, green: 74/225.0, blue: 110/225.0, alpha: 1)
        button.backgroundColor = nil
        button.setTitle("user signup", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(userSignupButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let valetSignupButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        //button.backgroundColor = UIColor(red: 39/225.0, green: 74/225.0, blue: 110/225.0, alpha: 1)
        button.backgroundColor = nil
        button.setTitle("valet signup", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(valetSignupButtonClicked), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //backgroundGradient()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "sjsu2")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        self.hideKeyboardWhenTappedAround() 
        
        setupLayout()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn() {
        
        //will only log back in on startup if the email address is verified
        if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified  {
    
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                //user model has name, email, and profileImageUrl, etc stored in database
                //fetch anything stored in the database in this if statement
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    //grab the stats from firebase
                    let status = dictionary["status"] as? String
                    //let valetStatus = dictionary["valetStatus"] as? String
                    if (status == "isUser"){
                        self.present(UserMapVC(), animated: true, completion: nil)
                        print("Printing User")
                    }
                    else if (status == "isValet"){
                        self.present(ValetViewController(), animated: true, completion: nil)
                        print("Presenting Valet Home Screen")
                    }
                    
                }
                
            }, withCancel: nil)
            
        }else{
            handleLogout()
        }
    }
    
    func handleLogout() {
        
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    private func setupLayout() {
        
        view.addSubview(nameContainerView)
        nameContainerView.addSubview(nameTextView)
        
        view.addSubview(imageContainerView)
        imageContainerView.addSubview(spartanImageView)
        
        view.addSubview(buttonContainerView)
        buttonContainerView.addSubview(userSignupButton)
        buttonContainerView.addSubview(valetSignupButton)
        buttonContainerView.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            nameContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            nameContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ])
        
        NSLayoutConstraint.activate([
            nameTextView.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            nameTextView.bottomAnchor.constraint(equalTo: nameContainerView.bottomAnchor),
            nameTextView.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor),
            nameTextView.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.5)
            ])
        
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: nameContainerView.bottomAnchor),
            imageContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
            ])
        
        NSLayoutConstraint.activate([
            spartanImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            spartanImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            spartanImageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 0.8),
            spartanImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            buttonContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            buttonContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
            ])
        
        NSLayoutConstraint.activate([
            userSignupButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            userSignupButton.widthAnchor.constraint(equalTo: buttonContainerView.widthAnchor, multiplier: 0.3333),
            userSignupButton.heightAnchor.constraint(equalTo: buttonContainerView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            valetSignupButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            valetSignupButton.widthAnchor.constraint(equalTo: buttonContainerView.widthAnchor, multiplier: 0.3333),
            valetSignupButton.heightAnchor.constraint(equalTo: buttonContainerView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: valetSignupButton.trailingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: userSignupButton.leadingAnchor),
            loginButton.heightAnchor.constraint(equalTo: buttonContainerView.heightAnchor)
            ])

        
        
        // iphone 5s,SE screen width 320
        // iphone 6,6s,7,etc width 375
        // iphone 7 plus, 8 plus, xs max,etc width 414
        if (view.frame.width == 320) {
            
            let font_320 = UIFont.systemFont(ofSize: 15)
            nameTextView.font = UIFont(name: "AvenirNext-heavy", size: 40)
            loginButton.titleLabel?.font = font_320
            userSignupButton.titleLabel?.font = font_320
            valetSignupButton.titleLabel?.font = font_320
            
        } else if (view.frame.width == 375) {
            
            let font_375 = UIFont.systemFont(ofSize: 18)
            nameTextView.font = UIFont(name: "AvenirNext-heavy", size: 45)
            loginButton.titleLabel?.font = font_375
            userSignupButton.titleLabel?.font = font_375
            valetSignupButton.titleLabel?.font = font_375
            
        } else if (view.frame.width == 414) {
            
            let font_414 = UIFont.systemFont(ofSize: 20)
            nameTextView.font = UIFont(name: "AvenirNext-heavy", size: 50)
            loginButton.titleLabel?.font = font_414
            userSignupButton.titleLabel?.font = font_414
            valetSignupButton.titleLabel?.font = font_414
        }
    }
    
    @objc func userSignupButtonClicked(){
        print("Sign up Button Clicked")
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let swipingController = SwipingController(collectionViewLayout: layout)
//        present(swipingController, animated: true, completion: nil)
        present(userCarSignUpVC(), animated: true, completion: nil)
    }
    
    @objc func valetSignupButtonClicked(){
        print("Sign up Button Clicked")
        //        let layout = UICollectionViewFlowLayout()
        //        layout.scrollDirection = .horizontal
        //        let swipingController = SwipingController(collectionViewLayout: layout)
        //        present(swipingController, animated: true, completion: nil)
        present(valetSSSignUpVC(), animated: true, completion: nil)
    }
    
    @objc func loginButtonClicked(){
        print("Login Button Clicked")
        present(LoginViewController(), animated: true, completion: nil)
        //present(ValetRequestedViewController(), animated: true, completion: nil)
        //present(ValetDirectionToSCEViewController(), animated: true, completion: nil)
        //present(ValetDirectionToGarageViewController(), animated: false, completion: nil)
    }
    
    private func backgroundGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        //gradient.colors = [UIColor(red: 255/225.0, green: 253/225.0, blue: 228/225.0, alpha: 1).cgColor, UIColor(red: 0/225.0, green: 90/225.0, blue: 167/225.0, alpha: 1).cgColor]
        gradient.colors = [UIColor(red: 191/225.0, green: 239/225.0, blue: 255/225.0, alpha: 1).cgColor, UIColor(red: 0/225.0, green: 90/225.0, blue: 167/225.0, alpha: 1).cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc func forgotPasswordClicked() {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
            textField.font = UIFont.systemFont(ofSize: 20)
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error!.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        //PRESENT ALERT
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
