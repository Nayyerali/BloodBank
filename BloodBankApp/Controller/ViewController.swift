//
//  ViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/13/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setUpBackgroundVideo()
        elements()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpBackgroundVideo()
    }

    func elements () {
        Utilities.styleFilledButton(signInBtn)
        Utilities.styleHollowButton(signUpBtn)
    }
}

extension ViewController {

func showAlert(controller:UIViewController,title:String,message:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
    
    let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
        // ok button press
        completion(true)
    }
    alerController.addAction(okAction)
    controller.present(alerController, animated: true)
}

func showAlert(controller:UIViewController,title:String,message:String,actiontitle:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
    
    let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let delete = UIAlertAction(title: actiontitle, style: .destructive) { (alertAction) in
        // ok button press
        completion(true)
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
        // ok button press
        completion(false)
    }
    alerController.addAction(delete)
    alerController.addAction(cancel)
    controller.present(alerController, animated: true)
    }
}
extension ViewController {
    
    func setUpBackgroundVideo () {
        // Get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "BackgroundVideo", ofType: "mp4")
        guard bundlePath != nil else {
            return
        }
        // Create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        // Create the video player item
        let item = AVPlayerItem(url: url)
        // Create the player
        videoPlayer = AVPlayer(playerItem: item)
        // Create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        // Adjust the size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        // Add it to the view and play it
        videoPlayer?.playImmediately(atRate: 0.1)
    }
}
