<p align="center">
<img src="https://pp.userapi.com/c604720/v604720888/37813/os4AzOREBAY.jpg" width="600px"></img>
</p>

<p align="center">
    <img src="https://img.shields.io/badge/platform-iOS9%2B-blue.svg?style=flat" alt="Platform: iOS 9+" />
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift3-f48041.svg?style=flat" alt="Language: Swift 3" /></a>
    <a href="https://cocoapods.org/pods/AwesomeSpotlightView"><img src="https://cocoapod-badges.herokuapp.com/v/AwesomeSpotlightView/badge.png" alt="Cocoapods compatible" /></a>
    <img src="https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat" alt="License: MIT" />
</p>
 

AwesomeSpotlightView is a nice and simple libriary for iOS written on Swift 3. It's highly customizable and easy-to-use tool. Works perfectly for tutorial or coach in your app. 

![icon](https://s8.hostingkartinok.com/uploads/images/2017/06/2de205e60758e2d620c8a9a4621f9e75.gif)

![icon](https://s8.hostingkartinok.com/uploads/images/2017/06/0bb7ff8437aac08c335f1074ef990d4e.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation
### CocoaPods
AwesomeSpotlightView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AwesomeSpotlightView', '~> 0.1.2'
```
### Manually

* Just drop AwesomeSpotlightView folder in your project.
* You're ready to use AwesomeSpotlightView!

## Usage

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    let spotlight1 = AwesomeSpotlight(withRect: CGRect(x: 75, y: 75, width: 100, height: 100), shape: .circle, text: "spotlight1")
    let spotlight2 = AwesomeSpotlight(withRect: CGRect(x: 20, y: 200, width: 130, height: 25), shape: .rectangle, text: "spotlight2")
    let spotlight3 = AwesomeSpotlight(withRect: CGRect(x: 170, y: 50, width: 30, height: 100), shape: .roundRectangle, text: "spotlight3")
    
    let spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [spotlight1, spotlight2, spotlight3])
    spotlightView.cutoutRadius = 8
    spotlightView.delegate = self
    view.addSubview(spotlightView)
    spotlightView.start()
}
```

You can configure AwesomeSpotlightView before you present it using the `start` method. For example:

```objective-c
spotlightView.enableContinueLabel = false
spotlightView.enableSkipButton = false
spotlightView.showAllSpotlightsAtOnce = false
spotlightView.isAllowPassTouchesThroughSpotlight = true
spotlightView.start()
```

## Configuration AwesomeSpotlight

### `rect` (CGRect)

The rect of spotlight.

### `shape` (AwesomeSpotlightShape)

Shape of spotlight: .Rectangle, .RoundRectangle, .Circle.

### `margin` (UIEdgeInsets)

Margin for cutout shape. You can set extra space for item with this property.

### `text` (String)

The text of the caption.

### `attributedText` (AttributedString)

The attributed text of the caption.

## Configuration AwesomeSpotlightView

### `spotlightsArray` ([AwesomeSpotlight])

Modify the spotlights.

### `spotlightMaskColor` (UIColor)

The color of the mask (default: 0,0,0 alpha 0.6).

### `animationDuration` (Double)

Transition animation duration to the next coach mark (default: 0.3).

### `cutoutRadius` (CGFloat)

The cutout rectangle radius (default: 4.0).

### `maxLabelWidth` (Double)

The captions label is set to have a max width of 280px. Number of lines is figured out automatically based on caption contents.

### `labelSpacing` (CGFloat)

Define how far the captions label appears above or below the cutout (default: 35px).

### `enableContinueLabel` (Bool)

'Tap to continue' label pops up by default to guide the user at the first spotlight (default: false).

### `enableSkipButton` (Bool)

'Skip' label pops up by default to guide the user at the first spotlight (default: false).

### `enableArrowDown` (Bool)

Icon with Arrow showed between caption text and caption (default: false).

### `textLabelFont` (UIFont)

Fond of caption text label (default: UIFont.systemFont(ofSize: 20.0)).

### `continueLabelFont` (UIFont)

Fond of continue label (default: UIFont.systemFont(ofSize: 13.0)).

### `skipButtonFont` (UIFont)

Fond of skip button (default: UIFont.boldSystemFont(ofSize: 13.0)).

### `showAllSpotlightsAtOnce` (Bool)

Showed all spotlight at once (at the same time) (default: false).

### `isAllowPassTouchesThroughSpotlight` (Bool)

Set true if you want to allow pass touches through spotlight (allow interaction with view below spotlight) (default: false).

## AwesomeSpotlightViewDelegate

### 1. Conform your view controller to the AwesomeSpotlightViewDelegate protocol:

`class ViewController: UIViewController, AwesomeSpotlightViewDelegate`

### 2. Assign the delegate to your AwesomeSpotlightView view instance:

`spotlightView.delegate = self`

### 3. Implement the delegate protocol methods:

*Note: All of the methods are optional. Implement only those that are needed.*

- `func spotlightView(_ spotlightView: AwesomeSpotlightView, willNavigateToIndex index: Int)`
- `func spotlightView(_ spotlightView: AwesomeSpotlightView, didNavigateToIndex index: Int)`
- `func spotlightViewWillCleanup(_ spotlightView: AwesomeSpotlightView, atIndex index: Int)`
- `func spotlightViewDidCleanup(_ spotlightView: AwesomeSpotlightView)`

## Inspired by
* [WSCoachMarksView](https://github.com/workshirt/WSCoachMarksView)

## Author
* [Aleksandr Shoshiashvili](https://github.com/aleksandrshoshiashvili)
