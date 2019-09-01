//
//  Tail.swift
//  Wave
//
//  Created by Sachin Katyal on 6/8/18.
//  Copyright © 2018 Sachin Katyal. All rights reserved.
//

import Foundation
import SpriteKit


class Tail: SKSpriteNode {
    
    init(size: CGSize, color: UIColor) {
        super.init(texture: nil, color: UIColor.white, size: size)
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
