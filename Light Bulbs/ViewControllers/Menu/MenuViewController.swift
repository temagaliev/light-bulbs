//
//  MenuViewController.swift
//  Light Bulbs
//
//  Created by Artem Galiev on 23.10.2023.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func onPlayButtonClick(_ sender: UIButton) {
        MainRouter.shared.showGameViewScreen()
    }
}
