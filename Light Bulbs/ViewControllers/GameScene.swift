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
    var sizeNode: Int = 45
    
    var currentScore: Int = 0
    var maxScore: Int = 300
    
    var isUpdateEnd: Bool = false
    
    var arrayNodeCheck: [CustomNode] = []
    var arrayNodeDelete: [CustomNode] = []

    var gameVCDelegate: GameViewControllerDelegate?
    
    var timerValue: Int = 60
    var timer = Timer()
    
    override func didMove(to view: SKView) {
        backgraundNode = SKSpriteNode(color: SKColor.darkGray, size: CGSize(width: frame.width, height: frame.height))
        addChild(backgraundNode)
        view.scene?.delegate = self
    }
    
    //MARK: - Начало игры
    public func startGame() {
        currentScore = 0
        maxScore = 300
        timerValue = 60
        gameVCDelegate?.counterScoreValue(scoreValue: currentScore, maxValue: maxScore)
        createStartNode()
        
        for vertical in -heightGame...heightGame {
            let nodeCustom: CustomNode = self.atPoint(CGPoint(x: CGFloat(-widthGame * sizeNode), y: CGFloat(vertical) * CGFloat(sizeNode))) as! CustomNode
            recursionCheck(node: nodeCustom)
        }
        startTimer()
    }
    
    //MARK: - Создание игровых элементов
    private func createStartNode() {
        //Добавление элементов на поле
        for i in -heightGame...heightGame {
            for j in -widthGame...widthGame {
                let random = Int.random(in: 1...100)
                var type: TypeNode = .standard
                switch random {
                case 1...28:
                    type = .standard
                case 95...100:
                    type = .crossroads
                case 31...68:
                    type = .gShaped
                case 71...94:
                    type = .tShaped
                case 29...30:
                    type = .standardBonus
                case 69...70:
                    type = .gShapedBonus
                default:
                    type = .standard
                }
                
                let obstacleNode = CustomNode(type: type, sizeNode: CGSize(width: CGFloat(sizeNode), height: CGFloat(sizeNode)))
                obstacleNode.position = CGPoint(x: j * sizeNode, y: i * sizeNode)
                if j == -widthGame {
                    obstacleNode.pathNode = String(i + i + 1)
                }
                
                addChild(obstacleNode)
                
                let randomRotate = Int.random(in: 1...4)
                for _ in 0...randomRotate {
                    obstacleNode.rotationNode()
                }
                
                arrayNodeCheck.append(obstacleNode)

                
                //Добавление иконок лампочек и тока
                if j == -widthGame {
                    let nodeOne = SKSpriteNode(color: .blue, size: CGSize(width: 15, height: 15))
                    nodeOne.position = CGPoint(x: j * sizeNode + -(sizeNode - 5), y: i * sizeNode)
                    addChild(nodeOne)

                }
                if j == widthGame {
                    let nodeOne = SKSpriteNode(color: .red, size: CGSize(width: 15, height: 15))
                    nodeOne.position = CGPoint(x: j * sizeNode + (sizeNode - 5), y: i * sizeNode)
                    addChild(nodeOne)
                }
            }
        }
    }
    
    //MARK: - Обработка нажатия на элемент
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let node = self.atPoint(touchLocation) as! CustomNode
            //Вращение фигуры
            node.rotationNode()
            
            //Обновление переменных перед провекрой
            for nodeCheck in arrayNodeCheck {
                nodeCheck.connect = false
                nodeCheck.isPowered = false
                nodeCheck.updateTextureNodeAfterRotate(isNone: true)
            }
            
            //Запуск проверки
            for vertical in -heightGame...heightGame {
                let nodeCustom: CustomNode = self.atPoint(CGPoint(x: CGFloat(-widthGame * sizeNode), y: CGFloat(vertical) * CGFloat(sizeNode))) as! CustomNode
                recursionCheck(node: nodeCustom)
            }
        }
    }
    
    //MARK: - Рекурсивная проверка
    private func recursionCheck(node: CustomNode) {
        arrayNodeDelete.append(node)
        var isConnect = true
        while isConnect {
            //MARK: - Inside check
            if (node.position.y > CGFloat(-heightGame * sizeNode)) && (node.position.y < CGFloat(heightGame * sizeNode)) && (node.position.x > CGFloat(-widthGame * sizeNode)) && (node.position.x < CGFloat(widthGame * sizeNode)) {
                
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
            //MARK: - Bottom check
            } else if (node.position.y == CGFloat(-heightGame * sizeNode)) && (node.position.y < CGFloat(heightGame * sizeNode)) && (node.position.x > CGFloat(-widthGame * sizeNode)) && (node.position.x < CGFloat(widthGame * sizeNode)) {
                
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
            //MARK: - Top check
            } else if (node.position.y > CGFloat(-heightGame * sizeNode)) && (node.position.y == CGFloat(heightGame * sizeNode)) && (node.position.x > CGFloat(-widthGame * sizeNode)) && (node.position.x < CGFloat(widthGame * sizeNode)) {
                
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
            //MARK: - Right check
            } else if (node.position.x == CGFloat(widthGame * sizeNode)) {
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
                }
                //MARK: - Конец игры
                if isEnd {
                    isConnect = false
                    for node in arrayNodeDelete {
                        if node.type == .gShapedBonus || node.type == .standardBonus {
                            currentScore = currentScore + 10
                        } else {
                            currentScore = currentScore + 1
                        }
                        gameVCDelegate?.counterScoreValue(scoreValue: currentScore, maxValue: maxScore)
                        
                        let colorize = SKAction.colorize(with: .green, colorBlendFactor: 1, duration: 1)
                        node.run(colorize)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [weak self] in
                            guard let self = self else {return}
                            let position = node.position
                            node.removeFromParent()
                            for i in 0...arrayNodeCheck.count - 1 {
                                if arrayNodeCheck[i] == node {
                                    arrayNodeCheck.remove(at: i)
                                    break
                                }
                            }
                            
                            let random = Int.random(in: 1...100)
                            var type: TypeNode = .standard
                            switch random {
                            case 1...28:
                                type = .standard
                            case 95...100:
                                type = .crossroads
                            case 31...68:
                                type = .gShaped
                            case 71...94:
                                type = .tShaped
                            case 29...30:
                                type = .standardBonus
                            case 69...70:
                                type = .gShapedBonus
                            default:
                                type = .standard
                            }
                            
                            let obstacleNode = CustomNode(type: type, sizeNode: CGSize(width: CGFloat(self.sizeNode), height: CGFloat(self.sizeNode)))
                            obstacleNode.position = CGPoint(x: position.x, y: position.y)
                            addChild(obstacleNode)
                            
                            let randomRotate = Int.random(in: 1...4)
                            for _ in 0...randomRotate {
                                obstacleNode.rotationNode()
                            }
                            
                            arrayNodeCheck.append(obstacleNode)

                        })
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1050), execute: { [weak self] in
                        guard let self = self else {return}

                        //Обновление переменных перед провекрой
                        for nodeCheck in self.arrayNodeCheck {
                            nodeCheck.connect = false
                            nodeCheck.isPowered = false
                            nodeCheck.updateTextureNodeAfterRotate(isNone: true)
                        }
                        
                        //Запуск проверки
                        for vertical in -self.heightGame...self.heightGame {
                            let nodeCustom: CustomNode = self.atPoint(CGPoint(x: CGFloat(-self.widthGame * self.sizeNode), y: CGFloat(vertical) * CGFloat(self.sizeNode))) as! CustomNode
                            self.recursionCheck(node: nodeCustom)
                        }
                    })
                }

                isConnect = false
                
            //MARK: - Left check
            } else if (node.position.x == CGFloat(-widthGame * sizeNode)) {
                
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
        arrayNodeDelete.removeLast()
    }
    
    func startTimer() {

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)

        gameVCDelegate?.counterTimerValue(timerValue: timerValue)

    }
    
    @objc func countDown() {
        timerValue = timerValue - 1
        gameVCDelegate?.counterTimerValue(timerValue: timerValue)
        if timerValue == 0 {
            MainRouter.shared.showMenuViewScreen()
            timer.invalidate()
        }
    }
}

//MARK: - SKSceneDelegate
extension GameScene: SKSceneDelegate {
    override func update(_ currentTime: TimeInterval) {

    }
}

