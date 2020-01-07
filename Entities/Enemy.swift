//
//  Enemy.swift
//  Wave
//
//  Created by Sachin Katyal on 6/5/18.
//  Copyright © 2018 Sachin Katyal. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class Enemy: SKSpriteNode {
    var game: GameScene!

    var velx: CGFloat = 0
    var vely: CGFloat = 0
    
    var alphaa: CGFloat = 1.0
    var life: CGFloat = 0.02
    
    var heroPosX: CGFloat = 0
    var heroPosY: CGFloat = 0
    
    var collided: Bool = false
    
    var triangleColor: UIColor
    
    var light: SKLightNode!
    
    var cc = 0
    var ID: String!

    let heroCategory: UInt32 = 0x1 << 0
    let enemyCategory: UInt32 = 0x1 << 1
    
    init(size: CGSize, color: UIColor, velocityx: CGFloat, velocityy: CGFloat, collided: Bool, ID: String) {
        self.triangleColor = color

        
        super.init(texture: nil , color: color, size: size)
        
        
        
        //self.normalTexture = SKTexture(imageNamed: "enemynm")
        
        self.lightingBitMask = 1 // Recieves lighting from "light" in the Hero Class
        //self.shadowedBitMask = 1 // Recieves shadow from "shadow" in the Hero Class
        
        if !ID.elementsEqual("child") {
            
            //self.shadowCastBitMask = 2
        }
        
        self.normalTexture = self.texture?.generatingNormalMap(withSmoothness: 0.1, contrast: 0.1)

        game = GameScene()
        
        //self.addGlow()
        

        self.velx = velocityx
        self.vely = velocityy
        self.ID = ID
        
        loadPhysicsBodyWithSize(size: size)
        loadAppearance()

        
    }
    
    func loadAppearance() {
        //////////////////////////
        //LIMIT OF 9 LIGHT NODES//
        //////////////////////////
        
        
        if !self.ID.elementsEqual("child") {
            light = SKLightNode()
            light.position = CGPoint(x: 0, y: 0)
            light.falloff = 5// rate at which the light decays
            light.lightColor = self.color
            light.shadowColor = UIColor.clear
            light.categoryBitMask = 3
        
            addChild(light)
        
        }
        
    }
    
    func receiveHeroPos(x: CGFloat, y: CGFloat) {
        self.heroPosX = x
        self.heroPosY = y
    }
    
    func loadPhysicsBodyWithSize(size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = enemyCategory
        physicsBody?.allowsRotation = true
        physicsBody?.affectedByGravity = false
    }
    
    func move() {
        
        if ID.elementsEqual("smart") {
            if self.position.x > UIScreen.main.bounds.width || self.position.x < 0{
                velx = -5
                vely = 0
            } else {
                
                let diffX = self.position.x - heroPosX
                let diffY = self.position.y - heroPosY
                let distance = sqrt(pow(diffX, 2.0) + pow(diffY, 2.0))
                
                velx = 1 * ((-2/distance) * diffX)
                vely = 1 * ((-2/distance) * diffY)
                
            }
            
            self.position.x += velx
            self.position.y += vely
            
        }else { // not smart
            
            if self.position.x > UIScreen.main.bounds.width - size.width/2.0 || self.position.x < size.width/2.0 {
               
                if self.constraints != nil {
                    velx = velx * -1
                }
                if ID.elementsEqual("exploding") { // IF EXPLODING ENEMY Collides
                    cc += 1
                    if cc >= 3 {
                        self.collided = true
                    }
                }
                
            } else if self.position.y > UIScreen.main.bounds.height - size.width/2.0 || self.position.y < size.height/2.0 {
                if self.constraints != nil {
                    vely = vely * -1
                }
                
            }
            if self.constraints != nil {
                self.position.x += velx
                self.position.y += vely
            } else {
                self.position.x += velx
                //self.position.y += 10 * sin(self.position.x * 0.02)
                self.position.y += vely
            }
        }
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension SKSpriteNode {
    
    func addGlow(radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        effectNode.setScale(0.1)
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        
        effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])
    }
}

extension UIColor {
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}
