//
//  ViewController.swift
//  Example
//
//  Created by Tubik Studio on 2/21/18.
//  Copyright © 2018 Tubik Studio. All rights reserved.
//

import UIKit
import UPMenu

class ViewController: UIViewController {

    @IBOutlet weak var upMenuFromStoryboard: UPMenu!

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 150)))
        label.font = UIFont.systemFont(ofSize: 56)
        label.textAlignment = .center
        label.text = "🐶"

//        upMenuFromStoryboard.startPoint = CGPoint(x: view.frame.width - 60, y: view.frame.height - 80)
        upMenuFromStoryboard.updateMenuItemsTitles(with: ["👤 Profile", "🎯 Activity", "⚙️ Settings"])
        upMenuFromStoryboard.addTitleView(label)

//        let upMenu = UPMenu(frame: view.frame)
//        upMenu.startPoint = CGPoint(x: view.frame.width - 60, y: view.frame.height - 80)
//        upMenu.delegate = self
//        upMenu.updateMenuItemsTitles(with: ["👤 Profile", "🎯 Activity", "⚙️ Settings"])
//
//
//        upMenu.addTitleView(label)
//
//        view.addSubview(upMenu)
    }

}

// MARK: - UPMenuDelegate

extension ViewController: UPMenuDelegate {

    func upMenu(_ upMenu: UPMenu, didSelectMenuItemAt indexPath: IndexPath) {
        print("\(upMenu.menuItemsTitles[indexPath.row])")
    }

}

