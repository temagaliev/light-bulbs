//
//  GameViewController.swift
//  Light Bulbs
//
//  Created by Artem Galiev on 23.10.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    private let skScene: GameScene = SKScene(fileNamed: "GameScene") as! GameScene
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let skView = SKView(frame: view.frame)
        view.addSubview(skView)
        
        skScene.size = CGSize(width: view.frame.width, height: view.frame.height)
        skScene.scaleMode = .aspectFill
        skView.presentScene(skScene)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        skScene.startGame()
    }
}
