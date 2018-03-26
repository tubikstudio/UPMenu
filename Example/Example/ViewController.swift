//
//  ViewController.swift
//  Example
//
//  Created by Tubik Studio on 2/21/18.
//  Copyright © 2018 Tubik Studio. All rights reserved.
//

import UIKit
import UPMenu

struct RecipeAppMenuItem: UPMenuItem {
    var image: UIImage?
    var title: String?
}

class ViewController: UIViewController {

    @IBOutlet private weak var shadowImage: UIImageView!
    @IBOutlet private weak var upMenuFromStoryboard: UPMenu!

    private let menuItems = [RecipeAppMenuItem(image: UIImage(named: "recipe_icon"), title: "Recipes"),
                             RecipeAppMenuItem(image: UIImage(named: "favorite_icon"), title: "Favorite"),
                             RecipeAppMenuItem(image: UIImage(named: "shoplist_icon"), title: "Shoplist"),
                             RecipeAppMenuItem(image: UIImage(named: "profile_icon"), title: "Profile")]

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        upMenuFromStoryboard.delegate = self
        upMenuFromStoryboard.appearance.menuImage = UIImage(named: "hamburger_icon")
        upMenuFromStoryboard.appearance.closedMenuColor = UIColor(red: 212/255.0, green: 57/255.0, blue: 71/255.0, alpha: 1)
        upMenuFromStoryboard.appearance.closeMenuImage = UIImage(named: "close_icon")
        upMenuFromStoryboard.appearance.menuItemsViewBackgroundColor = UIColor.white
        upMenuFromStoryboard.appearance.menuItemCellTitleFont = UIFont(name: "Futura-Medium", size: 23) ?? UIFont.systemFont(ofSize: 23)
        upMenuFromStoryboard.appearance.menuItemCellBackgroundColor = UIColor.white
        upMenuFromStoryboard.appearance.menuItemCellTitleColor = UIColor.black
        upMenuFromStoryboard.menuItemsListHeight = 344
        upMenuFromStoryboard.menuItemHeight = 80
        upMenuFromStoryboard.updateMenuItems(with: menuItems)
        upMenuFromStoryboard.addTitleView(Bundle.main.loadNibNamed("MenuTitleView", owner: self, options: nil)?.first as! UIView)

    }

}

// MARK: - UPMenuDelegate

extension ViewController: UPMenuDelegate {

    func upMenuWillAppear() {
        UIView.animate(withDuration: 0.3, animations: {
            self.shadowImage.alpha = 0
        })
    }

    func upMenuDidClosed() {
        UIView.animate(withDuration: 0.3, animations: {
            self.shadowImage.alpha = 1
        })
    }

    func upMenu(_ upMenu: UPMenu, didSelectMenuItemAt indexPath: IndexPath) {
        print("\(upMenu.menuItems[indexPath.row].title ?? "")")
    }

}

