//
//  SignUpViewController.swift
//  autolayout
//
//  Created by Hun Zaw on 3/19/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let backbuttonContainerView = containerView()
    let segmentContainerView = containerView()
    let inputContainerView = containerView()
    
    let emailBottomLine = containerView()
    
    //let backButton = buttonContainerEmpty(mytext: "back", myColor: UIColor.white)
    let passwordTextField = textFieldSecureContainer(mytext: "Password")
    let emailTextField = textFieldContainer(mytext: "Email address")
    let LoginAsUserOrValet = buttonContainer(mytext: "Login as User")
    let forgotPasswordButton = buttonContainerEmpty(mytext: "forgot password?", myColor: UIColor(red: 55/225.0, green: 111/225.0, blue: 159/225.0, alpha: 1))
    
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
    
    let nameTextView: UITextView = {
        
        let myText = UITextView(frame: CGRect.zero, textContainer: nil)
        myText.text = "Spartan Park"
        myText.backgroundColor = nil
        myText.textColor = UIColor.white
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 39/225.0, green: 74/225.0, blue: 110/225.0, alpha: 1)
        setupLayout()
        self.hideKeyboardWhenTappedAround() 
    }
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var usernameHeightAnchor: NSLayoutConstraint?
    var emailHeightAnchor: NSLayoutConstraint?
    var passwordHeightAnchor: NSLayoutConstraint?
    
    private func setupLayout(){
        
        //views added in the order of the layout top to bottom
        view.addSubview(backbuttonContainerView)
        view.addSubview(segmentContainerView)
        view.addSubview(inputContainerView)
        view.addSubview(nameTextView)
        
        backbuttonContainerView.addSubview(backButton)
        segmentContainerView.addSubview(segmentControl)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailBottomLine)
        inputContainerView.addSubview(passwordTextField)
        view.addSubview(LoginAsUserOrValet)
        view.addSubview(forgotPasswordButton)
        
        //initial backgroundColor set to Null, corners intially not enabled
        inputContainerView.backgroundColor = UIColor.white
        inputContainerView.layer.cornerRadius = 5
        inputContainerView.layer.masksToBounds = true
        
        emailBottomLine.backgroundColor = UIColor(red: 39/225.0, green: 74/225.0, blue: 110/225.0, alpha: 1)
        
        //initial placeholder text centered
        emailTextField.textAlignment = .left
        passwordTextField.textAlignment = .left
        
        //initial UIButton class buttonContainer is set to 39/74/110
        LoginAsUserOrValet.backgroundColor = UIColor(red: 55/225.0, green: 111/225.0, blue: 159/225.0, alpha: 1)
        
        
        
        // ImageContainerViews are made with screen percentage
        // buttons, labels, and textView are constraint to ImageContainerView
        
        NSLayoutConstraint.activate([
            backbuttonContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backbuttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backbuttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backbuttonContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
            ])
        
        NSLayoutConstraint.activate([ // need X, Y, width, height
            segmentContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentContainerView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -10),
            segmentContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.94),
            segmentContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
            ])
        
        NSLayoutConstraint.activate([ // need X, Y, width, height
            inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.94),
            inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1333)
            ])
        
        NSLayoutConstraint.activate([
            nameTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextView.bottomAnchor.constraint(equalTo: segmentContainerView.topAnchor),
            nameTextView.widthAnchor.constraint(equalTo: view.widthAnchor),
            nameTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ])
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: backbuttonContainerView.topAnchor),
            backButton.leftAnchor.constraint(equalTo: backbuttonContainerView.leftAnchor),
            backButton.widthAnchor.constraint(equalTo: backbuttonContainerView.widthAnchor, multiplier: 0.15),
            backButton.heightAnchor.constraint(equalTo: backbuttonContainerView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            segmentControl.centerXAnchor.constraint(equalTo: segmentContainerView.centerXAnchor),
            segmentControl.centerYAnchor.constraint(equalTo: segmentContainerView.centerYAnchor),
            segmentControl.widthAnchor.constraint(equalTo: segmentContainerView.widthAnchor),
            segmentControl.heightAnchor.constraint(equalTo: segmentContainerView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
            emailTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9),
            emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.495)
            ])
        
        NSLayoutConstraint.activate([
            emailBottomLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailBottomLine.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            emailBottomLine.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            emailBottomLine.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.01)
            ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailBottomLine.bottomAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 0.9),
            passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.495)
            ])
        
        NSLayoutConstraint.activate([
            LoginAsUserOrValet.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 10),
            LoginAsUserOrValet.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            LoginAsUserOrValet.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.94),
            LoginAsUserOrValet.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
            ])
        
        NSLayoutConstraint.activate([
            forgotPasswordButton.topAnchor.constraint(equalTo: LoginAsUserOrValet.bottomAnchor, constant: 10),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.94),
            forgotPasswordButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
            ])
        
        
        //backButton.addTarget(self, action: #selector(self.backButtonClicked(sender:)), for: .touchUpInside)
        LoginAsUserOrValet.addTarget(self, action: #selector(self.handleLogins(sender:)), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordClicked), for: .touchUpInside)
        
        // iphone 5s,SE screen width 320
        // iphone 6,6s,7,etc width 375
        // iphone 7 plus, 8 plus, xs max,etc width 414
        if (view.frame.width == 320) {
            
            let font_320 = UIFont.systemFont(ofSize: 16)
            backButton.titleLabel?.font = font_320
            segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font_320],
                                                  for: .normal)
            emailTextField.font = font_320
            passwordTextField.font = font_320
            LoginAsUserOrValet.titleLabel?.font = font_320
            forgotPasswordButton.titleLabel?.font = font_320
            nameTextView.font = UIFont(name: "AvenirNext-heavy", size: 40)
            
        } else if (view.frame.width == 375) {
            
            let font_375 = UIFont.systemFont(ofSize: 18)
            backButton.titleLabel?.font = font_375
            segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font_375],
                                                  for: .normal)
            emailTextField.font = font_375
            passwordTextField.font = font_375
            LoginAsUserOrValet.titleLabel?.font = font_375
            forgotPasswordButton.titleLabel?.font = font_375
            nameTextView.font = UIFont(name: "AvenirNext-heavy", size: 45)
            
        } else if (view.frame.width == 414) {
            
            let font_414 = UIFont.systemFont(ofSize: 20)
            backButton.titleLabel?.font = font_414
            segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font_414],
                                                  for: .normal)
            emailTextField.font = font_414
            passwordTextField.font = font_414
            LoginAsUserOrValet.titleLabel?.font = font_414
            forgotPasswordButton.titleLabel?.font = font_414
            nameTextView.font = UIFont(name: "AvenirNext-heavy", size: 50)
        }
    }
    
    lazy var segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login as Valet", "Login as User"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleSegmentControlChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleSegmentControlChange(){
        let title = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
        LoginAsUserOrValet.setTitle(title, for: .normal)
    }
    
    @objc func backButtonClicked(){
        print("Back Button Clicked")
        present(ViewController(), animated: true, completion: nil)
    }
    
    @objc func handleLogins(sender: UIButton) {
        if segmentControl.selectedSegmentIndex == 0 {
            handleValetLogin()
        } else {
            handleUserLogin()
        }
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
