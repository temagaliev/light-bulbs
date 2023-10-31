//
//  GameViewController.swift
//  Light Bulbs
//
//  Created by Artem Galiev on 23.10.2023.
//

import UIKit
import SpriteKit
import GameplayKit

protocol GameViewControllerDelegate {
    func counterScoreValue(scoreValue: Int, maxValue: Int)
    func counterTimerValue(timerValue: Int)

}

extension GameViewController: GameViewControllerDelegate {
    
    func counterScoreValue(scoreValue: Int, maxValue: Int) {
        scoreLabel.text = String(scoreValue) + "/" +  String(maxValue)
    }
    func counterTimerValue(timerValue: Int) {
        timerLabel.text = String(timerValue)
    }

}

class GameViewController: UIViewController {
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let skScene: GameScene = SKScene(fileNamed: "GameScene") as! GameScene
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let skView = SKView(frame: view.frame)
        view.addSubview(skView)
        
        skScene.size = CGSize(width: view.frame.width, height: view.frame.height)
        skScene.scaleMode = .aspectFill
        skView.presentScene(skScene)
        
        view.addSubview(timerLabel)
        
        timerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        timerLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        timerLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        
//        timerLabel.text = "55"
        
        view.addSubview(scoreLabel)
        
        scoreLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 16).isActive = true
        scoreLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        scoreLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
//        scoreLabel.text = "1000/5000"

        skScene.gameVCDelegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        skScene.startGame()
    }
}
