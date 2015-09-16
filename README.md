# InteractivePlayerView

[![Join the chat at https://gitter.im/AhmettKeskin/InteractivePlayerView](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/AhmettKeskin/InteractivePlayerView?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Custom iOS music player view

# Screen

<img src="https://github.com/AhmettKeskin/InteractivePlayerView/blob/master/InteractivePlayerView/Screen.png"/>

### About
InteractivePlayerView is an IBDesignableView (Custom View) which has its own progress,cover image and action buttons.


## Installation
#### Directly
  [Download](https://github.com/AhmettKeskin/InteractivePlayerView/archive/master.zip) the project and copy the InteractivePlayerView folder into your project and then simply you can use it in any file

#### Using Cocoapods
```swift
use_frameworks!
pod 'InteractivePlayerView'
```

## Usage
- Add your view in storyboard
- Arrange your view's size square (It looks better this way)
- Set your view's class InteractivePlayerView
- Wait until it built in storyboard and set variables
- Then create your property of view and set it's delegate to self to use it's delegation methods and good to go !

``` swift
  @IBOutlet var ipv: InteractivePlayerView!
  
  // set delegation
  self.ipv!.delegate = self

  // duration of music
  self.ipv.progress = 120.0
  
  // start - stop player
  self.ipv.start()
  self.ipv.stop()

  /* InteractivePlayerViewDelegate METHODS */
    func actionOneButtonTapped(sender: UIButton, isSelected: Bool) {
        println("ActionOneButton tapped")
    }
    
    func actionTwoButtonTapped(sender: UIButton, isSelected: Bool) {
        println("ActionTwoButton tapped")
    }
    
    func actionThreeButtonTapped(sender: UIButton, isSelected: Bool) {
        println("ActionThreeButton tapped")

    }

```

## Useful Methods

``` swift
  // set progress colors
  self.ipv.progressEmptyColor = UIColor.yellowColor()
  self.ipv.progressFullColor = UIColor.redColor()

```
``` swift
  // get and set isSelected value of action buttons
  let isSelected = self.ipv.isActionOneSelected
  self.ipv.isActionOneSelected = true
```
```swift
  // Buttons are also square and setting one value to width and height is enough. And also you can set action button's images
  self.ipv.buttonSizes = 30.0

  self.ipv.actionOne_icon_selected = UIImage(named: "shuffle_selected.png")
  self.ipv.actionOne_icon_unselected = UIImage(named: "shuffle_unselected.png")

  self.ipv.coverImage = UIImage(named: "imagetest.png")

```


## Design

[Here is original design](https://www.pinterest.com/pin/400187116866664878/)

License
--------
InteractivePlayerView is released under the MIT license. See LICENSE for details.

