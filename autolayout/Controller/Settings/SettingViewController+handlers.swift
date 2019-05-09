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

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    @objc func handleRegister(){
//
//        let cardNumber = fourthViewUser.cardNumber
//        let cardName = fourthViewUser.cardName
//        let cardExpiration = fourthViewUser.cardExpiration
//        let cardCVV = fourthViewUser.cardCVV
//
//        let carMake = fourthViewUser.carMake
//        let carModel = fourthViewUser.carModel
//        let carYear = fourthViewUser.carYear
//        let carColor = fourthViewUser.carColor
//
//        let licenseNumber = fourthViewUser.licenseNumber
//        let licenseName = fourthViewUser.licenseName
//        let licenseExpiration = fourthViewUser.licenseExpiration
//        let licenseDOB = fourthViewUser.licenseDOB
//
//        //firebase only need email and password to create user,
//        //so another method is inserted as changeRequest to handle username
//        Auth.auth().createUser(withEmail: email, password: password) {user, error in
//
//            if error == nil && user != nil{
//                print("User Created!")
//
//                //Firebase cocoapod authetication
//                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//                changeRequest?.displayName = username
//                changeRequest?.commitChanges { error in
//                    if error == nil {
//                        print("User display name changed")
//                        self.sendEmailVerification()
//                        let alertVC = UIAlertController(title: "Successful", message: "Verfication email sent to \(email)", preferredStyle: .alert)
//                        let alertActionOkay = UIAlertAction(title: "Okay", style: .default, handler: nil)
//
//                        alertVC.addAction(alertActionOkay)
//                        self.present(alertVC, animated: true, completion: nil)
//                        //self.dismiss(animated: false, completion: nil)
//                    }
//                }
//
//                //store username and email address in the child node "users" with user ID
//                guard let uid = Auth.auth().currentUser?.uid else{
//                    return
//                }
//
//                //store image in firebase "storage", create account and store
//                //data into database such as name, email, and profileurl after
//                //completion of successfully uploading image
//
//                let imageName = NSUUID().uuidString
//                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
//
//                if let uploadData = self.avatarImageView.image!.pngData(){
//                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//
//                        if error != nil{
//                            print(error!)
//                            return
//                        }
//
//                        storageRef.downloadURL(completion: { (url, error) in
//                            if error != nil {
//                                print("Failed to download url:", error!)
//                                return
//                            } else {
//
//                                let cardValues = ["cardNumber": cardNumber,
//                                                  "cardName": cardName,
//                                                  "cardExpiration": cardExpiration,
//                                                  "cardCVV": cardCVV]
//
//                                let carValues = ["carMake": carMake,
//                                                 "carModel": carModel,
//                                                 "carYear": carYear,
//                                                 "carColor": carColor]
//
//                                let licenseValues = ["licenseNumber": licenseNumber,
//                                                     "licenseName": licenseName,
//                                                     "licenseExpiration": licenseExpiration,
//                                                     "licenseDOB": licenseDOB]
//                                //print(url?.absoluteString as Any)
//
//                                self.registerCreditCardIntoDatabaseWithUID(uid: uid, values: cardValues as [String : AnyObject])
//                                self.registerCarIntoDatabaseWithUID(uid: uid, values: carValues as [String : AnyObject])
//                                self.registerLicenseIntoDatabaseWithUID(uid: uid, values: licenseValues as [String : AnyObject])
//
//                            }
//                        })
//                    })
//                }
//
//            }else{
//
//                let errorAlertVC = UIAlertController(title: "Signup Failed", message: "Error: \(String(describing: error!.localizedDescription))", preferredStyle: .alert)
//
//                let errorAlertActionOkay = UIAlertAction(title: "Okay", style: .default, handler: nil)
//
//                errorAlertVC.addAction(errorAlertActionOkay)
//                self.present(errorAlertVC, animated: true, completion: nil)
//                print("Error creating user: \(error!.localizedDescription)")
//            }
//        }
//    }
    
        @objc func handleLogin() {
            
            let SSN = fifthViewUser.SSN
    
            let username = fifthViewUser.name
            let password = fifthViewUser.password
            let email = fifthViewUser.email
            
            let cardNumber = fifthViewUser.cardNumber
            let cardName = fifthViewUser.cardName
            let cardExpiration = fifthViewUser.cardExpiration
            let cardCVV = fifthViewUser.cardCVV
            
            let carMake = fifthViewUser.carMake
            let carModel = fifthViewUser.carModel
            let carYear = fifthViewUser.carYear
            let carColor = fifthViewUser.carColor
            
            let licenseNumber = fifthViewUser.licenseNumber
            let licenseName = fifthViewUser.licenseName
            let licenseExpiration = fifthViewUser.licenseExpiration
            let licenseDOB = fifthViewUser.licenseDOB
    
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
    
                            let imageName = NSUUID().uuidString
                            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
                            
                            if let uploadData = self.profileImageView.image!.pngData(){
                                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                    
                                    if error != nil{
                                        print(error!)
                                        return
                                    }
                                    
                                    storageRef.downloadURL(completion: { (url, error) in
                                        if error != nil {
                                            print("Failed to download url:", error!)
                                            return
                                        } else {
                                            
                                            let values = ["name": username, "profileImageUrl": url?.absoluteString as Any]
                                            let cardValues = ["cardNumber": cardNumber,
                                                              "cardName": cardName,
                                                              "cardExpiration": cardExpiration,
                                                              "cardCVV": cardCVV]
                                            
                                            let carValues = ["carMake": carMake,
                                                             "carModel": carModel,
                                                             "carYear": carYear,
                                                             "carColor": carColor]
                                            
                                            let licenseValues = ["licenseNumber": licenseNumber,
                                                                 "licenseName": licenseName,
                                                                 "licenseExpiration": licenseExpiration,
                                                                 "licenseDOB": licenseDOB]
                                            
                                            let SSNValues = ["SSN": SSN]
                                            
                                            guard let uid = Auth.auth().currentUser?.uid else{
                                                return
                                            }
                                            
                                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                                            self.registerCreditCardIntoDatabaseWithUID(uid: uid, values: cardValues as [String : AnyObject])
                                            self.registerCarIntoDatabaseWithUID(uid: uid, values: carValues as [String : AnyObject])
                                            self.registerLicenseIntoDatabaseWithUID(uid: uid, values: licenseValues as [String : AnyObject])
                                            
                                            self.registerSSNIntoDatabaseWithUID(uid: uid, values: SSNValues as [String : AnyObject])
                                            
                                            
                                            print ("Email verified. Saving...")
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                // Code you want to be delayed
                                                //self.dismiss(animated: true, completion: nil)
                                                let saveAlertVC = UIAlertController(title: "Updated Successfully", message: "Your profolio has been updated", preferredStyle: .alert)
                                                
                                                let saveAlertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                                                saveAlertVC.addAction(saveAlertActionCancel)
                                                self.present(saveAlertVC, animated: true, completion: nil)
                                            }
                                            
                                        }
                                    })
                                })
                            }
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
    
    private func registerCreditCardIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        //Firebase Database, store name and email in firebase database
        var databaseRef = DatabaseReference()
        databaseRef = Database.database().reference(fromURL: "https://autolayout-bb566.firebaseio.com/")
        
        let userReference = databaseRef.child("users").child(uid).child("CreditCard")
        
        userReference.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Saved user successfully into firebase database")
        })
    }
    
    private func registerCarIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        //Firebase Database, store name and email in firebase database
        var databaseRef = DatabaseReference()
        databaseRef = Database.database().reference(fromURL: "https://autolayout-bb566.firebaseio.com/")
        
        let userReference = databaseRef.child("users").child(uid).child("Car")
        
        userReference.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Saved user successfully into firebase database")
        })
    }
    
    private func registerLicenseIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        //Firebase Database, store name and email in firebase database
        var databaseRef = DatabaseReference()
        databaseRef = Database.database().reference(fromURL: "https://autolayout-bb566.firebaseio.com/")
        
        let userReference = databaseRef.child("users").child(uid).child("License")
        
        userReference.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Saved user successfully into firebase database")
        })
    }
    
    private func registerSSNIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        //Firebase Database, store name and email in firebase database
        var databaseRef = DatabaseReference()
        databaseRef = Database.database().reference(fromURL: "https://autolayout-bb566.firebaseio.com/")
        
        let userReference = databaseRef.child("users").child(uid).child("SSN")
        
        userReference.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Saved user successfully into firebase database")
        })
    }
    
    func fetchProfilePhoto () {
        
        let storage = Storage.storage()
        var reference: StorageReference!
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //user model has name, email, and profileImageUrl, etc stored in database
            //fetch anything stored in the database in this if statement
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                //grab the image url from firebase
                let profileUrl = dictionary["profileImageUrl"] as? String
                reference = storage.reference(forURL: profileUrl!)
                
                reference.downloadURL { (url, error) in
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    self.profileImageView.image = image
                }
            }
            
        }, withCancel: nil)
    }
    
    @objc func handleSelectAvatarImageView () {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage { selectedImageFromPicker = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled picker")
        dismiss(animated: true, completion: nil)
    }
}
