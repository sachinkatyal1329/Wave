//
//  hero.swift
//  Wave
//
//  Created by Sachin Katyal on 6/4/18.
//  Copyright © 2018 Sachin Katyal. All rights reserved.
//

import Foundation
import SpriteKit


class Hero: SKSpriteNode {
    
    var body: SKSpriteNode!
    
    var health: CGFloat = 400
    
    public var velx: CGFloat = 0.0
    public var vely: CGFloat = 0.0
    
    var dist: CGFloat = 0.0
    var tempx: CGFloat = 0.0
    var tempy: CGFloat = 0.0
    
    var bgLight: SKLightNode!
    var light: SKLightNode!
    
    let heroCategory: UInt32 = 0x1 << 0
    let enemyCategory: UInt32 = 0x1 << 1
    
    var triangle: SKShapeNode!
    var sprite: SKSpriteNode!
    var path: UIBezierPath!
    
    
    
    init() {
        let size = CGSize(width: 50, height: 50)
        super.init(texture: nil, color: UIColor.white, size: size)
        loadAppearance()

        
        loadPhysicsBodyWithSize(size: size)
        
        let xRange = SKRange(lowerLimit:0+size.width/2,upperLimit:UIScreen.main.bounds.width - size.width/2)
        let yRange = SKRange(lowerLimit:0+size.width/2,upperLimit:UIScreen.main.bounds.height - size.width/2)
        self.constraints = [SKConstraint.positionX(xRange,y:yRange)]
        
        self.lightingBitMask = 3

    

    }
    
    
    func loadAppearance() {
        //////////////////////////
        //LIMIT OF 9 LIGHT NODES//
        //////////////////////////
        
        light = SKLightNode()
        light.position = CGPoint(x: 0, y: 0)
        light.falloff = 0// rate at which the light decays
        light.ambientColor =  UIColor.white //UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
        light.lightColor = UIColor.white
        light.shadowColor = light.ambientColor
        light.categoryBitMask = 1
        
        
        addChild(light)
        
        bgLight = SKLightNode()
        bgLight.position = CGPoint(x: 0, y: 0)
        bgLight.falloff = 3 // rate at which the light decays
        bgLight.ambientColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 1)
        bgLight.lightColor = light.lightColor
        bgLight.shadowColor = UIColor(red: 11/255.0, green: 32.0/255.0, blue: 55.0/255.0, alpha: 0.5)
        bgLight.categoryBitMask = 2
        
        addChild(bgLight)
        
        
    }
    
    func calcSpeed(movedTouch: CGPoint, firstTouch: CGPoint) {
        dist = calcDist(coord1: movedTouch, coord2: firstTouch)
        tempx = movedTouch.x - firstTouch.x
        tempy = movedTouch.y - firstTouch.y
        if dist > 0 {
            velx = CGFloat((tempx)/(dist/4))
            vely = CGFloat((tempy)/(dist/4))
        }
        
    }
    
    func loadPhysicsBodyWithSize(size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = heroCategory
        physicsBody?.contactTestBitMask = enemyCategory
        physicsBody?.allowsRotation = true
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = true
    }
    
    
    func calcDist(coord1: CGPoint, coord2: CGPoint) -> CGFloat {
        let distance = sqrt(pow(Double(coord1.x - coord2.x),2) + pow(Double(coord1.y - coord2.y),2))
        return CGFloat(distance)
    }

    
    
    func move(movedTouch: CGPoint, firstTouch: CGPoint) {
       
        calcSpeed(movedTouch: movedTouch, firstTouch: firstTouch)
        self.position.x += velx
        self.position.y += vely
    
    
        
    }
    
    func decreaseHealth() {
        
        health -= 1
        
        //Game Over
        if health <= 0 {
            health = 0
        }
        
        print(health)
        
        self.color = UIColor(red: 1.0 , green: health/100, blue: health/100, alpha: 1.0)
        //light.lightColor = self.color
        
        if health > 50 {
            bgLight.lightColor = self.color

        }

        let impact = UIImpactFeedbackGenerator() // 1
        impact.impactOccurred()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
