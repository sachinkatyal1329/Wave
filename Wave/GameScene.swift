 //
//  GameScene.swift
//  Wave
//
//  Created by Sachin Katyal on 6/4/18.
//  Copyright © 2018 Sachin Katyal. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var firstTouch: CGPoint!
    var movedTouch: CGPoint!
    var moved = false
    var hero : Hero!
    
    var score: CGFloat = 0
    var label: UILabel!
    var highScoreLabel: UILabel!
    var highLabel: UILabel!
    var scoreLabel: UILabel!
    
    var joyStickCounter = 0

    var inContact = false
    
    var gameOver = false
    
    var restartButton: UIButton!
    var joyStick: SKShapeNode!
    var basicEnemy: Enemy!
     var enemiess = Set<Enemy>()
    var entityManager: EntityManager!
    var fileWriter: FileWriter!

    
    override func didMove(to view: SKView) {
        
        fileWriter = FileWriter()
        
        prepareScene()
        
        addScore()
      
        gameOver = true
        loadPlayButton()
        
        entityManager.addStartingEntities()


    }
    
    
    func prepareScene() {
        entityManager = EntityManager(game: self)
        
        
        if #available(iOS 10.0, *) {
            self.view?.preferredFramesPerSecond = 60
        } else {
            self.view?.preferredFramesPerSecond = 45
        }
        
        physicsWorld.contactDelegate = self
        
       
        let background = SKSpriteNode(imageNamed: "whitesquare")
        background.normalTexture = SKTexture(imageNamed: "BGN")
        background.position = CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0)
        background.size = CGSize(width: self.frame.width + 20, height: self.frame.height + 20)
        background.lightingBitMask = 2 // Receives Light from "bgLight" in the Hero Class
  

        
        addChild(background)
  
        backgroundColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1.0)

        
    }
    
    func loadPlayButton() {
        restartButton = UIButton()
        restartButton.frame = CGRect(x: (self.view?.frame.size.width)!/2 - 65, y: (self.view?.frame.size.height)!/2 + 30, width: 130, height: 60)
        restartButton.backgroundColor = UIColor(red: 213/255.0, green: 107/255.0, blue: 130/255.0, alpha: 1.0)
        restartButton.layer.cornerRadius = 5
        restartButton.setTitle("PLAY", for: .normal)
        restartButton.titleLabel?.font = UIFont(name:
            "BulletproofBB" , size: 24)!
        restartButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        self.view?.addSubview(restartButton)
    }
    
    
    func start() {
        restartButton.removeFromSuperview()
        gameOver = false
    }
    
    
    func addJoyStick(location: CGPoint) {
        joyStick = SKShapeNode(circleOfRadius: 20 ) // Size of Circle
        joyStick.fillColor = SKColor.gray
        joyStick.position = location
        addChild(joyStick)
    }
    
    func GameOver() {
        gameOver = true
        restartButton = UIButton()
        restartButton.frame = CGRect(x: (self.view?.frame.size.width)!/2 - 65, y: (self.view?.frame.size.height)!/2 + 30, width: 130, height: 60)
        restartButton.backgroundColor = UIColor(red: 213/255.0, green: 107/255.0, blue: 130/255.0, alpha: 1.0)
        restartButton.layer.cornerRadius = 5
        restartButton.setTitle("PLAY", for: .normal)
        restartButton.titleLabel?.font = UIFont(name:
            "BulletproofBB" , size: 24)!
        restartButton.addTarget(self, action: #selector(Restart), for: .touchUpInside)
        self.view?.addSubview(restartButton)
        
        scoreLabel = UILabel()
        scoreLabel.frame = CGRect(x: (self.view?.frame.width)!/2 - 100, y: 60, width: 200, height: 30)
        scoreLabel.textColor = UIColor.white
        scoreLabel.textAlignment = NSTextAlignment.center
        scoreLabel.text = "SCORE"
        scoreLabel.font = UIFont(name: "BulletproofBB" , size: 20)!
        self.view?.addSubview(scoreLabel)
        
        label.frame = CGRect(x: (self.view?.frame.width)!/2 - 100, y: 80, width: 200, height: 40)
        label.font = UIFont(name:
            "BulletproofBB" , size: 37)!
        self.view?.addSubview(label)
        
        highLabel = UILabel()
        highLabel.frame = CGRect(x: (self.view?.frame.width)!/2 - 100, y: 130, width: 200, height: 30)
        highLabel.textColor = UIColor.white
        highLabel.textAlignment = NSTextAlignment.center
        highLabel.text = "HIGH SCORE"
        highLabel.font = UIFont(name: "BulletproofBB" , size: 20)!
        self.view?.addSubview(highLabel)
        
        highScoreLabel = UILabel()
        highScoreLabel.frame = CGRect(x: (self.view?.frame.width)!/2 - 100, y: 150, width: 200, height: 40)
        highScoreLabel.textColor = UIColor.white
        highScoreLabel.textAlignment = NSTextAlignment.center
        let highScore: Int = Int(fileWriter.read())
        let viewHighScore: CGFloat = CGFloat(highScore) / 10
        highScoreLabel.text = "\(Int(viewHighScore.rounded(toPlaces: 0)))"
        highScoreLabel.font = UIFont(name:
            "BulletproofBB" , size: 37)!
        self.view?.addSubview(highScoreLabel)
        
    }
    
    func Restart(sender: UIButton!) {
        self.view?.preferredFramesPerSecond = 60
        
        hero.removeFromParent()
        hero.health = 100
        inContact = false
        
        for enemy in entityManager.enemies {
            enemy.removeFromParent()
            entityManager.enemies.remove(enemy)
        }
        
        
        gameOver = false
       
        highScoreLabel.removeFromSuperview()
        highLabel.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        label.frame = CGRect(x: (self.view?.frame.width)! - 200, y: 20, width: 200, height: 30)
        label.font = UIFont(name:
            "BulletproofBB" , size: 27)!
        label.textColor = UIColor.white
        

        
        entityManager.addStartingEntities()
        
        if fileWriter.read() < CGFloat(score) { //New High Score
            fileWriter.write(text: String(Float(score)))
            highScoreLabel.text = "\(Int(fileWriter.read()))"
        }
        
        score = 0
        sender.removeFromSuperview()
        
        

    }
    
    func addScore() {
        label = UILabel()
        label.frame = CGRect(x: (self.view?.frame.width)! - 200, y: 20, width: 200, height: 30)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        let viewScore = CGFloat(score) / 10
        label.text = String(Int(viewScore.rounded(toPlaces: 0)))
        label.font = UIFont(name:
            "BulletproofBB" , size: 27)!
        self.view?.addSubview(label)
        
    }
    
    func increaseScore() {
        score += 1
        let viewScore = score/10
        label.text = String(Int(viewScore.rounded(toPlaces: 0)))
    }
    
    
    func addFog(x: CGFloat, y: CGFloat) {
        let fog = SKSpriteNode(imageNamed: "blur.png")
        fog.position = CGPoint(x: x, y: y)
        fog.size = CGSize(width: 500, height : 500)
        fog.zPosition = 2
        addChild(fog)
    }

    
    
    
    
    //OVERRIDE CLASSES START HERE
    func didBegin(_ contact: SKPhysicsContact) {
        inContact = true
        print("Begin Contact")
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        inContact = false
        print("end Contact")
    }
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if joyStickCounter < 1 {
            let touch = touches.first!
            let location = touch.location(in: self)
            firstTouch = CGPoint(x: location.x, y: location.y)
            addJoyStick(location: firstTouch)
            joyStickCounter += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        movedTouch = touch?.location(in: self)
        moved = true
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moved = false
        movedTouch = nil
        firstTouch = nil
        hero.velx = 0.0
        hero.vely = 0.0
    
        joyStick.removeFromParent()
        joyStickCounter -= 1
        
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //joyStick.position = CGPoint(x: -40, y: -40)
        joyStick.removeFromParent()
        joyStickCounter -= 1
        print(joyStickCounter)
    }
    
    
    
    
    
    
    
    
    
    //MAIN GAME LOOP
    var lastUpdateTime: TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTime
        let currentFPS = 1 / deltaTime
        //print(currentFPS)
        lastUpdateTime = currentTime
        
        
        if !gameOver {
            
            if score > fileWriter.read() {
                label.textColor = UIColor.yellow
            }
            
            entityManager.addChildrenEnemies()
            
            increaseScore()
            entityManager.spawnEntity()
            
            if inContact {
                hero.decreaseHealth()
                
                //only need to check health if in contact
                
            }
            
            if hero.health <= 0 {
                GameOver()
                self.view?.preferredFramesPerSecond = 5
            }
            
            for enemy in entityManager.enemies {
                enemy.move()
                
                if enemy.ID.elementsEqual("smart") {
                    let diffX = enemy.position.x - hero.position.x
                    let diffY = enemy.position.y - hero.position.y
                    let distance = sqrt(pow(diffX, 2.0) + pow(diffY, 2.0))
                    if distance <= hero.size.width / 2.0 + enemy.size.width/2 + 3 {
                        hero.decreaseHealth()
                    }
                }
                
            }
            
            if moved {
                hero.move(movedTouch: movedTouch, firstTouch: firstTouch)

            }
            
            //print(entityManager.enemies.count)
            
        }//end gameplaying loop
        
    }//end main game loop (update function)
} //End GameScene Class
 
 extension CGFloat {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
 }
