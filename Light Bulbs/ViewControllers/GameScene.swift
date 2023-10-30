//
//  GameScene.swift
//  Light Bulbs
//
//  Created by Artem Galiev on 23.10.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var backgraundNode = SKSpriteNode()
    
    var widthGame: Int = 3
    var heightGame: Int = 4
    var sizeNode: Int = 50
    var arrayNode: [CustomNode] = []
    var arrayNodeCheck: [CustomNode] = []
    
    override func didMove(to view: SKView) {
        backgraundNode = SKSpriteNode(color: SKColor.darkGray, size: CGSize(width: frame.width, height: frame.height))
        addChild(backgraundNode)
        view.scene?.delegate = self
    }
    
    //MARK: - Начало игры
    public func startGame() {
        createStartNode()
        
        for vertical in -heightGame...heightGame {
            let nodeC: CustomNode = self.atPoint(CGPoint(x: CGFloat(-widthGame * sizeNode), y: CGFloat(vertical) * CGFloat(sizeNode))) as! CustomNode
            recursionCheck(node: nodeC)
//            print(nodeC.position)

        }

    }
    
    private func createStartNode() {
        for i in -heightGame...heightGame {
            for j in -widthGame...widthGame {
                let random = Int.random(in: 1...100)
                var type: TypeNode = .standard
                switch random {
                case 1...30:
                    type = .standard
                case 90...100:
                    type = .crossroads
                case 31...60:
                    type = .gShaped
                case 61...89:
                    type = .tShaped
                default:
                    type = .standard
                }
                
                let obstacleNode = CustomNode(type: type, sizeNode: CGSize(width: CGFloat(sizeNode), height: CGFloat(sizeNode)))
                obstacleNode.position = CGPoint(x: j * sizeNode, y: i * sizeNode)
                if j == -widthGame {
                    obstacleNode.pathNode = String(i + i + 1)
                }
                arrayNodeCheck.append(obstacleNode)
                addChild(obstacleNode)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let node = self.atPoint(touchLocation) as! CustomNode
            node.rotationNode()
            for nodee in arrayNodeCheck {
                nodee.connect = false
                nodee.isPowered = false
                nodee.updateTextureNodeAfterRotate(isNone: true)
//                print(nodee.connect)
            }
            
//            recursionCheck(node: node)
//            print(node.position)
            for vertical in -heightGame...heightGame {
                let nodeC: CustomNode = self.atPoint(CGPoint(x: CGFloat(-widthGame * sizeNode), y: CGFloat(vertical) * CGFloat(sizeNode))) as! CustomNode
                recursionCheck(node: nodeC)
//                print(nodeC.position)

            }
//            
//            print("node.type - \(node.type), node.connect - \(node.connect), node.topConnect - \(node.canConnectTop), node.bottomConnect - \(node.canConnectBottom), node.leftConnect - \(node.canConnectLeft), node.rightConnect - \(node.canConnectRight) , node.path - \(node.pathNode)")
        }
    }
    
    private func recursionCheck(node: CustomNode) {
//        print("recursionCheck")
        var isConnect = true
        while isConnect {
            if (node.position.y > CGFloat(-heightGame * sizeNode)) && (node.position.y < CGFloat(heightGame * sizeNode)) && (node.position.x > CGFloat(-widthGame * sizeNode)) && (node.position.x < CGFloat(widthGame * sizeNode)) {
//                print("1")
                let nodeTop: CustomNode = self.atPoint(CGPoint(x: node.position.x, y: node.position.y + CGFloat(sizeNode))) as! CustomNode
                let nodeBottom: CustomNode = self.atPoint(CGPoint(x: node.position.x, y: node.position.y - CGFloat(sizeNode))) as! CustomNode
                let nodeLeft: CustomNode = self.atPoint(CGPoint(x: node.position.x - CGFloat(sizeNode), y: node.position.y)) as! CustomNode
                let nodeRight: CustomNode = self.atPoint(CGPoint(x: node.position.x + CGFloat(sizeNode), y: node.position.y)) as! CustomNode
                var isNone: Bool = true
                
                if nodeLeft.canConnectRight && nodeLeft.isPowered {
                    node.isPowered = true
                }
                if nodeTop.canConnectBottom && nodeTop.isPowered {
                    node.isPowered = true
                }
                if nodeBottom.canConnectTop && nodeBottom.isPowered {
                    node.isPowered = true
                }
                if nodeRight.canConnectLeft && nodeRight.isPowered {
                    node.isPowered = true
                }
                
                
                if node.canConnectLeft && nodeLeft.canConnectRight {
                    if nodeLeft.isPowered {
                        node.updateTextureNodeAfterRotate(isNone: false)
                        
                        isNone = false
                        node.isPowered = true
                    }

                    
                    if nodeLeft.connect == false && node.isPowered {
                        recursionCheck(node: nodeLeft)
                    }
                    
                    isConnect = false
                    
                }
                if node.canConnectRight && nodeRight.canConnectLeft {
                    if nodeRight.isPowered {
                        node.updateTextureNodeAfterRotate(isNone: false)
                        
                        isNone = false
                        node.isPowered = true
                    }

                    
                    if nodeRight.connect == false && node.isPowered {
                        recursionCheck(node: nodeRight)
                    }
                    
                    isConnect = false
                    
                }
                if node.canConnectTop && nodeTop.canConnectBottom {
                    if nodeTop.isPowered {
                        node.updateTextureNodeAfterRotate(isNone: false)
                        isNone = false
                        node.isPowered = true
                    }

                    
                    if nodeTop.connect == false && node.isPowered {
                        recursionCheck(node: nodeTop)
                    }
                    isConnect = false
                    
                }
                if node.canConnectBottom && nodeBottom.canConnectTop  {
                    if nodeBottom.isPowered {
                        node.updateTextureNodeAfterRotate(isNone: false)
                        isNone = false
                        node.isPowered = true
                    }

                    
                    if nodeBottom.connect == false && node.isPowered {
                        recursionCheck(node: nodeBottom)
                    }
                    isConnect = false
                    
                }
                if isNone {
                    node.updateTextureNodeAfterRotate(isNone: true)
                    isConnect = false
                    
                }
            } else if (node.position.y == CGFloat(-heightGame * sizeNode)) && (node.position.y < CGFloat(heightGame * sizeNode)) && (node.position.x > CGFloat(-widthGame * sizeNode)) && (node.position.x < CGFloat(widthGame * sizeNode)) {
//                print("2")
                
                let nodeTop: CustomNode = self.atPoint(CGPoint(x: node.position.x, y: node.position.y + CGFloat(sizeNode))) as! CustomNode
                let nodeLeft: CustomNode = self.atPoint(CGPoint(x: node.position.x - CGFloat(sizeNode), y: node.position.y)) as! CustomNode
                let nodeRight: CustomNode = self.atPoint(CGPoint(x: node.position.x + CGFloat(sizeNode), y: node.position.y)) as! CustomNode
                var isNone: Bool = true
                
                if nodeLeft.canConnectRight && nodeLeft.isPowered {
                    node.isPowered = true
                }
                if nodeTop.canConnectBottom && nodeTop.isPowered {
                    node.isPowered = true
                }

                if nodeRight.canConnectLeft && nodeRight.isPowered {
                    node.isPowered = true
                }
                
                if node.canConnectLeft && nodeLeft.canConnectRight {
                    if nodeLeft.isPowered {
                        node.updateTextureNodeAfterRotate(isNone: false)
                        isNone = false
                        node.isPowered = true
                    }

                    if nodeLeft.connect == false && node.isPowered {
                        recursionCheck(node: nodeLeft)
                    }
                    isConnect = false
                    
                }
                if node.canConnectRight && nodeRight.canConnectLeft  {
                    if nodeRight.isPowered {
                        node.updateTextureNodeAfterRotate(isNone: false)
                        isNone = false
                        node.isPowered = true
                    }

                    
                    if nodeRight.connect == false && node.isPowered {
                        recursionCheck(node: nodeRight)
                    }
                    isConnect = false
                    
                }
                if node.canConnectTop && nodeTop.canConnectBottom {
                    if nodeTop.isPowered {
                        node.updateTextureNodeAfterRotate(isNone: false)
                        isNone = false
                        node.isPowered = true
                    }
                    
                    if nodeTop.connect == false && node.isPowered {
                        recursionCheck(node: nodeTop)
                    }
                    isConnect = false
                    
                }
                
                if isNone {
                    node.updateTextureNodeAfterRotate(isNone: true)
                    isConnect = false
                    
                }
            } else if (node.position.y > CGFloat(-heightGame * sizeNode)) && (node.position.y == CGFloat(heightGame * sizeNode)) && (node.position.x > CGFloat(-widthGame * sizeNode)) && (node.position.x < CGFloat(widthGame * sizeNode)) {
//                print("3")
                
                let nodeBottom: CustomNode = self.atPoint(CGPoint(x: node.position.x, y: node.position.y - CGFloat(sizeNode))) as! CustomNode
                let nodeLeft: CustomNode = self.atPoint(CGPoint(x: node.position.x - CGFloat(sizeNode), y: node.position.y)) as! CustomNode
                let nodeRight: CustomNode = self.atPoint(CGPoint(x: node.position.x + CGFloat(sizeNode), y: node.position.y)) as! CustomNode
                var isNone: Bool = true
                
                if nodeLeft.canConnectRight && nodeLeft.isPowered {
                    node.isPowered = true
                }

                if nodeBottom.canConnectTop && nodeBottom.isPowered {
                    node.isPowered = true
                }
                if nodeRight.canConnectLeft && nodeRight.isPowered {
                    node.isPowered = true
                }
                
                if node.canConnectLeft && nodeLeft.canConnectRight {
                    if nodeLeft.isPowered {
                        node.isPowered = true
                        node.updateTextureNodeAfterRotate(isNone: false)
                        isNone = false
                    }

                    
                    if nodeLeft.connect == false && node.isPowered {
                        recursionCheck(node: nodeLeft)
                    }
                    isConnect = false
                    
                }
                if node.canConnectRight && nodeRight.canConnectLeft  {
                    if nodeRight.isPowered {
                        node.updateTextureNodeAfterRotate(isNone: false)
                        isNone = false
                        node.isPowered = true
                    }

                    
                    if nodeRight.connect == false && node.isPowered {
                        recursionCheck(node: nodeRight)
                    }
                    isConnect = false
                    
                }
                if node.canConnectBottom && nodeBottom.canConnectTop  {
                    if nodeBottom.isPowered {
                        node.updateTextureNodeAfterRotate(isNone: false)
                        isNone = false
                        node.isPowered = true
                    }

                    
                    if nodeBottom.connect == false && node.isPowered {
                        recursionCheck(node: nodeBottom)
                    }
                    isConnect = false
                    
                }
                
                if isNone {
                    node.updateTextureNodeAfterRotate(isNone: true)
                    isConnect = false
                    
                }
            } else if (node.position.x == CGFloat(widthGame * sizeNode)) {
//                print("4")
                var isEnd: Bool = false

                if (node.position.y == CGFloat(heightGame * sizeNode)) && isEnd == false {
                    let nodeBottom: CustomNode = self.atPoint(CGPoint(x: node.position.x, y: node.position.y - CGFloat(sizeNode))) as! CustomNode
                    let nodeLeft: CustomNode = self.atPoint(CGPoint(x: node.position.x - CGFloat(sizeNode), y: node.position.y)) as! CustomNode

                    var isNone: Bool = true
                    if nodeLeft.canConnectRight && nodeLeft.isPowered {
                        node.isPowered = true
                    }

                    if nodeBottom.canConnectTop && nodeBottom.isPowered {
                        node.isPowered = true
                    }

                    if node.canConnectLeft && nodeLeft.canConnectRight  {
                        if nodeLeft.isPowered {
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                            node.isPowered = true
                        }

                        
                        if node.canConnectRight {
                            isEnd = true
                        } else {
                            if nodeLeft.connect == false && node.isPowered {
                                recursionCheck(node: nodeLeft)
                                isConnect = false
                            }
                        }
                    }
                    if node.canConnectBottom && nodeBottom.canConnectTop  {
                        if nodeBottom.isPowered {
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                            node.isPowered = true
                        }

                        
                        if node.canConnectRight {
                            isEnd = true
                        } else {
                            if nodeBottom.connect == false && node.isPowered {
                                recursionCheck(node: nodeBottom)
                                isConnect = false
                            }
                        }
                    }
                    if isNone {
                        node.updateTextureNodeAfterRotate(isNone: true)
                    }
                } else if (node.position.y == CGFloat(-heightGame * sizeNode)) && isEnd == false  {
                    let nodeTop: CustomNode = self.atPoint(CGPoint(x: node.position.x, y: node.position.y + CGFloat(sizeNode))) as! CustomNode
                    let nodeLeft: CustomNode = self.atPoint(CGPoint(x: node.position.x - CGFloat(sizeNode), y: node.position.y)) as! CustomNode

                    var isNone: Bool = true
                    if nodeLeft.canConnectRight && nodeLeft.isPowered {
                        node.isPowered = true
                    }
                    if nodeTop.canConnectBottom && nodeTop.isPowered {
                        node.isPowered = true
                    }

                    if node.canConnectLeft && nodeLeft.canConnectRight  {
                        if nodeLeft.isPowered {
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                            node.isPowered = true
                        }

                        
                        if node.canConnectRight {
                            isEnd = true
                        } else {
                            if nodeLeft.connect == false && node.isPowered {
                                recursionCheck(node: nodeLeft)
                                isConnect = false
                            }
                        }
                    }
                    if node.canConnectTop && nodeTop.canConnectBottom {
                        if nodeTop.isPowered {
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                            node.isPowered = true
                        }

                        if node.canConnectRight {
                            isEnd = true
                        } else {
                            if nodeTop.connect == false && node.isPowered {
                                recursionCheck(node: nodeTop)
                                isConnect = false
                            }
                        }
                    }
                    if isNone {
                        node.updateTextureNodeAfterRotate(isNone: true)
                    }
                } else if isEnd == false  {
                    let nodeTop: CustomNode = self.atPoint(CGPoint(x: node.position.x, y: node.position.y + CGFloat(sizeNode))) as! CustomNode
                    let nodeBottom: CustomNode = self.atPoint(CGPoint(x: node.position.x, y: node.position.y - CGFloat(sizeNode))) as! CustomNode
                    let nodeLeft: CustomNode = self.atPoint(CGPoint(x: node.position.x - CGFloat(sizeNode), y: node.position.y)) as! CustomNode

                    var isNone: Bool = true
                    if nodeLeft.canConnectRight && nodeLeft.isPowered {
                        node.isPowered = true
                    }
                    if nodeTop.canConnectBottom && nodeTop.isPowered {
                        node.isPowered = true
                    }
                    if nodeBottom.canConnectTop && nodeBottom.isPowered {
                        node.isPowered = true
                    }

                    if node.canConnectLeft && nodeLeft.canConnectRight  {
                        if nodeLeft.isPowered {
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                            node.isPowered = true
                        }

                        if node.canConnectRight {
                            isEnd = true
                        } else {
                            if nodeLeft.connect == false && node.isPowered {
                                recursionCheck(node: nodeLeft)
                                isConnect = false
                            }
                        }
                    }
                    if node.canConnectTop && nodeTop.canConnectBottom {
                        if nodeTop.isPowered {
                            node.isPowered = true
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                        }

                        if node.canConnectRight {
                            isEnd = true
                        } else {
                            if nodeTop.connect == false && node.isPowered {
                                recursionCheck(node: nodeTop)
                                isConnect = false
                            }
                        }
                    }
                    if node.canConnectBottom && nodeBottom.canConnectTop  {
                        if nodeBottom.isPowered {
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                            node.isPowered = true
                        }

                        if node.canConnectRight {
                            isEnd = true
                        } else {
                            if nodeBottom.connect == false && node.isPowered {
                                recursionCheck(node: nodeBottom)
                                isConnect = false
                            }
                        }
                    }
                    if isNone {
                        node.updateTextureNodeAfterRotate(isNone: true)
                    }
                } else {
                    print("GAME END")
                }
                if isEnd {
                    print("GAME END1")

                }
                isConnect = false

            } else if (node.position.x == CGFloat(-widthGame * sizeNode)) {
//                print("5")
                if (node.position.y == CGFloat(heightGame * sizeNode)) {
                    let nodeBottom: CustomNode = self.atPoint(CGPoint(x: node.position.x, y: node.position.y - CGFloat(sizeNode))) as! CustomNode
                    let nodeRight: CustomNode = self.atPoint(CGPoint(x: node.position.x + CGFloat(sizeNode), y: node.position.y)) as! CustomNode

                    if nodeBottom.canConnectTop && nodeBottom.isPowered {
                        node.isPowered = true
                    }
                    if nodeRight.canConnectLeft && nodeRight.isPowered {
                        node.isPowered = true
                    }
                    
                    var isNone: Bool = true
                    if node.canConnectLeft  {
                        let nodeRight: CustomNode = self.atPoint(CGPoint(x: node.position.x + CGFloat(sizeNode), y: node.position.y)) as! CustomNode
                        node.updateTextureNodeAfterRotate(isNone: false)
                        node.isPowered = true
                        isNone = false

                        if nodeRight.canConnectLeft && node.canConnectRight {
                            if nodeRight.connect == false {
                                recursionCheck(node: nodeRight)
                            }
                        }
                        isConnect = false
                    }
                    
                    if node.canConnectRight && nodeRight.canConnectLeft  {
                        if nodeRight.isPowered  {
                            node.isPowered = true
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                        }
                        
                        if nodeRight.connect == false && node.isPowered {
                            recursionCheck(node: nodeRight)
                        }
                        isConnect = false
                    }
                    if node.canConnectBottom && nodeBottom.canConnectTop  {
                        if nodeBottom.isPowered {
                            node.isPowered = true
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                        }
                        
                        if nodeBottom.connect == false && node.isPowered {
                            recursionCheck(node: nodeBottom)
                        }
                        isConnect = false
                    }
                    
                    if isNone {
                        node.updateTextureNodeAfterRotate(isNone: true)
                    }
                } else if (node.position.y == CGFloat(-heightGame * sizeNode)) {
                    let nodeTop: CustomNode = self.atPoint(CGPoint(x: node.position.x, y: node.position.y + CGFloat(sizeNode))) as! CustomNode
                    let nodeRight: CustomNode = self.atPoint(CGPoint(x: node.position.x + CGFloat(sizeNode), y: node.position.y)) as! CustomNode
                    if nodeTop.canConnectBottom && nodeTop.isPowered {
                        node.isPowered = true
                    }

                    if nodeRight.canConnectLeft && nodeRight.isPowered {
                        node.isPowered = true
                    }
                    var isNone: Bool = true
                    
                    if node.canConnectLeft  {
                        let nodeRight: CustomNode = self.atPoint(CGPoint(x: node.position.x + CGFloat(sizeNode), y: node.position.y)) as! CustomNode
                        node.updateTextureNodeAfterRotate(isNone: false)
                        node.isPowered = true
                        isNone = false

                        if nodeRight.canConnectLeft && node.canConnectRight {
                            if nodeRight.connect == false {
                                recursionCheck(node: nodeRight)
                            }
                        }
                        isConnect = false
                    }
                    
                    if node.canConnectRight && nodeRight.canConnectLeft  {
                        if nodeRight.isPowered {
                            node.isPowered = true
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                        }

                        
                        if nodeRight.connect == false && node.isPowered {
                            recursionCheck(node: nodeRight)
                        }
                        isConnect = false
                    }
                    if node.canConnectTop && nodeTop.canConnectBottom {
                        if nodeTop.isPowered {
                            node.isPowered = true
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                        }

                        if nodeTop.connect == false && node.isPowered {
                            recursionCheck(node: nodeTop)
                        }
                        isConnect = false
                    }
                    if isNone {
                        node.updateTextureNodeAfterRotate(isNone: true)
                    }
                } else {
                    let nodeTop: CustomNode = self.atPoint(CGPoint(x: node.position.x, y: node.position.y + CGFloat(sizeNode))) as! CustomNode
                    let nodeBottom: CustomNode = self.atPoint(CGPoint(x: node.position.x, y: node.position.y - CGFloat(sizeNode))) as! CustomNode
                    let nodeRight: CustomNode = self.atPoint(CGPoint(x: node.position.x + CGFloat(sizeNode), y: node.position.y)) as! CustomNode
                    
                    var isNone: Bool = true

                    if nodeTop.canConnectBottom && nodeTop.isPowered {
                        node.isPowered = true
                    }
                    if nodeBottom.canConnectTop && nodeBottom.isPowered {
                        node.isPowered = true
                    }
                    if nodeRight.canConnectLeft && nodeRight.isPowered {
                        node.isPowered = true
                    }
                    
                    if node.canConnectLeft  {
                        let nodeRight: CustomNode = self.atPoint(CGPoint(x: node.position.x + CGFloat(sizeNode), y: node.position.y)) as! CustomNode
                        node.updateTextureNodeAfterRotate(isNone: false)
                        node.isPowered = true
                        isNone = false

                        if nodeRight.canConnectLeft && node.canConnectRight {
                            if nodeRight.connect == false {
                                recursionCheck(node: nodeRight)
                            }
                        }
                        isConnect = false
                    }
                    
                    if node.canConnectRight && nodeRight.canConnectLeft  {
                        if nodeRight.isPowered {
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                            node.isPowered = true
                        }

                        if nodeRight.connect == false && node.isPowered {
                            recursionCheck(node: nodeRight)
                        }
                        isConnect = false
                    }
                    if node.canConnectTop && nodeTop.canConnectBottom  {
                        if nodeTop.isPowered {
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                            node.isPowered = true
                        }

                        if nodeTop.connect == false && node.isPowered {
                            recursionCheck(node: nodeTop)
                        }
                        isConnect = false
                    }
                    if node.canConnectBottom && nodeBottom.canConnectTop  {
                        if nodeBottom.isPowered {
                            node.isPowered = true
                            node.updateTextureNodeAfterRotate(isNone: false)
                            isNone = false
                        }
                        
                        if nodeBottom.connect == false && node.isPowered {
                            recursionCheck(node: nodeBottom)
                        }
                        isConnect = false
                    }
                    if isNone {
                        node.updateTextureNodeAfterRotate(isNone: true)
                        isConnect = false

                    }
                }
                isConnect = false
            } else {
                isConnect = false
                break
            }
        }
    }
}

//MARK: - SKSceneDelegate
extension GameScene: SKSceneDelegate {
    override func update(_ currentTime: TimeInterval) {

    }
}

