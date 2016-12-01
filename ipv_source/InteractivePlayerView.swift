/* The MIT License

    Copyright 2015 Ahmet Keskin

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT   LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

import UIKit

protocol InteractivePlayerViewDelegate {
    
    func actionOneButtonTapped(sender : UIButton, isSelected : Bool)
    func actionTwoButtonTapped(sender : UIButton, isSelected : Bool)
    func actionThreeButtonTapped(sender : UIButton, isSelected : Bool)
    
    func interactivePlayerViewDidStartPlaying(playerInteractive:InteractivePlayerView)
    func interactivePlayerViewDidStopPlaying(playerInteractive:InteractivePlayerView)
    
    
    /**
       @ callbacks in every changes at the duration
     */
    func interactivePlayerViewDidChangedDuration(playerInteractive:InteractivePlayerView , currentDuration:Double)
}

@IBDesignable
class InteractivePlayerView : UIView {
    
    var view: UIView!
    var delegate: InteractivePlayerViewDelegate?
    
    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var actionOne: UIButton!
    @IBOutlet private var actionTwo: UIButton!
    @IBOutlet private var actionThree: UIButton!
    @IBOutlet private var actionOneButtonWidth: NSLayoutConstraint!
    @IBOutlet private var actionOneButtonHeight: NSLayoutConstraint!
    @IBOutlet private var actionTwoButtonWidth: NSLayoutConstraint!
    @IBOutlet private var actionTwoButtonHeight: NSLayoutConstraint!
    @IBOutlet private var actionThreeButtonWidth: NSLayoutConstraint!
    @IBOutlet private var actionThreeButtonHeight: NSLayoutConstraint!
    
    /// duration of song
    var progress : Double = 0.0
    
    /// is music playing
    var isPlaying : Bool = false
    
    /// You can set action button images with this struct
    var actionImages = ActionButtonImages()
    
    /// set progress colors
    var progressEmptyColor : UIColor = UIColor.white
    var progressFullColor : UIColor = UIColor.red
    
    /// used to change current time of the sound . default is true
    var panEnabled:Bool = true
    
    /// is ActionOne selected
    var isActionOneSelected : Bool = false {
        
        didSet {
            
            if isActionOneSelected {
                self.actionOne.isSelected = true
                self.actionOne.setImage(self.actionImages.actionOneSelected, for: UIControlState.selected)
            }else {
                self.actionOne.isSelected = false
                self.actionOne.setImage(self.actionImages.actionOneUnSelected, for: UIControlState.normal)
            }
        }
    }
    
    /// is ActionTwo selected
    var isActionTwoSelected : Bool = false {
        
        didSet {
            if isActionTwoSelected {
                self.actionTwo.isSelected = true
                self.actionTwo.setImage(self.actionImages.actionTwoSelected, for: UIControlState.selected)
            }else {
                self.actionTwo.isSelected = false
                self.actionTwo.setImage(self.actionImages.actionTwoUnSelected, for: UIControlState.normal)
            }
        }
    }
    
    /// is ActionThree selected
    var isActionThreeSelected : Bool = false {
        
        didSet {
            if isActionThreeSelected {
                self.actionThree.isSelected = true
                self.actionThree.setImage(self.actionImages.actionThreeSelected, for: UIControlState.selected)
            }else {
                self.actionThree.isSelected = false
                self.actionThree.setImage(self.actionImages.actionThreeUnSelected, for: UIControlState.normal)
            }
        }
    }
    
    
    /* Timer for update time*/
    private var timer: Timer!
    
    /* Controlling progress bar animation with isAnimating */
    private var isAnimating : Bool = false
    
    /* increasing duration in updateTime */
    private var duration : Double{
        didSet{
            redrawStrokeEnd()
            
            if let theDelegate = self.delegate {
                theDelegate.interactivePlayerViewDidChangedDuration(playerInteractive: self, currentDuration: duration)
            }
            
        }
    }

    private var circleLayer: CAShapeLayer! = CAShapeLayer()

    /* Setting action buttons constraint width - height with buttonSizes */
    @IBInspectable var buttonSizes : CGFloat = 20.0 {
        
        didSet {
            self.actionOneButtonHeight.constant = buttonSizes
            self.actionOneButtonWidth.constant = buttonSizes
            self.actionTwoButtonHeight.constant = buttonSizes
            self.actionTwoButtonWidth.constant = buttonSizes
            self.actionThreeButtonHeight.constant = buttonSizes
            self.actionThreeButtonWidth.constant = buttonSizes
        }
    }
    
    /* 
     *
     * Set Images in storyBoard with IBInspectable variables
     *
     */
    @IBInspectable var coverImage: UIImage? {
        get {
            return coverImageView.image
        }
        set(coverImage) {
            coverImageView.image = coverImage
        }
    }
    
    @IBInspectable var actionOne_icon_selected: UIImage? {
        
        get {
            return actionImages.actionOneSelected
        }
        set(actionOne_icon_selected) {
            actionOne.setImage(actionOne_icon_selected, for: UIControlState.selected)
            actionImages.actionOneSelected = actionOne_icon_selected
        }
    }
    
    @IBInspectable var actionOne_icon_unselected: UIImage? {
        
        get {
            return actionImages.actionOneUnSelected
        }
        set(actionOne_icon_unselected) {
            actionOne.setImage(actionOne_icon_unselected, for: UIControlState.normal)
            actionImages.actionOneUnSelected = actionOne_icon_unselected
        }
    }
    
    @IBInspectable var actionTwo_icon_selected: UIImage? {
        
        get {
            return actionImages.actionTwoSelected
        }
        set(actionTwo_icon_selected) {
            actionTwo.setImage(actionTwo_icon_selected, for: UIControlState.selected)
            actionImages.actionTwoSelected = actionTwo_icon_selected
        }
    }
    
    @IBInspectable var actionTwo_icon_unselected: UIImage? {
        
        get {
            return actionImages.actionTwoUnSelected
        }
        set(actionTwo_icon_unselected) {
            actionTwo.setImage(actionTwo_icon_unselected, for: UIControlState.normal)
            actionImages.actionTwoUnSelected = actionTwo_icon_unselected
        }
    }
    
    @IBInspectable var actionThree_icon_selected: UIImage? {
        
        get {
            return actionImages.actionThreeSelected
        }
        set(actionThree_icon_selected) {
            actionThree.setImage(actionThree_icon_selected, for: UIControlState.selected)
            actionImages.actionThreeSelected = actionThree_icon_selected
        }
    }
    
    @IBInspectable var actionThree_icon_unselected: UIImage? {
        
        get {
            return actionImages.actionThreeUnSelected
        }
        set(actionThree_icon_unselected) {
            actionThree.setImage(actionThree_icon_unselected, for: UIControlState.normal)
            actionImages.actionThreeUnSelected = actionThree_icon_unselected
        }
    }
    
    /*
     * Button images struct
     */
    
    struct ActionButtonImages {
        
        var actionOneSelected : UIImage?
        var actionOneUnSelected : UIImage?
        var actionTwoSelected : UIImage?
        var actionTwoUnSelected : UIImage?
        var actionThreeSelected : UIImage?
        var actionThreeUnSelected : UIImage?
        
    }
    
    override init(frame: CGRect) {
       
        self.duration = 0
        
        super.init(frame: frame)
        self.createUI()
        self.addPanGesture()

    }
    
    required init?(coder aDecoder: NSCoder) {
      
        self.duration = 0
        
        super.init(coder: aDecoder)
        self.createUI()
        self.addPanGesture()
       
    }
    
    @IBAction private func actionOneButtonTapped(sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
        
        self.isActionOneSelected = sender.isSelected
        
        if let delegate = self.delegate{
            delegate.actionOneButtonTapped(sender: sender, isSelected : sender.isSelected)
        }
    }
    
    @IBAction private func actionTwoButtonTapped(sender: UIButton) {

        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }

        self.isActionTwoSelected = sender.isSelected
        
        if let delegate = self.delegate{
            delegate.actionTwoButtonTapped(sender: sender, isSelected : sender.isSelected)
        }
    }
    
    @IBAction private func actionThreeButtonTapped(sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
        
        self.isActionThreeSelected = sender.isSelected
        
        if let delegate = self.delegate{
            delegate.actionThreeButtonTapped(sender: sender, isSelected : sender.isSelected)
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        self.addCirle(arcRadius: self.bounds.width + 10, capRadius: 2.0, color: self.progressEmptyColor,strokeStart: 0.0,strokeEnd: 1.0)
        self.createProgressCircle()
        
    }
    
    func animationDidStart(anim: CAAnimation) {

        circleLayer.strokeColor = self.progressFullColor.cgColor
        self.isAnimating = true
        self.duration = 0
    }
    
    func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        self.isAnimating = false
        circleLayer.strokeColor = UIColor.clear.cgColor
        
        if(timer != nil) {
            timer.invalidate()
            timer = nil
        }
    }
    
    private func createUI() {
        self.layoutIfNeeded()
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        coverImageView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
        
        self.makeItRounded(view: view, newSize: view.bounds.width)
        self.backgroundColor = UIColor.clear
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InteractivePlayerView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }
    
    private func makeItRounded(view : UIView!, newSize : CGFloat!){
        let saveCenter : CGPoint = view.center
        let newFrame : CGRect = CGRect(x: view.frame.origin.x,y: view.frame.origin.y,width: newSize,height: newSize)
        view.frame = newFrame
        view.layer.cornerRadius = newSize / 2.0
        view.clipsToBounds = true
        view.center = saveCenter
    }
    
    private func addCirle(arcRadius: CGFloat, capRadius: CGFloat, color: UIColor, strokeStart : CGFloat, strokeEnd : CGFloat) {

        let centerPoint = CGPoint(x: self.bounds.midX ,y: self.bounds.midY)
        let startAngle = CGFloat(M_PI_2)
        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
        
        let path = UIBezierPath(arcCenter:centerPoint, radius: frame.width/2+5, startAngle:startAngle, endAngle:endAngle, clockwise: true).cgPath
        
        let arc = CAShapeLayer()
        arc.lineWidth = 2
        arc.path = path
        arc.strokeStart = strokeStart
        arc.strokeEnd = strokeEnd
        arc.strokeColor = color.cgColor
        arc.fillColor = UIColor.clear.cgColor
        arc.shadowColor = UIColor.black.cgColor
        arc.shadowRadius = 0
        arc.shadowOpacity = 0
        arc.shadowOffset = CGSize.zero
        layer.addSublayer(arc)
        
    }
    
    
    private func createProgressCircle(){
        let centerPoint = CGPoint(x: self.bounds.midX ,y: self.bounds.midY)
        let startAngle = CGFloat(M_PI_2)
        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter:centerPoint, radius: frame.width/2+5, startAngle:startAngle, endAngle:endAngle, clockwise: true).cgPath
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.shadowColor = UIColor.black.cgColor
        circleLayer.strokeColor = self.progressFullColor.cgColor
        circleLayer.lineWidth = 2.0;
        circleLayer.strokeStart = 0.0
        circleLayer.shadowRadius = 0
        circleLayer.shadowOpacity = 0
        circleLayer.shadowOffset = CGSize.zero
        
        // draw the colorful , nice progress circle
        circleLayer.strokeEnd = CGFloat(duration/progress)
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    
    
    private func redrawStrokeEnd(){
        circleLayer.strokeEnd = CGFloat(duration/progress)
    }
    
    private func resetAnimationCircle(){
        stopTimer()
        duration = 0
        circleLayer.strokeEnd = 0
    }
    
    private func pauseLayer(layer : CALayer) {
        let pauseTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pauseTime
    }
    
    private func resumeLayer(layer : CALayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    private func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(InteractivePlayerView.updateTime), userInfo: nil, repeats: true)

        if let theDelegate = self.delegate {
            theDelegate.interactivePlayerViewDidStartPlaying(playerInteractive: self)
        }
    }
    
    private func stopTimer(){
       
        if(timer != nil) {
            timer.invalidate()
            timer = nil
            
            if let theDelegate = self.delegate {
                theDelegate.interactivePlayerViewDidStopPlaying(playerInteractive: self)
            }
            
        }
        
    }
    
    func updateTime(){
        
        self.duration += 0.1
        let totalDuration = Int(self.duration)
        let min = totalDuration / 60
        let sec = totalDuration % 60
        
        timeLabel.text = NSString(format: "%i:%02i",min,sec ) as String
        
        if(self.duration >= self.progress)
        {
            stopTimer()
        }
        
    }
    
    /* Start timer and animation */
    func start(){
        self.startTimer()
    }
    
    /* Stop timer and animation */
    func stop(){
       self.stopTimer()
    }
    
    func restartWithProgress(duration : Double){
        progress = duration
        self.resetAnimationCircle()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(InteractivePlayerView.start), userInfo: nil, repeats: false)
    }
    
    // MARK: - Gestures
    func addPanGesture(){
        let gesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(InteractivePlayerView.handlePanGesture))
        gesture.maximumNumberOfTouches = 1
        self.addGestureRecognizer(gesture)
    }
    
    func handlePanGesture(gesture:UIPanGestureRecognizer){
        if(!self.panEnabled){
            return;
        }
        
        let translation:CGPoint = gesture.translation(in: self)
        
        
        let xDirection:CGFloat  = translation.x
        let yDirection:CGFloat =  -1 * translation.y
        
        let rate:CGFloat = yDirection+xDirection // rate of forward/backwards
        
        
        
        if(gesture.state == UIGestureRecognizerState.began){
            self.stopTimer()
        }
        else if(gesture.state == UIGestureRecognizerState.changed){
            self.duration += Double(rate/4)
            
            if(self.duration < 0 ){
                self.duration = 0
            }
            else if(self.duration >= progress){
                self.duration = progress
            }
        }
        else if(gesture.state == UIGestureRecognizerState.ended){
            self.startTimer()
        }
        
        
        gesture.setTranslation(CGPoint.zero, in: self)
    }
    
}



