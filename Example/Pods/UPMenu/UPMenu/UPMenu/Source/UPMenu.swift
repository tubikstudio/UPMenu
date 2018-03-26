//
//  UPMenu.swift
//  UPMenu
//
//  Created by Tubik Studio on 16/3/18.
//  Copyright © 2018 Tubik Studio. All rights reserved.
//

import UIKit

public protocol UPMenuDelegate: class {

    func upMenu(_ upMenu: UPMenu, didTapOnHamburgerButton sender: UIButton)
    func upMenu(_ upMenu: UPMenu, didTapOnCloseButton sender: UIButton)
    func upMenu(_ upMenu: UPMenu, didSelectMenuItemAt indexPath: IndexPath)
    func upMenuWillAppear()
    func upMenuDidAppear()
    func upMenuWillClose()
    func upMenuDidClosed()

}

public extension UPMenuDelegate {

    func upMenu(_ upMenu: UPMenu, didTapOnHamburgerButton sender: UIButton) {}
    func upMenu(_ upMenu: UPMenu, didTapOnCloseButton sender: UIButton) {}
    func upMenu(_ upMenu: UPMenu, didSelectMenuItemAt indexPath: IndexPath) {}
    func upMenuWillAppear() {}
    func upMenuDidAppear() {}
    func upMenuWillClose() {}
    func upMenuDidClosed() {}

}

@IBDesignable public class UPMenu: UIView {

    public struct Appearance {
        public var menuImage: UIImage?
        public var closeMenuImage: UIImage?
        public var closedMenuColor = UIColor.white
        public var titleViewBackgorundColor = UIColor.white
        public var menuItemsViewBackgroundColor = UIColor.black
        public var menuItemCellBackgroundColor = UIColor.black
        public var menuItemCellTitleFont = UIFont.systemFont(ofSize: 24)
        public var menuItemCellTitleColor = UIColor.white
    }

    private struct Constants {
        static let closedMenuSize = CGSize(width: 57, height: 57)
        static let hamburgerButtonSize = CGSize(width: 24, height: 20)
    }

    private enum MenuState {
        case closed, expanded

        var image: UIImage? {
            switch self {
            case .closed:
                return UIImage(named: "closeIcn", in: Bundle(for: UPMenu.self), compatibleWith: nil)
            case .expanded:
                return UIImage(named: "menuIcn", in: Bundle(for: UPMenu.self), compatibleWith: nil)
            }
        }
    }

    // MARK: - Properties

    public weak var delegate: UPMenuDelegate?

    public private(set) var menuItems = [UPMenuItem]()

    public var menuItemsListHeight: CGFloat = 217 {
        didSet {
            menuItemsContainerHeightConstraint.constant = menuItemsListHeight
            layoutIfNeeded()
        }
    }

    public var menuItemHeight: CGFloat = 44

    public var appearance = Appearance() {
        didSet {
            updateAppearance(for: self.menuState)
        }
    }

    public var startPoint: CGPoint? {
        didSet {
            center = startPoint ?? superview?.center ?? .zero
        }
    }

    @IBOutlet public private(set) weak var hamburgerMenuButton: UIButton!

    @IBOutlet public private(set) weak var closeButton: UIButton!

    @IBOutlet private weak var mainContentView: UIView!
    @IBOutlet private weak var menuItemsContainerView: UIView!
    @IBOutlet private weak var hamburgerMenuButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var hamburgerMenuButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var menuItemsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    private let maskLayer = CALayer()
    private var isGoingToHide: Bool = false
    private var menuState: MenuState = .closed
    private var animating: Bool = false

    // MARK: - UIView

    public override init(frame: CGRect) {
        super.init(frame: frame)

        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        xibSetup()
    }

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if menuState == .expanded {
            return true
        } else {
            return maskLayer.frame.contains(point)
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if !animating {
            setupInitialMask()
        }
    }

    // MARK: - Methods

    public func addTitleView(_ titleView: UIView) {
        mainContentView.subviews.forEach { $0.removeFromSuperview() }
        mainContentView.addSubview(titleView)

        titleView.translatesAutoresizingMaskIntoConstraints = false

        mainContentView.addConstraint(NSLayoutConstraint(item: titleView,
                                                         attribute: .trailing,
                                                         relatedBy: .equal,
                                                         toItem: mainContentView,
                                                         attribute: .trailing,
                                                         multiplier: 1,
                                                         constant: 0))

        mainContentView.addConstraint(NSLayoutConstraint(item: titleView,
                                                         attribute: .leading,
                                                         relatedBy: .equal,
                                                         toItem: mainContentView,
                                                         attribute: .leading,
                                                         multiplier: 1,
                                                         constant: 0))

        mainContentView.addConstraint(NSLayoutConstraint(item: titleView,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: mainContentView,
                                                         attribute: .top,
                                                         multiplier: 1,
                                                         constant: 0))

        mainContentView.addConstraint(NSLayoutConstraint(item: titleView,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: mainContentView,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: 0))
        mainContentView.subviews.forEach {
            $0.isHidden = menuState == .closed
        }
    }

    public func updateMenuItems(with newItems: [UPMenuItem]) {
        menuItems = newItems
        tableView.reloadData()
    }

    public func expand() {
        guard let superView = self.superview else { return }
        superView.isUserInteractionEnabled = false
        delegate?.upMenuWillAppear()
        if startPoint == nil {
            startPoint = center
        }
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseIn, .curveEaseOut],
                       animations: {
                        self.animating = true
                        self.hamburgerMenuButtonWidthConstraint.constant = 0
                        self.hamburgerMenuButton.alpha = 0
                        self.tableViewTopConstraint.constant = superView.bounds.height
                        self.layoutIfNeeded()
        },
                       completion: { finished in
                        guard finished else { return }
                        UIView.animate(withDuration: 0.2,
                                       delay: 0,
                                       options: [.curveEaseIn, .curveEaseOut],
                                       animations: {
                                        self.center = CGPoint(x: superView.center.x, y: superView.center.y + 80)
                        },
                                       completion: { finished in
                                        guard finished else { return }
                                        self.updateAppearance(for: .expanded)
                                        self.mainContentView.subviews.forEach {
                                            $0.isHidden = false
                                        }
                                        UIView.animate(withDuration: 0.3,
                                                       delay: 0,
                                                       options: [.curveEaseIn, .curveEaseOut],
                                                       animations: {
                                                        self.tableViewTopConstraint.constant = 0
                                                        self.maskLayer.bounds = CGRect(x: 0, y: 0, width: 1600, height: 1600)
                                                        self.center = CGPoint(x: superView.center.x, y: superView.center.y + 5)
                                                        self.layoutIfNeeded()
                                        },
                                                       completion: { finished in
                                                        guard finished else { return }
                                                        UIView.animate(withDuration: 0.2,
                                                                       animations: {
                                                                        self.center = superView.center
                                                        },
                                                                       completion: { finished in
                                                                        guard finished else { return }
                                                                        self.animating = false
                                                                        superView.isUserInteractionEnabled = true
                                                                        self.menuState = .expanded
                                                                        self.delegate?.upMenuDidAppear()
                                                        })
                                        })
                        })

        })
    }

    public func close() {
        guard let superView = self.superview else { return }
        self.animating = true
        superView.isUserInteractionEnabled = false
        delegate?.upMenuWillClose()
        isGoingToHide = true

        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: {
                        self.maskLayer.bounds = CGRect(origin: .zero, size: Constants.closedMenuSize)
                        self.tableViewTopConstraint.constant = superView.bounds.height
                        self.layoutIfNeeded()
                        self.mainContentView.subviews.forEach {
                            $0.isHidden = true
                        }
        },
                       completion: { finished in
                        self.updateAppearance(for: .closed)
                        guard finished else { return }
                        UIView.animate(withDuration: 0.2,
                                       delay: 0,
                                       options: [.curveEaseIn, .curveEaseOut],
                                       animations: {
                                        self.center = self.startPoint ?? superView.center
                        },
                                       completion: { finished in
                                        guard finished else { return }
                                        UIView.animate(withDuration: 0.1,
                                                       delay: 0,
                                                       options: [.curveEaseIn, .curveEaseOut],
                                                       animations: {
                                                        self.rotate(degrees: -180)
                                                        self.hamburgerMenuButtonHeightConstraint.constant = Constants.hamburgerButtonSize.height
                                                        self.hamburgerMenuButtonWidthConstraint.constant = Constants.hamburgerButtonSize.width
                                                        self.hamburgerMenuButton.alpha = 1
                                                        self.layoutIfNeeded()
                                        },
                                                       completion: { finished in
                                                        guard finished else { return }
                                                        self.rotate(degrees: -180)
                                                        self.animating = false
                                                        self.isGoingToHide = false
                                                        superView.isUserInteractionEnabled = true
                                                        self.menuState = .closed
                                                        self.delegate?.upMenuDidClosed()
                                        })
                        })
        })
    }

    @IBAction private func touchUpInsideHamburgerMenuButton(_ sender: UIButton) {
        delegate?.upMenu(self, didTapOnHamburgerButton: sender)
        expand()
    }

    @IBAction private func touchUpInsideCloseButton(_ sender: UIButton) {
        delegate?.upMenu(self, didTapOnCloseButton: sender)
        close()
    }

    private func xibSetup() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        closeButton.isExclusiveTouch = true
        tableView.register(UINib(nibName: "UPMenuTableViewCell", bundle: Bundle(for: UPMenu.self)),
                           forCellReuseIdentifier: UPMenuTableViewCell.reuseIdentifier)
        updateAppearance(for: menuState)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: UPMenu.self)
        let nib = UINib(nibName: String(describing: UPMenu.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    private func setupInitialMask() {
        maskLayer.contents =  UIImage(named: "menu", in: Bundle(for: UPMenu.self), compatibleWith: nil)?.cgImage
        maskLayer.frame = CGRect(origin: .zero, size: Constants.closedMenuSize)
        maskLayer.position = CGPoint(x: frame.size.width/2.0, y: frame.size.height/2.0)
        layer.mask = maskLayer
    }

    private func rotate(degrees: CGFloat) {
        let radians =  degrees / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }

    private func updateAppearance(for menuState: MenuState) {
        mainContentView.backgroundColor = menuState == .closed ? appearance.closedMenuColor : appearance.titleViewBackgorundColor
        menuItemsContainerView.backgroundColor = menuState == .closed ? appearance.closedMenuColor : appearance.menuItemsViewBackgroundColor
        tableView.isHidden = menuState == .closed
        closeButton.setImage(appearance.closeMenuImage ?? MenuState.closed.image, for: .normal)
        hamburgerMenuButton.setImage(appearance.menuImage ?? MenuState.expanded.image, for: .normal)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension UPMenu: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return menuItemHeight
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.upMenu(self, didSelectMenuItemAt: indexPath)
    }

}

// MARK: - UITableViewDataSource

extension UPMenu: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UPMenuTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! UPMenuTableViewCell

        cell.configure(menuItemImage: menuItems[indexPath.row].image,
                       menuItemTitle: menuItems[indexPath.row].title,
                       menuAppearance: appearance)

        return cell
    }

}
