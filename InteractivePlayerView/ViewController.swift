//
//  ViewController.swift
//  InteractivePlayerView
//
//  Created by AhmetKeskin on 02/09/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit

class ViewController: UIViewController, InteractivePlayerViewDelegate {
    
    
    @IBOutlet var blurBgImage: UIImageView!
    @IBOutlet var ipv: InteractivePlayerView!
    @IBOutlet var containerView: UIView!

    @IBOutlet var playButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var playPauseButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.backgroundColor = UIColor.clearColor()
        self.makeImageBlurry(self.blurBgImage)
        self.makeItRounded(self.playPauseButtonView, newSize: self.playPauseButtonView.frame.width)

        self.ipv!.delegate = self
        
        // duration of music
        self.ipv.progress = 20.0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playButtonTapped(sender: AnyObject) {
        
        self.ipv.start()

        self.playButton.hidden = true
        self.pauseButton.hidden = false
        
    }
    
    @IBAction func pauseButtonTapped(sender: AnyObject) {
        
        self.ipv.stop()
        
        self.playButton.hidden = false
        self.pauseButton.hidden = true
    }
    
    @IBAction func nextTapped(sender: AnyObject) {
        self.ipv.restartWithProgress(duration: 50)
    }
    
    @IBAction func previousTapped(sender: AnyObject) {
        self.ipv.restartWithProgress(duration: 10)
    }
    
    /* InteractivePlayerViewDelegate METHODS */
    func actionOneButtonTapped(sender: UIButton, isSelected: Bool) {
        print("shuffle \(isSelected.description)")
    }
    
    func actionTwoButtonTapped(sender: UIButton, isSelected: Bool) {
        print("like \(isSelected.description)")
    }
    
    func actionThreeButtonTapped(sender: UIButton, isSelected: Bool) {
        print("replay \(isSelected.description)")

    }
    
    func interactivePlayerViewDidChangedDuration(playerInteractive: InteractivePlayerView, currentDuration: Double) {
        print("current Duration : \(currentDuration)")
    }
    
    func interactivePlayerViewDidStartPlaying(playerInteractive: InteractivePlayerView) {
        print("interactive player did started")
    }
    
    func interactivePlayerViewDidStopPlaying(playerInteractive: InteractivePlayerView) {
        print("interactive player did stop")
    }
    
    
    
    func makeImageBlurry(imageView : UIImageView){
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = imageView.bounds
            blurEffectView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            
            imageView.addSubview(blurEffectView)

        }
        
    }
    
    func makeItRounded(view : UIView!, newSize : CGFloat!){
        let saveCenter : CGPoint = view.center
        let newFrame : CGRect = CGRectMake(view.frame.origin.x, view.frame.origin.y, newSize, newSize)
        view.frame = newFrame
        view.layer.cornerRadius = newSize / 2.0
        view.clipsToBounds = true
        view.center = saveCenter
        
    }
}
