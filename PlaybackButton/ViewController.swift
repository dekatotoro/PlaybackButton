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
        self.playbackButton1.backgroundColor = UIColor.clear
        self.playbackButton1.setButtonColor(UIColor(hex: "2c3e50", alpha: 1.0))
        self.playbackButton1.addTarget(self, action: #selector(ViewController.didTapPlaybackButton1(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(self.playbackButton1)
        
        // playbackButton2
        self.playbackButton2.layer.cornerRadius = 24.0
        self.playbackButton2.duration = 0.4
        self.playbackButton2.layer.borderColor = UIColor.white.cgColor
        self.playbackButton2.layer.borderWidth = 2.0
        
        // playbackButton3
        self.playbackButton3.layer.cornerRadius = self.playbackButton3.frame.size.height / 2
        self.playbackButton3.layer.borderColor = UIColor.white.cgColor
        self.playbackButton3.layer.borderWidth = 2.0
        self.playbackButton3.setButtonColor(UIColor(hex: "95a5a6", alpha: 1.0), buttonState: PlaybackButtonState.pending)        
        
        // playbackButton4
        self.playbackButton4.layer.cornerRadius = self.playbackButton4.frame.size.height / 2
        self.playbackButton4.contentEdgeInsets = UIEdgeInsets(top: 16, left: 18, bottom: 16, right: 18)
        self.playbackButton4.adjustMargin = 1
        self.playbackButton4.layer.borderColor = UIColor.white.cgColor
        self.playbackButton4.layer.borderWidth = 2.0
        self.playbackButton4.setButtonColor(UIColor(hex: "95a5a6", alpha: 1.0), buttonState: PlaybackButtonState.pending)
        
        // playbackButton5
        self.playbackButton5.layer.cornerRadius = self.playbackButton5.frame.size.height / 2
        self.playbackButton5.layer.borderColor = UIColor(hex: "2c3e50", alpha: 1.0).cgColor
        self.playbackButton5.layer.borderWidth = 5.0
        self.playbackButton5.duration = 0.3
        self.playbackButton5.adjustMargin = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func didTapPlaybackButton1(_ sender: AnyObject) {
        if self.playbackButton1.buttonState == .playing {
            self.playbackButton1.setButtonState(.pausing, animated: true)
        } else if self.playbackButton1.buttonState == .pausing {
            self.playbackButton1.setButtonState(.playing, animated: true)
        }
    }
    
    @IBAction func didTapPlaybackButton2(_ sender: AnyObject) {
        if self.playbackButton2.buttonState == .playing {
            self.playbackButton2.setButtonState(.pausing, animated: true)
        } else if self.playbackButton2.buttonState == .pausing {
            self.playbackButton2.setButtonState(.playing, animated: true)
        }
    }
    
    @IBAction func didTapPlaybackButton3(_ sender: AnyObject) {
        if self.playbackButton3.buttonState == .playing {
            self.playbackButton3.setButtonState(.pending, animated: false)
        } else if self.playbackButton3.buttonState == .pausing {
            self.playbackButton3.setButtonState(.playing, animated: false)
        } else if self.playbackButton3.buttonState == .pending {
            self.playbackButton3.setButtonState(.pausing, animated: false)
        }
    }
    
    @IBAction func didTapPlaybackButton4(_ sender: AnyObject) {
        if self.playbackButton4.buttonState == .playing {
            self.playbackButton4.setButtonState(.pending, animated: true)
        } else if self.playbackButton4.buttonState == .pausing {
            self.playbackButton4.setButtonState(.playing, animated: true)
        } else if self.playbackButton4.buttonState == .pending {
            self.playbackButton4.setButtonState(.pausing, animated: true)
        }
    }
    
    @IBAction func didTapPlaybackButton5(_ sender: AnyObject) {
        if self.playbackButton5.buttonState == .playing {
            self.playbackButton5.setButtonState(.pausing, animated: true)
        } else if self.playbackButton5.buttonState == .pausing {
            self.playbackButton5.setButtonState(.playing, animated: true)
        }
    }
}

