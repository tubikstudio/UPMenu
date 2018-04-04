# UPMenu

Menu control from [Upper](https://uppertodo.com)

![Preview](https://github.com/tubikstudio/UPMenu/blob/master/demo.gif)

## Requirements

- iOS 10.0+
- Xcode 9
- Swift 4

## Installation

#### [CocoaPods](http://cocoapods.org)

```ruby
pod 'UPMenu'
```

#### Manual Installation

Add <b> Source </b> folder to your project, that's all.

### Usage

* If you install UPMenu from Cocoapods, be sure to import the module into your View Controller:

```swift
import UPMenu
```

* [Code] Create menu view, and set point, where it should be located:

```swift
let upMenu = UPMenu(frame: view.frame)
upMenu.startPoint = CGPoint(x: view.frame.width - 60, y: view.frame.height - 80)
view.addSubview(upMenu)
```

* [InterfaceBuilder] Add UIView, set it's class to `UPMenu`, create IBOutlet and update start point (look at Example project for more details):
```swift
@IBOutlet weak var upMenuFromStoryboard: UPMenu!

override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    upMenuFromStoryboard.startPoint = CGPoint(x: view.frame.width - 60, y: view.frame.height - 80)
}
```

* Set delegate and  implement `UPMenuDelegate` protocol to get notified about UPMenu events:

```swift
upMenu.delegate = self

extension ViewController: UPMenuDelegate {

    func upMenu(_ upMenu: UPMenu, didSelectMenuItemAt indexPath: IndexPath) {
        print("\(upMenu.menuItems[indexPath.row].title)")
    }

}
```

### Customisation

* Set menu items titles:

```swift
upMenu.updateMenuItems(with: menuItems)
```
`menuItems` should be array of `UPMenuItem` objects

* Set menu items list height:

```swift
upMenu.menuItemsListHeight = 217
```

* Set menu items cells backgorund color, font, text color:

```swift
upMenu.appearance.menuItemCellBackgroundColor = UIColor.black
upMenu.appearance.menuItemCellTitleFont = UIFont.systemFont(ofSize: 36)
upMenu.appearance.menuItemCellTitleColor = UIColor.black
```
* Set menu items cells height:

```swift
 upMenu.menuItemHeight = 80
```

* Set closed menu color:

```swift
upMenu.appearance.closedMenuColor = UIColor.white
```

* Set title view background color:

```swift
upMenu.appearance.titleViewBackgorundColor = UIColor.white
```

* Set menu items view background color:

```swift
upMenu.appearance.menuItemsViewBackgroundColor = UIColor.black
```

* Set custom title view:

```swift
let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 150)))
label.font = UIFont.systemFont(ofSize: 56)
label.textAlignment = .center
label.text = "🐶"

upMenu.addTitleView(label)
```

### Let us know!

We’d be really happy if you sent us links to your projects where you use our component. Just send an email to ios@tubikstudio.com And do let us know if you have any questions or suggestion regarding the animation. 

### License

MIT License

Copyright (c) 2018 Tubik Studio

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
