//
//  SignUpViewController+handlers.swift
//  autolayout
//
//  Created by Hun Zaw on 4/10/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension LoginViewController: UINavigationControllerDelegate {
    
    @objc func handleUserLogin() {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password){user, error in
            // check if there was an error logging in, if there is no error, check if the email is authentic
            if error == nil && user != nil {
                
                if let user = Auth.auth().currentUser {
                    
                    if !user.isEmailVerified{
                        
                        let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(email).", preferredStyle: .alert)
                        
                        let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                            (_) in
                            user.sendEmailVerification(completion: nil)
                        }
                        
                        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                        
                        alertVC.addAction(alertActionOkay)
                        alertVC.addAction(alertActionCancel)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                        
                    else {
                        
                        let values = ["status": "isUser"]
                        
                        guard let uid = Auth.auth().currentUser?.uid else{
                            return
                        }
                        
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        
                        print ("Email verified. Signing in...")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            // Code you want to be delayed
                            self.dismiss(animated: true, completion: nil)
                        }
                        //self.dismiss(animated: true, completion: nil)
                    }
                }
            }else {
                
                let errorAlertVC = UIAlertController(title: "Login Failed", message: "Error: \(String(describing: error!.localizedDescription))", preferredStyle: .alert)
                
                let errorAlertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                errorAlertVC.addAction(errorAlertActionCancel)
                self.present(errorAlertVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleValetLogin() {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password){user, error in
            // check if there was an error logging in, if there is no error, check if the email is authentic
            if error == nil && user != nil {
                
                if let user = Auth.auth().currentUser {
                    
                    if !user.isEmailVerified{
                        
                        let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(email).", preferredStyle: .alert)
                        
                        let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                            (_) in
                            user.sendEmailVerification(completion: nil)
                        }
                        
                        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                        
                        alertVC.addAction(alertActionOkay)
                        alertVC.addAction(alertActionCancel)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                        
                    else {
                        
                        let values = ["status": "isValet"]
                        
                        guard let uid = Auth.auth().currentUser?.uid else{
                            return
                        }
                        
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        
                        print ("Email verified. Signing in...")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            // Code you want to be delayed
                            self.dismiss(animated: true, completion: nil)
                        }
                        //self.dismiss(animated: true, completion: nil)
                    }
                }
            }else {
                
                let errorAlertVC = UIAlertController(title: "Login Failed", message: "Error: \(String(describing: error!.localizedDescription))", preferredStyle: .alert)
                
                let errorAlertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                errorAlertVC.addAction(errorAlertActionCancel)
                self.present(errorAlertVC, animated: true, completion: nil)
            }
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        //Firebase Database, store name and email in firebase database
        var databaseRef = DatabaseReference()
        databaseRef = Database.database().reference(fromURL: "https://autolayout-bb566.firebaseio.com/")
        
        let userReference = databaseRef.child("users").child(uid)
        
        userReference.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Saved user successfully into firebase database")
        })
    }
    
    private func registerValetIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        //Firebase Database, store name and email in firebase database
        var databaseRef = DatabaseReference()
        databaseRef = Database.database().reference(fromURL: "https://autolayout-bb566.firebaseio.com/")
        
        let valetReference = databaseRef.child("valets").child(uid)
        
        valetReference.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Saved driver successfully into firebase database")
        })
    }

}
