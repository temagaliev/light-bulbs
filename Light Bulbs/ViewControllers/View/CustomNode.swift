//
//  CustomNode.swift
//  Light Bulbs
//
//  Created by Artem Galiev on 25.10.2023.
//

import SpriteKit
import GameplayKit

class CustomNode: SKSpriteNode {
    var type: TypeNode
    var sizeNode: CGSize
    
    var rotation: Bool = false
    var connect: Bool = false
    var isRepeat: Bool = false
    var isPowered: Bool = false

    var canConnectTop: Bool = false
    var canConnectBottom: Bool = false
    var canConnectLeft: Bool = false
    var canConnectRight: Bool = false
    
    var stateNode: StateNode = .firstState
    var pathNode: String = ""
    
    var imageName: String = NameImage.firstNone.rawValue

    
    init(type: TypeNode, sizeNode: CGSize) {
        self.type = type
        self.sizeNode = sizeNode
        
        switch type {
        case .standard:
            canConnectTop = true
            canConnectBottom = true
            canConnectLeft = false
            canConnectRight = false
            imageName = NameImage.firstNone.rawValue
            
        case .crossroads:
            canConnectTop = true
            canConnectBottom = true
            canConnectLeft = true
            canConnectRight = true
            imageName = NameImage.secondNone.rawValue
            
        case .gShaped:
            canConnectTop = false
            canConnectBottom = true
            canConnectLeft = false
            canConnectRight = true
            imageName = NameImage.thirdNone.rawValue
            
        case .tShaped:
            canConnectTop = true
            canConnectBottom = false
            canConnectLeft = true
            canConnectRight = true
            imageName = NameImage.fourNone.rawValue

        }
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: .clear, size: sizeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTextureNodeAfterRotate(isNone: Bool) {
        if isNone {
            self.connect = false
            self.isRepeat = false
            switch self.type {
            case .standard:
                self.texture = SKTexture(imageNamed: NameImage.firstNone.rawValue)
            case .crossroads:
                self.texture = SKTexture(imageNamed: NameImage.secondNone.rawValue)
            case .gShaped:
                self.texture = SKTexture(imageNamed: NameImage.thirdNone.rawValue)
            case .tShaped:
                self.texture = SKTexture(imageNamed: NameImage.fourNone.rawValue)
            }
        } else {
            self.connect = true
            self.isRepeat = true
            switch self.type {
            case .standard:
                self.texture = SKTexture(imageNamed: NameImage.first.rawValue)
            case .crossroads:
                self.texture = SKTexture(imageNamed: NameImage.second.rawValue)
            case .gShaped:
                self.texture = SKTexture(imageNamed: NameImage.third.rawValue)
            case .tShaped:
                self.texture = SKTexture(imageNamed: NameImage.four.rawValue)
            }
        }
//        print("ОКРАШИВАНИЕ", self.connect )

    }

    
    func rotationNode() {
        switch type {
        case .standard:
            switch stateNode {
            case .firstState:
                canConnectTop = false
                canConnectBottom = false
                canConnectLeft = true
                canConnectRight = true
                stateNode = .secondState
            case .secondState:
                canConnectTop = true
                canConnectBottom = true
                canConnectLeft = false
                canConnectRight = false
                stateNode = .thirdState
            case .thirdState:
                canConnectTop = false
                canConnectBottom = false
                canConnectLeft = true
                canConnectRight = true
                stateNode = .fourState
            case .fourState:
                canConnectTop = true
                canConnectBottom = true
                canConnectLeft = false
                canConnectRight = false
                stateNode = .firstState
            }
        case .crossroads:
            canConnectTop = true
            canConnectBottom = true
            canConnectLeft = true
            canConnectRight = true
            
        case .gShaped :
            switch stateNode {
            case .firstState:
                canConnectTop = false
                canConnectBottom = true
                canConnectLeft = true
                canConnectRight = false
                stateNode = .secondState
            case .secondState:
                canConnectTop = true
                canConnectBottom = false
                canConnectLeft = true
                canConnectRight = false
                stateNode = .thirdState
            case .thirdState:
                canConnectTop = true
                canConnectBottom = false
                canConnectLeft = false
                canConnectRight = true
                stateNode = .fourState
            case .fourState:
                canConnectTop = false
                canConnectBottom = true
                canConnectLeft = false
                canConnectRight = true
                stateNode = .firstState
            }
        case .tShaped:
            switch stateNode {
            case .firstState:
                canConnectTop = true
                canConnectBottom = true
                canConnectLeft = false
                canConnectRight = true
                stateNode = .secondState
            case .secondState:
                canConnectTop = false
                canConnectBottom = true
                canConnectLeft = true
                canConnectRight = true
                stateNode = .thirdState
            case .thirdState:
                canConnectTop = true
                canConnectBottom = true
                canConnectLeft = true
                canConnectRight = false
                stateNode = .fourState
            case .fourState:
                canConnectTop = true
                canConnectBottom = false
                canConnectLeft = true
                canConnectRight = true
                stateNode = .firstState
            }
        }
        self.zRotation = self.zRotation + (-CGFloat.pi / 2)
    }
}
