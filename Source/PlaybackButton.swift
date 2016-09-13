//
//  PlaybackButton.swift
//  PlaybackButton
//
//  Created by Yuji Hato on 1/1/16.
//  Copyright © 2016 dekatotoro. All rights reserved.
//


import UIKit

@objc public enum PlaybackButtonState : Int {
    case none = 0
    case pausing
    case playing
    case pending
    
    public var value: CGFloat {
        switch self {
        case .none:
            return 0.0
        case .pausing:
            return 1.0
        case .playing:
            return 0.0
        case .pending:
            return 1.0
        }
    }
    
    public func color(_ layer: PlaybackLayer) -> CGColor {
        switch self {
        case .none:
            return UIColor.white.cgColor
        case .pausing:
            return layer.pausingColor.cgColor
        case .playing:
            return layer.playingColor.cgColor
        case .pending:
            return layer.pendingColor.cgColor
        }
    }
}

@objc open class PlaybackLayer: CALayer {
    
    fileprivate static let kAnimationKey = "playbackValue"
    fileprivate static let kAnimationIdentifier = "playbackLayerAnimation"
    
    open var adjustMarginValue: CGFloat = 0
    open var contentEdgeInsets = UIEdgeInsets.zero
    open var buttonState = PlaybackButtonState.pausing
    open var playbackValue: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    open var pausingColor = UIColor.white
    open var playingColor = UIColor.white
    open var pendingColor = UIColor.white
    open var playbackAnimationDuration: CFTimeInterval = PlaybackButton.kDefaultDuration
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
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

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.removeAllAnimations()
    }
    
    open func setButtonState(_ buttonState: PlaybackButtonState, animated: Bool) {
        if self.buttonState == buttonState {
            return
        }
        self.buttonState = buttonState
        
        if animated {
            if self.animation(forKey: PlaybackLayer.kAnimationIdentifier) != nil {
                self.removeAnimation(forKey: PlaybackLayer.kAnimationIdentifier)
            }
            
            let fromValue: CGFloat = self.playbackValue
            let toValue: CGFloat = buttonState.value
            
            let animation = CABasicAnimation(keyPath: PlaybackLayer.kAnimationKey)
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = self.playbackAnimationDuration
            animation.isRemovedOnCompletion = true
            animation.fillMode = kCAFillModeForwards
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.delegate = self
            self.add(animation, forKey: PlaybackLayer.kAnimationIdentifier)
        } else {
            self.playbackValue = buttonState.value
        }
    }
    
    open override class func needsDisplay(forKey key: String) -> Bool {
        if key == PlaybackLayer.kAnimationKey {
            return true
        }
        return CALayer.needsDisplay(forKey: key)
    }

    open override func draw(in context: CGContext) {
        switch self.buttonState {
        case .none:
            return
        case .pausing, .pending, .playing:
            
            let rect = context.boundingBoxOfClipPath
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
            
            context.move(to: CGPoint(x: leftMargin + adjustMargin, y: topMargin))
            context.addLine(to: CGPoint(x: leftMargin + adjustMargin + width, y: topMargin + h1))
            context.addLine(to: CGPoint(x: leftMargin + adjustMargin + width, y: topMargin + height - h1))
            context.addLine(to: CGPoint(x: leftMargin + adjustMargin, y: topMargin + height))
            
            context.move(to: CGPoint(x: leftMargin + drawHalfWidth + adjustMargin, y: topMargin + h1))
            context.addLine(to: CGPoint(x: leftMargin + drawHalfWidth + adjustMargin + width, y: topMargin + h2))
            context.addLine(to: CGPoint(x: leftMargin + drawHalfWidth + adjustMargin + width, y: topMargin + height - h2))
            context.addLine(to: CGPoint(x: leftMargin + drawHalfWidth + adjustMargin, y: topMargin + height - h1))
            
            context.setFillColor(self.buttonState.color(self))
            context.fillPath()
        }
    }
}

extension PlaybackLayer: CAAnimationDelegate {
    
    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if self.animation(forKey: PlaybackLayer.kAnimationIdentifier) != nil {
                self.removeAnimation(forKey: PlaybackLayer.kAnimationIdentifier)
            }
            if let toValue : CGFloat = anim.value(forKey: "toValue") as? CGFloat {
                self.playbackValue = toValue
            }
        }
    }
}

@objc open class PlaybackButton : UIButton {
    
    static let kDefaultDuration: CFTimeInterval = 0.24
    open var playbackLayer: PlaybackLayer?
    open var duration: CFTimeInterval = PlaybackButton.kDefaultDuration {
        didSet {
            self.playbackLayer?.playbackAnimationDuration = self.duration
        }
    }
    
    open var buttonState: PlaybackButtonState {
        return self.playbackLayer?.buttonState ?? PlaybackButtonState.pausing
    }

    open override var contentEdgeInsets: UIEdgeInsets {
        didSet {
            self.playbackLayer?.contentEdgeInsets = self.contentEdgeInsets
        }
    }
    
    open var adjustMargin: CGFloat = 1 {
        didSet {
            self.playbackLayer?.adjustMarginValue = self.adjustMargin
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addPlaybackLayer()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addPlaybackLayer()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    open func setButtonState(_ buttonState: PlaybackButtonState, animated: Bool) {
        self.playbackLayer?.setButtonState(buttonState, animated: animated)
    }

    open func setButtonColor(_ color: UIColor) {
        self.playbackLayer?.pausingColor = color
        self.playbackLayer?.playingColor = color
        self.playbackLayer?.pendingColor = color
    }
    
    open func setButtonColor(_ color: UIColor, buttonState: PlaybackButtonState) {
        switch buttonState {
        case .none:
            break
        case .pausing:
            self.playbackLayer?.pausingColor = color
        case .playing:
            self.playbackLayer?.playingColor = color
        case .pending:
            self.playbackLayer?.pendingColor = color
        }
    }
    
    fileprivate func addPlaybackLayer() {
        let playbackLayer = PlaybackLayer()
        playbackLayer.frame = self.bounds
        playbackLayer.adjustMarginValue = self.adjustMargin
        playbackLayer.contentEdgeInsets = self.contentEdgeInsets
        playbackLayer.playbackValue = PlaybackButtonState.pausing.value
        playbackLayer.pausingColor = self.tintColor
        playbackLayer.playingColor = self.tintColor
        playbackLayer.pendingColor = self.tintColor
        playbackLayer.playbackAnimationDuration = self.duration
        self.playbackLayer = playbackLayer
        self.layer.addSublayer(playbackLayer)
    }
}
