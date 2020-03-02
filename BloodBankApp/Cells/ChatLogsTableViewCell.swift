//
//  ChatLogsTableViewCell.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/24/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class ChatLogsTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var backgroundBubble: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundBubble.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundBubble)
        addSubview(userImage)
        addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userImage.layer.masksToBounds = true
        userImage.translatesAutoresizingMaskIntoConstraints = false
        
        userImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        userImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        userImage.trailingAnchor.constraint(equalTo:
        backgroundBubble.leadingAnchor).isActive = true
        
        
        bubbleViewRightAnchor = backgroundBubble.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = backgroundBubble.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 20)
        bubbleViewLeftAnchor?.isActive = false
        backgroundBubble.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = backgroundBubble.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        backgroundBubble.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // profileImageView.roundedImage()
    }
    //
    //    let textView: UILabel = {
    //        let tv = UILabel()
    //        tv.text = "SAMPLE TEXT FOR NOW"
    //        tv.font = UIFont.systemFont(ofSize: 16)
    //        tv.translatesAutoresizingMaskIntoConstraints = false
    //        tv.backgroundColor = UIColor.clear
    //        tv.textColor = .white
    //        return tv
    //    }()
    //
    //    static let blueColor = UIColor(displayP3Red: 0, green: 137, blue: 249, alpha: 1)
    //
    //    let bubbleView: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = blueColor
    //        view.translatesAutoresizingMaskIntoConstraints = false
    //        view.layer.cornerRadius = 16
    //        view.layer.masksToBounds = true
    //        return view
    //    }()
    //
    //    let profileImageView: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.image = UIImage(named: "nedstark")
    //        imageView.translatesAutoresizingMaskIntoConstraints = false
    //        imageView.layer.cornerRadius = 16
    //        imageView.layer.masksToBounds = true
    //        imageView.contentMode = .scaleAspectFill
    //        return imageView
    //    }()
    //
    //    var bubbleWidthAnchor: NSLayoutConstraint?
    //    var bubbleViewRightAnchor: NSLayoutConstraint?
    //    var bubbleViewLeftAnchor: NSLayoutConstraint?
    //
    ////    override init(frame: CGRect) {
    ////        super.init(frame: frame)
    //
    //        required init?(coder aDecoder: NSCoder) {
    //            super.init(coder: aDecoder)
    //        }
    //
    //    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    //            super.init(style: style, reuseIdentifier: reuseIdentifier)
    //        //}
    //        addSubview(bubbleView)
    //        addSubview(textView)
    //        addSubview(profileImageView)
    //
    //        //x,y,w,h
    //        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
    //        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    //        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
    //        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    //
    //        //x,y,w,h
    //
    //        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
    //
    //        bubbleViewRightAnchor?.isActive = true
    //
    //        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
    //        //        bubbleViewLeftAnchor?.active = false
    //
    //
    //        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    //
    //        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
    //        bubbleWidthAnchor?.isActive = true
    //
    //        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    //
    //        //ios 9 constraints
    //        //x,y,w,h
    //        //        textView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
    //        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
    //        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    //
    //        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
    //        //        textView.widthAnchor.constraintEqualToConstant(200).active = true
    //
    //
    //        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    //    }
    
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    //
}

