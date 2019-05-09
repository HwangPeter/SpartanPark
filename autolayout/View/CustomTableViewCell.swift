//
//  CustomTableViewCell.swift
//  autolayout
//
//  Created by Hun Zaw on 5/8/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 6, width: self.frame.width - 20, height: 110))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5.0
        view.layer.shadowOpacity = 0.4
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 6.0
        return view
    }()
    
    let imageContainerView: UIView = {
        
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = nil
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var avatarImageView: UIImageView = {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //let avatar = UIImage(named: "avatar_icon")
        let avatar = UIImage(named: "noProfilePhoto3")
        let avatarView = UIImageView(image: avatar)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        //userInfoContainerView is constraint 90% to view width
        //imageContainerView is constraint 36% to userInfoContainerView
        //the image is constraint 90% to imageContainerView
        let myRadius = (110 * 0.9 * 0.9)/2
        avatarView.layer.cornerRadius = CGFloat(myRadius)
        avatarView.clipsToBounds = true
        avatarView.contentMode = .scaleAspectFit
        
        return avatarView
    }()
    
    let nameContainerView: UIView = {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.backgroundColor = nil
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        textField.text = "First Last"
        textField.borderStyle = UITextField.BorderStyle.none
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1)
        textField.textAlignment = .left
        textField.isUserInteractionEnabled = false
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let parkingTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        textField.text = "Garage / Park & Ride"
        textField.borderStyle = UITextField.BorderStyle.none
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1)
        textField.textAlignment = .left
        textField.isUserInteractionEnabled = false
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let dateTimeTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        textField.text = "Mercedes Benz, White"
        textField.borderStyle = UITextField.BorderStyle.none
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1)
        textField.textAlignment = .left
        textField.isUserInteractionEnabled = false
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let firstLineContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        return view
    }()
    
    let secondLineContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        
        backView.addSubview(imageContainerView)
        imageContainerView.addSubview(avatarImageView)
        imageContainerView.addSubview(nameContainerView)
        
        nameContainerView.addSubview(nameTextField)
        nameContainerView.addSubview(firstLineContainerView)
        nameContainerView.addSubview(parkingTextField)
        nameContainerView.addSubview(secondLineContainerView)
        nameContainerView.addSubview(dateTimeTextField)
        
        NSLayoutConstraint.activate([
            imageContainerView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            imageContainerView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            imageContainerView.heightAnchor.constraint(equalTo: backView.heightAnchor, multiplier: 0.9),
            imageContainerView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            avatarImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.9),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            nameContainerView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            nameContainerView.leadingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            nameContainerView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            nameContainerView.heightAnchor.constraint(equalTo: backView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameContainerView.topAnchor),
            nameTextField.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            nameTextField.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            nameTextField.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            firstLineContainerView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            firstLineContainerView.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            firstLineContainerView.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            firstLineContainerView.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.01)
            ])
        
        NSLayoutConstraint.activate([
            parkingTextField.topAnchor.constraint(equalTo: firstLineContainerView.bottomAnchor),
            parkingTextField.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            parkingTextField.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            parkingTextField.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
        
        NSLayoutConstraint.activate([
            secondLineContainerView.topAnchor.constraint(equalTo: parkingTextField.bottomAnchor),
            secondLineContainerView.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            secondLineContainerView.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            secondLineContainerView.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.01)
            ])
        
        NSLayoutConstraint.activate([
            dateTimeTextField.topAnchor.constraint(equalTo: secondLineContainerView.bottomAnchor),
            dateTimeTextField.widthAnchor.constraint(equalTo: nameContainerView.widthAnchor, multiplier: 0.9),
            dateTimeTextField.centerXAnchor.constraint(equalTo: nameContainerView.centerXAnchor),
            dateTimeTextField.heightAnchor.constraint(equalTo: nameContainerView.heightAnchor, multiplier: 0.3233333333)
            ])
    }

}
