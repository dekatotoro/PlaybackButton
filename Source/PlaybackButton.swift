//
//  PlaybackButton.swift
//  PlaybackButton
//
//  Created by Yuji Hato on 1/1/16.
//  Copyright © 2016 dekatotoro. All rights reserved.
//


import UIKit


@objc enum PlaybackButtonState : Int {
    case None = 0
    case Pausing
    case Playing
    case Pending
    
    var value: CGFloat {
        switch self {
        case .None:
            return 0.0
        case .Pausing:
            return 1.0
        case .Playing:
            return 0.0
        case .Pending:
            return 1.0
        }
    }
    
    func color(layer: PlaybackLayer) -> CGColor {
        switch self {
        case .None:
            return UIColor.whiteColor().CGColor
        case .Pausing:
            return layer.pausingColor.CGColor
        case .Playing:
            return layer.playingColor.CGColor
        case .Pending:
            return layer.pendingColor.CGColor
        }
    }
}

@objc class PlaybackLayer: CALayer {
    
    private static let kAnimationKey = "playbackValue"
    private static let kAnimationIdentifier = "playbackLayerAnimation"
    
    var adjustMarginValue: CGFloat = 0
    var contentEdgeInsets = UIEdgeInsetsZero
    var buttonState = PlaybackButtonState.Pausing
    var playbackValue: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var pausingColor = UIColor.whiteColor()
    var playingColor = UIColor.whiteColor()
    var pendingColor = UIColor.whiteColor()
    
    override init() {
        super.init()
    }
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
        if let playbackLayer = layer as? PlaybackLayer {
            self.adjustMarginValue = playbackLayer.adjustMarginValue
            self.contentEdgeInsets = playbackLayer.contentEdgeInsets
            self.buttonState = playbackLayer.buttonState
            self.playbackValue = playbackLayer.playbackValue
            self.playingColor = playbackLayer.playingColor
            self.pausingColor = playbackLayer.pausingColor
            self.pendingColor = playbackLayer.pendingColor
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.removeAllAnimations()
    }
    
    func setButtonState(buttonState: PlaybackButtonState, animated: Bool) {
        if self.buttonState == buttonState {
            return
        }
        self.buttonState = buttonState
        
        if animated {
            if self.animationForKey(PlaybackLayer.kAnimationIdentifier) != nil {
                self.removeAnimationForKey(PlaybackLayer.kAnimationIdentifier)
            }
            
            let fromValue: CGFloat = self.playbackValue
            let toValue: CGFloat = buttonState.value
            
            let animation = CABasicAnimation(keyPath: PlaybackLayer.kAnimationKey)
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = 0.24
            animation.removedOnCompletion = true
            animation.fillMode = kCAFillModeForwards
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.delegate = self
            self.addAnimation(animation, forKey: PlaybackLayer.kAnimationIdentifier)
        } else {
            self.playbackValue = buttonState.value
        }
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            if self.animationForKey(PlaybackLayer.kAnimationIdentifier) != nil {
                self.removeAnimationForKey(PlaybackLayer.kAnimationIdentifier)
            }
            if let toValue : CGFloat = anim.valueForKey("toValue") as? CGFloat {
                self.playbackValue = toValue
            }
        }
    }

    
    override class func needsDisplayForKey(key: String) -> Bool {
        if key == PlaybackLayer.kAnimationKey {
            return true
        }
        return CALayer.needsDisplayForKey(key)
    }

    override func drawInContext(context: CGContext) {
        switch self.buttonState {
        case .None:
            return
        case .Pausing, .Pending, .Playing:
            
            let rect = CGContextGetClipBoundingBox(context)
            let baseWidth = rect.width
            let baseHeight = rect.height
            let topMargin: CGFloat = self.contentEdgeInsets.top
            let leftMargin: CGFloat = self.contentEdgeInsets.left
            
            let drawHalfWidth: CGFloat = (baseWidth - leftMargin * 2) / 2.0
            let drawQuarterWidth: CGFloat = drawHalfWidth / 2.0
            let subtractWidth: CGFloat = drawHalfWidth - drawQuarterWidth
            let width: CGFloat = drawQuarterWidth + subtractWidth * self.playbackValue
            
            let playingMargin: CGFloat = drawQuarterWidth / 2.0 * self.adjustMarginValue
            let pausingMargin: CGFloat = drawQuarterWidth / 2.0
            let subtractMargin: CGFloat = playingMargin - pausingMargin
            let adjustMargin: CGFloat = pausingMargin + subtractMargin * self.playbackValue
            
            let height: CGFloat = baseHeight - topMargin * 2
            let h1: CGFloat = height / 4.0 * self.playbackValue
            let h2: CGFloat = height / 2.0 * self.playbackValue
            
            CGContextMoveToPoint(context, leftMargin + adjustMargin, topMargin)
            CGContextAddLineToPoint(context, leftMargin + adjustMargin + width, topMargin + h1)
            CGContextAddLineToPoint(context, leftMargin + adjustMargin + width, topMargin + height - h1)
            CGContextAddLineToPoint(context, leftMargin + adjustMargin, topMargin + height)
            
            CGContextMoveToPoint(context, leftMargin + drawHalfWidth + adjustMargin, topMargin + h1)
            CGContextAddLineToPoint(context, leftMargin + drawHalfWidth + adjustMargin + width, topMargin + h2)
            CGContextAddLineToPoint(context, leftMargin + drawHalfWidth + adjustMargin + width, topMargin + height - h2)
            CGContextAddLineToPoint(context, leftMargin + drawHalfWidth + adjustMargin, topMargin + height - h1)
            
            CGContextSetFillColorWithColor(context, self.buttonState.color(self))
            CGContextFillPath(context)
        }
    }

}

@objc class PlaybackButton : UIButton {
    
    private var playbackLayer: PlaybackLayer?
    
    var buttonState: PlaybackButtonState {
        return self.playbackLayer?.buttonState ?? PlaybackButtonState.Pausing
    }

    override var contentEdgeInsets: UIEdgeInsets {
        didSet {
            self.playbackLayer?.contentEdgeInsets = self.contentEdgeInsets
        }
    }
    
    var adjustMargin: CGFloat = 1 {
        didSet {
            self.playbackLayer?.adjustMarginValue = self.adjustMargin
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addPlaybackLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addPlaybackLayer()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func addPlaybackLayer() {
        let playbackLayer = PlaybackLayer()
        playbackLayer.frame = self.bounds
        playbackLayer.adjustMarginValue = self.adjustMargin
        playbackLayer.contentEdgeInsets = self.contentEdgeInsets
        playbackLayer.playbackValue = PlaybackButtonState.Pausing.value
        playbackLayer.pausingColor = self.tintColor
        playbackLayer.playingColor = self.tintColor
        playbackLayer.pendingColor = self.tintColor
        self.playbackLayer = playbackLayer
        self.layer.addSublayer(playbackLayer)
    }
    
    func setButtonState(buttonState: PlaybackButtonState, animated: Bool) {
        self.playbackLayer?.setButtonState(buttonState, animated: animated)
    }
    
    func setButtonStateColor(buttonState: PlaybackButtonState, color: UIColor) {
        switch buttonState {
        case .None:
            break
        case .Pausing:
            self.playbackLayer?.pausingColor = color
        case .Playing:
            self.playbackLayer?.playingColor = color
        case .Pending:
            self.playbackLayer?.pendingColor = color
        }
        
    }
}