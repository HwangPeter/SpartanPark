//
//  CustomRideHistoryTableViewCell.swift
//  autolayout
//
//  Created by Hun Zaw on 5/7/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit

class CustomRideHistoryTableViewCell: UITableViewCell {
    
//    let profileImageView: UIImageView = {
//        let img = UIImageView()
//        img.contentMode = .scaleAspectFill
//        img.translatesAutoresizingMaskIntoConstraints = false
//        img.layer.cornerRadius = 35
//        img.clipsToBounds = true
//        return img
//    }()
//
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 15)
//        label.textColor = .black
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
    let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.backgroundColor = .blue
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 6, width: self.frame.width - 20, height: 110))
        view.backgroundColor = .blue
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.clipsToBounds = true
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(containerView)
        // Configure the view for the selected state
    }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
////        addSubview(profileImageView)
//        addSubview(containerView)
////        containerView.addSubview(nameLabel)
//        containerView.addSubview(dateTimeLabel)
//
////        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
////        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
////        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
////        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
////
//        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        containerView.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
//        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
////
////        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
////        nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
////        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
////
//
//        dateTimeLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        dateTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
//    var ride: RideHistory? {
//        didSet {
//            guard let rideItem = RideHistory() else { return }
//            if let dateTime = rideItem.dateTime {
//                dateTimeLabel.text = dateTime
//            }
//        }
//    }

}
