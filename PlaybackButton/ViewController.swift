//
//  ViewController.swift
//  PlaybackButton
//
//  Created by Yuji Hato on 12/14/15.
//  Copyright © 2015 dekatotoro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var playbackButton1: PlaybackButton!
    @IBOutlet weak var playbackButton2: PlaybackButton!
    @IBOutlet weak var playbackButton3: PlaybackButton!
    @IBOutlet weak var playbackButton4: PlaybackButton!
    @IBOutlet weak var playbackButton5: PlaybackButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // playbackButton1
        self.playbackButton1 = PlaybackButton(frame: CGRect(x: 0, y:20, width: 100, height: 100 ))
        self.playbackButton1.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.playbackButton1.adjustMargin = 1
        self.playbackButton1.backgroundColor = UIColor.clearColor()
        self.playbackButton1.setButtonColor(UIColor(hex: "2c3e50", alpha: 1.0))
        self.playbackButton1.addTarget(self, action: #selector(ViewController.didTapPlaybackButton1(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.playbackButton1)
        
        // playbackButton2
        self.playbackButton2.layer.cornerRadius = 24.0
        self.playbackButton2.duration = 0.4
        self.playbackButton2.layer.borderColor = UIColor.whiteColor().CGColor
        self.playbackButton2.layer.borderWidth = 2.0
        
        // playbackButton3
        self.playbackButton3.layer.cornerRadius = self.playbackButton3.frame.size.height / 2
        self.playbackButton3.layer.borderColor = UIColor.whiteColor().CGColor
        self.playbackButton3.layer.borderWidth = 2.0
        self.playbackButton3.setButtonColor(UIColor(hex: "95a5a6", alpha: 1.0), buttonState: PlaybackButtonState.Pending)        
        
        // playbackButton4
        self.playbackButton4.layer.cornerRadius = self.playbackButton4.frame.size.height / 2
        self.playbackButton4.contentEdgeInsets = UIEdgeInsets(top: 16, left: 18, bottom: 16, right: 18)
        self.playbackButton4.adjustMargin = 1
        self.playbackButton4.layer.borderColor = UIColor.whiteColor().CGColor
        self.playbackButton4.layer.borderWidth = 2.0
        self.playbackButton4.setButtonColor(UIColor(hex: "95a5a6", alpha: 1.0), buttonState: PlaybackButtonState.Pending)
        
        // playbackButton5
        self.playbackButton5.layer.cornerRadius = self.playbackButton5.frame.size.height / 2
        self.playbackButton5.layer.borderColor = UIColor(hex: "2c3e50", alpha: 1.0).CGColor
        self.playbackButton5.layer.borderWidth = 5.0
        self.playbackButton5.duration = 0.3
        self.playbackButton5.adjustMargin = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func didTapPlaybackButton1(sender: AnyObject) {
        if self.playbackButton1.buttonState == .Playing {
            self.playbackButton1.setButtonState(.Pausing, animated: true)
        } else if self.playbackButton1.buttonState == .Pausing {
            self.playbackButton1.setButtonState(.Playing, animated: true)
        }
    }
    
    @IBAction func didTapPlaybackButton2(sender: AnyObject) {
        if self.playbackButton2.buttonState == .Playing {
            self.playbackButton2.setButtonState(.Pausing, animated: true)
        } else if self.playbackButton2.buttonState == .Pausing {
            self.playbackButton2.setButtonState(.Playing, animated: true)
        }
    }
    
    @IBAction func didTapPlaybackButton3(sender: AnyObject) {
        if self.playbackButton3.buttonState == .Playing {
            self.playbackButton3.setButtonState(.Pending, animated: false)
        } else if self.playbackButton3.buttonState == .Pausing {
            self.playbackButton3.setButtonState(.Playing, animated: false)
        } else if self.playbackButton3.buttonState == .Pending {
            self.playbackButton3.setButtonState(.Pausing, animated: false)
        }
    }
    
    @IBAction func didTapPlaybackButton4(sender: AnyObject) {
        if self.playbackButton4.buttonState == .Playing {
            self.playbackButton4.setButtonState(.Pending, animated: true)
        } else if self.playbackButton4.buttonState == .Pausing {
            self.playbackButton4.setButtonState(.Playing, animated: true)
        } else if self.playbackButton4.buttonState == .Pending {
            self.playbackButton4.setButtonState(.Pausing, animated: true)
        }
    }
    
    @IBAction func didTapPlaybackButton5(sender: AnyObject) {
        if self.playbackButton5.buttonState == .Playing {
            self.playbackButton5.setButtonState(.Pausing, animated: true)
        } else if self.playbackButton5.buttonState == .Pausing {
            self.playbackButton5.setButtonState(.Playing, animated: true)
        }
    }
}

