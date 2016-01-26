//
//  GameScene.swift
//  SpriteKitSimpleGame
//
//  Created by Bob Pascazio on 1/20/16.
//  Copyright (c) 2016 Bytefly, Inc. All rights reserved.
//

import SpriteKit

func + (left: CGPoint, right:CGPoint) -> CGPoint {
    
    return CGPoint(x:left.x+right.x, y:left.y+right.y)
    
}

func - (left: CGPoint, right:CGPoint) -> CGPoint {
    
    return CGPoint(x:left.x-right.x, y:left.y-right.y)
    
}

func * (point: CGPoint, scalar:CGFloat) -> CGPoint {
    
    return CGPoint(x:point.x*scalar, y:point.y*scalar)
    
}

func / (point: CGPoint, scalar:CGFloat) -> CGPoint {
    
    return CGPoint(x:point.x/scalar, y:point.y/scalar)
    
}

func sqrt(a: CGFloat) -> CGFloat {
    
    return CGFloat(sqrtf(Float(a)))
}

extension CGPoint {
    
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self/length()
    }
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "Player")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = SKColor.yellowColor()
        player.position = CGPoint(x:size.width*0.1, y:size.height*0.5)
        player.xScale = 0.25
        player.yScale = 0.25
        addChild(player)
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(addMonster),
            SKAction.waitForDuration(1.0)])
            )
        )
        
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        let projectile = SKSpriteNode(imageNamed: "Projectile")
        projectile.position = player.position
        projectile.xScale = 0.25
        projectile.yScale = 0.25
        
        let offset = touchLocation - projectile.position
        if offset.x < 0 {
            return
        }
        addChild(projectile)
        let direction = offset.normalized()
        
        let shootAmount = direction * 1000
        
        let realDest = shootAmount + projectile.position
        
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([actionMove, actionMoveDone])
        
        projectile.runAction(sequence)
        let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:0.25)
        projectile.runAction(SKAction.repeatActionForever(rotateAction))
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    func random() -> CGFloat {
        
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    
    func random(min:CGFloat, max:CGFloat) -> CGFloat {
        
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        let monster = SKSpriteNode(imageNamed: "Monster")
        
        let actualY = random(monster.size.height/2, max:size.height-monster.size.height/2)
        
        monster.position = CGPoint(x:size.width+monster.size.width/2, y:actualY)
        monster.xScale = 0.10
        monster.yScale = 0.10
        
        addChild(monster)
        
        let actualDuration = random(CGFloat(2.0), max:CGFloat(8.0))
        
        let actionMove = SKAction.moveTo(CGPoint(x:-monster.size.width/2, y:actualY), duration: NSTimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()

        let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        monster.runAction(SKAction.repeatActionForever(rotateAction))
        
        //let scaleAction = SKAction.scaleBy(CGFloat(-2), duration: 5)
        //monster.runAction(SKAction.repeatActionForever(scaleAction))
                
    }

}
