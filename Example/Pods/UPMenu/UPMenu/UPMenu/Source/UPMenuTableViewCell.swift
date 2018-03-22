//
//  UPMenuTableViewCell.swift
//  UPMenu
//
//  Created by Tubik Studio on 16/3/18.
//  Copyright © 2018 Tubik Studio. All rights reserved.
//

import UIKit

public class UPMenuTableViewCell: UITableViewCell {

    //MARK: - Properties

    static var reuseIdentifier: String {
        get {
            return String(describing: self.self)
        }
    }

    @IBOutlet private weak var menuItemTitleLabel: UILabel!

    //MARK: - Methods

    func configure(with menuItemTitle: String, menuAppearance: UPMenu.Appearance) {
        backgroundColor = menuAppearance.menuItemCellBackgroundColor
        menuItemTitleLabel.font = menuAppearance.menuItemCellTitleFont
        menuItemTitleLabel.text = menuItemTitle
    }

}
