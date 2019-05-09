//
//  HamburgerMenuViewController.swift
//  SpartanPark
//
//  Created by Peter Hwang on 10/29/18.
//  Copyright © 2018 Peter Hwang. All rights reserved.
//

import UIKit
import Firebase

class MenuOption: NSObject {
    var name: String
    var imageName: String
    
    init(name: String, imageName: String){
        self.name = name
        self.imageName = imageName
    }
}

class HamburgerMenu: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var currentVC:UserMapVC?
    var currentValetVC:ValetViewController?
    
    let blackView = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let menuView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        menuView.backgroundColor = UIColor.white
        return menuView
    }()
    
    //EDIT HAMBURGER MENU OPTIONS FROM HERE.
    //TODO: Finish adding all menu options.
    var menuOptions: [MenuOption] = {
        
        return [
            MenuOption(name: "Settings", imageName: "Gear.png"),
            MenuOption(name: "Logout", imageName: "Gear.png"),
            MenuOption(name: "Ride History", imageName: "Gear.png"),
            MenuOption(name: "Option 4", imageName: "Gear.png")]
    }()
    
    func showMenu() {
        
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            
            window.addSubview(collectionView)
            let width = window.frame.width - 100
            collectionView.frame = CGRect(x: -window.frame.width, y: 0, width: width, height: window.frame.height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
            
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.collectionView.frame = CGRect(x: -self.collectionView.frame.width, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    let cellId = "cellId"
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! HamburgerCell
        let menuOption = menuOptions[indexPath.item]
        cell.option = menuOption
        return cell
    }
    
    let cellHeight: CGFloat = 50
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = menuOptions[indexPath.item]
        //print(option.name)
        if(option.name == "Settings"){
            print("Setting clicked")
            handleDismiss()
            self.currentVC?.handleSetting()
            self.currentValetVC?.handleSetting()
        }
        if(option.name == "Logout"){
            logout()
            logoutValet()
        }
        else if(option.name == "Ride History") {
            handleDismiss()
            self.currentVC?.handleRideHistory()
            self.currentValetVC?.handleRideHistory()
        }
        else if(option.name == "Option 4") {
            print("Option 4 clicked")
            //put the function in here
        }
    }
    
    func logout() {
        handleDismiss()
        self.currentVC?.handleLogout()
    }
    
    func logoutValet() {
        handleDismiss()
        self.currentValetVC?.handleLogout()
    }
    
    
    override init(){
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HamburgerCell.self, forCellWithReuseIdentifier: cellId)
    }
}
