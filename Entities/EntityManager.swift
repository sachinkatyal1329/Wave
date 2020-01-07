//
//  EntityManager.swift
//  Wave
//
//  Created by Sachin Katyal on 6/11/18.
//  Copyright © 2018 Sachin Katyal. All rights reserved.
//

import Foundation
import SpriteKit

class EntityManager: SKSpriteNode {
    
    var enemies = Set<Enemy>()
    
    var basicEnemy: Enemy!
    var smartEnemy: Enemy!
    var explodingEnemy: Enemy!
    var childEnemy: Enemy!
    
    var game: GameScene
    
    var hasCollided = false
    
    //var gameScene: GameScene!
    
    init(game: GameScene) {
        self.game = game
        
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: 0, height: 0))
        //gameScene = GameScene()
    }
    
    func addStartingEntities() {
        addHero()
        
        var randVelX = CGFloat(arc4random_uniform(4) + 7)
        var randVelY = CGFloat(arc4random_uniform(4) + 7)
        
        //basicEnemies
        game.addChild(addBasicEnemy(size: CGSize(width: 30, height: 30), color: UIColor.red, velx: randVelX, vely: randVelY, spawn: 0))
        
        //RandomVel Enemy
        randVelX = CGFloat(arc4random_uniform(4) + 7)
        randVelY = CGFloat(arc4random_uniform(4) + 7)

        game.addChild(addBasicEnemy(size: CGSize(width: 30, height: 30), color: UIColor.yellow, velx: -1 * randVelX, vely: randVelY, spawn: 1))
        
    }
    
    
    func addHero() {
        game.hero = Hero()
        game.hero.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        game.addChild(game.hero)
    }
    
    func spawnEntity() {
        if game.score == 500 {
            //addChild(entityManager.addExplodingEnemy(size: CGSize(width: 25, height: 25), color: UIColor.white, velx: -17.0, vely: 0.0, spawn: 1))
            //fast enemy
            game.addChild(addBasicEnemy(size: CGSize(width: 25, height: 25), color: UIColor.cyan, velx: 16, vely: 5, spawn: 0))
        }
        
        if game.score == 700 {
            game.addChild(addExplodingEnemy(size: CGSize(width: 25, height: 25), color: UIColor.white, velx: 17.0, vely: 0.0, spawn: 0))
            
        }
        
        if game.score == 750 {
            //fast enemy
            game.addChild(addBasicEnemy(size: CGSize(width: 25, height: 25), color: UIColor.orange, velx: 16, vely: 5, spawn: 0))
        }
        
        if game.score == 800 {
            game.addChild(addExplodingEnemy(size: CGSize(width: 25, height: 25), color: UIColor.white, velx: -17.0, vely: 0.0, spawn: 1))
        }
        
        if game.score == 1000 {
            //smart enemy
            game.addChild(addSmartEnemy(size: CGSize(width: 20, height: 20), color: UIColor.green, spawn: 1))
            
        }else if game.score >= 1000 {
            self.smartEnemy.receiveHeroPos(x: game.hero.position.x, y: game.hero.position.y)
            
        }
        
        if game.score == 1300 {
            flickerGameScene(state: "off", at: game.score)

        }
        
        if game.score == 1500 {
            game.addChild(addExplodingEnemy(size: CGSize(width: 25, height: 25), color: UIColor.white, velx: -17.0, vely: 0.0, spawn: 1))
            game.addChild(addExplodingEnemy(size: CGSize(width: 25, height: 25), color: UIColor.white, velx: 17.0, vely: 0.0, spawn: 0))
            
        }
        
        if game.score == 1750 {
            game.addChild(addExplodingEnemy(size: CGSize(width: 25, height: 25), color: UIColor.white, velx: -17.0, vely: 0.0, spawn: 1))
            game.addChild(addExplodingEnemy(size: CGSize(width: 25, height: 25), color: UIColor.white, velx: 17.0, vely: 0.0, spawn: 0))
        }
        
        if game.score == 2000 {

            for enemy in enemies {
                enemy.constraints = nil // set the constraints to null so all the entities start to leave the screen
                if enemy.ID.elementsEqual("smart") {
                    enemy.collided = true //explode
                }
            }
        }
        
        //WAVE 2
        if game.score == 2100 {
            game.hero.bgLight.ambientColor = UIColor(red: 105/255, green:105/255 , blue: 21/255, alpha: 1.0)
        }
        
        checkEntityConstraints()
        
        flickerGameScene(state: "off", at: 1300)
        flickerGameScene(state: "on", at: 2000)


        
    }
    
    func flickerGameScene(state: String, at score: CGFloat) {
        
        if state.elementsEqual("off") {
            if game.score == score {
                game.hero.light.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.bgLight.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.light.falloff = 2
                game.hero.bgLight.falloff = 2.5
                for enemy in enemies {
                    enemy.light.isEnabled = false
                    enemy.shadowedBitMask = 1 // Recieves shadow from "shadow" in the Hero Class
                    enemy.shadowCastBitMask = 2
                    game.hero.bgLight.shadowColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 0.5)
                }
            }
            
            if game.score == score + 7 {
                game.hero.light.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.bgLight.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.light.falloff = 0
                game.hero.bgLight.falloff = 2.5
                for enemy in enemies {
                    enemy.light.isEnabled = true
                }
            }
            
            if game.score == score + 14 {
                game.hero.light.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.bgLight.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.light.falloff = 2
                game.hero.bgLight.falloff = 2.5
                for enemy in enemies {
                    enemy.light.isEnabled = false
                    enemy.shadowedBitMask = 1 // Recieves shadow from "shadow" in the Hero Class
                    enemy.shadowCastBitMask = 2
                    game.hero.bgLight.shadowColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 0.5)
                }
            }
            
            if game.score == score + 29 {
                game.hero.light.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.bgLight.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.light.falloff = 0
                game.hero.bgLight.falloff = 2.5
                for enemy in enemies {
                    enemy.light.isEnabled = true
                }
            }
            
            if game.score == score + 44 {
                game.hero.light.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.bgLight.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.light.falloff = 2
                game.hero.bgLight.falloff = 2.5
                for enemy in enemies {
                    enemy.light.isEnabled = false
                    enemy.shadowedBitMask = 1 // Recieves shadow from "shadow" in the Hero Class
                    enemy.shadowCastBitMask = 2
                    game.hero.bgLight.shadowColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 0.5)
                }
            }
        }
        
        if state.elementsEqual("on") {
            if game.score == score + 7 {
                game.hero.light.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.bgLight.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.light.falloff = 2
                game.hero.bgLight.falloff = 2.5
                for enemy in enemies {
                    //enemy.light.isEnabled = false //Turns off the glowing affect for each entity
                    enemy.shadowedBitMask = 1 // Recieves shadow from "shadow" in the Hero Class
                    enemy.shadowCastBitMask = 2
                    game.hero.bgLight.shadowColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 0.5)
                }
            }
            
            if game.score == score {
                game.hero.light.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.bgLight.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.light.falloff = 0
                game.hero.bgLight.falloff = 2.5
                for enemy in enemies {
                   // enemy.light.isEnabled = true
                }
            }
            
            if game.score == score + 14 {
                game.hero.light.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.bgLight.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.light.falloff = 0
                game.hero.bgLight.falloff = 2.5
                for enemy in enemies {
                    //enemy.light.isEnabled = true
                }
            }
            
            if game.score == score + 44 {
                game.hero.light.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.bgLight.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.light.falloff = 0
                game.hero.bgLight.falloff = 2.5
                for enemy in enemies {
                   // enemy.light.isEnabled = true
                }
            }
            
            if game.score == score + 29 {
                game.hero.light.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.bgLight.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
                game.hero.light.falloff = 2
                game.hero.bgLight.falloff = 2.5
                for enemy in enemies {
                   //enemy.light.isEnabled = false
                    enemy.shadowedBitMask = 1 // Recieves shadow from "shadow" in the Hero Class
                    enemy.shadowCastBitMask = 2
                    game.hero.bgLight.shadowColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 0.5)
                }
            }
        }
    }
    
    func checkEntityConstraints() {
        for enemy in enemies {
            if enemy.constraints == nil {
                if enemy.position.x >= UIScreen.main.bounds.width + 120 || enemy.position.x <= -120 || enemy.position.y >= UIScreen.main.bounds.height + 120 || enemy.position.y <= -120 {
                    enemies.remove(enemy)
                    enemy.removeFromParent()
                }
            }
        }
    }

    
    
    func addBasicEnemy(size: CGSize, color: UIColor, velx: CGFloat, vely: CGFloat, spawn: CFBit) -> Enemy {
        basicEnemy = Enemy(size: size, color: color, velocityx: velx, velocityy: vely, collided: false, ID: "basic")
        
        if spawn == 0 { // left
            basicEnemy.position = CGPoint(x: -100, y: CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height) - 100) + 50))
        } else { // right
            basicEnemy.position = CGPoint(x: UIScreen.main.bounds.width + 100, y: CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height) - 100) + 50))
        }
        
        
        //basicEnemy.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width) - 50)), y: CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height) - 50)))
        let xRange = SKRange(lowerLimit:0+size.width/2 - 1, upperLimit:UIScreen.main.bounds.width - size.width/2 + 1)
        let yRange = SKRange(lowerLimit:0+size.width/2 - 1, upperLimit:UIScreen.main.bounds.height - size.width/2 + 1)
        basicEnemy.constraints = [SKConstraint.positionX(xRange,y:yRange)]
        
        
        enemies.insert(basicEnemy)
        return basicEnemy
        
    }
    
    func addBasicEnemy(size: CGSize, color: UIColor, velx: CGFloat, vely: CGFloat, posx: CGFloat, posy: CGFloat) -> Enemy{
        let basicEnemyPos = Enemy(size: size, color: color, velocityx: velx, velocityy: vely, collided: false, ID: "basic")
        basicEnemyPos.position = CGPoint(x: posx, y: posy)
        
        let xRange = SKRange(lowerLimit:0+size.width/2 - 1, upperLimit:UIScreen.main.bounds.width - size.width/2 + 1)
        let yRange = SKRange(lowerLimit:0+size.width/2 - 1, upperLimit:UIScreen.main.bounds.height - size.width/2 + 1)
        basicEnemyPos.constraints = [SKConstraint.positionX(xRange,y:yRange)]
        
        enemies.insert(basicEnemyPos)
        return basicEnemyPos
        
    }
    
    
    
    func addSmartEnemy(size: CGSize, color: UIColor, spawn: CFBit) -> Enemy {
        smartEnemy = Enemy(size: size, color: color, velocityx: 0, velocityy: 0, collided: false, ID: "smart")
        
        if spawn == 0 { // left
            smartEnemy.position = CGPoint(x: -100, y: CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height) - 100) + 50))
        } else { // right
            smartEnemy.position = CGPoint(x: UIScreen.main.bounds.width + 100, y: CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height) - 100) + 50))
        }
        
        //gameScene.addChild(smartEnemy)
        enemies.insert(smartEnemy)
        
        
        let xRange = SKRange(lowerLimit:0+size.width/2 - 1, upperLimit:UIScreen.main.bounds.width - size.width/2 + 1)
        let yRange = SKRange(lowerLimit:0+size.width/2 - 1, upperLimit:UIScreen.main.bounds.height - size.width/2 + 1)
        smartEnemy.constraints = [SKConstraint.positionX(xRange,y:yRange)]
        
        return smartEnemy
    }
    
    func addExplodingEnemy(size: CGSize, color: UIColor, velx: CGFloat, vely: CGFloat, spawn: CFBit) -> Enemy {
        explodingEnemy = Enemy(size: size, color: color, velocityx: velx, velocityy: vely, collided: false, ID: "exploding")
        
        if spawn == 0 { // left
            explodingEnemy.position = CGPoint(x: -100, y: CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height) - 100) + 50))
        } else { // right
            explodingEnemy.position = CGPoint(x: UIScreen.main.bounds.width + 100, y: CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height) - 100) + 50))
        }
        enemies.insert(explodingEnemy)
        
        let xRange = SKRange(lowerLimit:0+size.width/2 - 1, upperLimit:UIScreen.main.bounds.width - size.width/2 + 1)
        let yRange = SKRange(lowerLimit:0+size.width/2 - 1, upperLimit:UIScreen.main.bounds.height - size.width/2 + 1)
        explodingEnemy.constraints = [SKConstraint.positionX(xRange,y:yRange)]
        
        return explodingEnemy
    
    }
    
    func addChildEnemy(size: CGSize, color: UIColor, position: CGPoint, velx: CGFloat, vely: CGFloat) -> Enemy {
    
        //let velx = 15
        //let vely = velx + exp(-0.2 * velx) * sin(10 * velx)
        
        childEnemy = Enemy(size: size, color: color, velocityx: velx, velocityy: vely, collided: false, ID: "child")
        
        childEnemy.position = position
        
        enemies.insert(childEnemy)
        return childEnemy
    }
    
    func addChildrenEnemies() { //Add exploding bits
        for enemy in enemies {
            if enemy.collided == true {
                if enemy.position.x < 50 {
                    
                    for i in 0...10 {
                        game.addChild(addChildEnemy(size: CGSize(width: 7, height: 7), color: enemy.color, position: enemy.position, velx: CGFloat(15 - (2 * i)), vely: CGFloat(0 + (2 * i))))
                        game.addChild(addChildEnemy(size: CGSize(width: 7, height: 7), color: enemy.color, position: enemy.position, velx: CGFloat(15 - (2 * i)), vely: CGFloat(0 - (2 * i))))
                    }
                }
                else {
                    for i in 0...9 {
                        game.addChild(addChildEnemy(size: CGSize(width: 7, height: 7), color: enemy.color, position: enemy.position, velx: -1 * CGFloat(15 - (2 * i)), vely: CGFloat(0 + (2 * i))))
                        game.addChild(addChildEnemy(size: CGSize(width: 7, height: 7), color: enemy.color, position: enemy.position, velx: -1 * CGFloat(15 - (2 * i)), vely: CGFloat(0 - (2 * i))))
                    }
                }
                enemy.removeFromParent()
                enemies.remove(enemy)
                enemy.collided = false
            }
        }
    }

    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
