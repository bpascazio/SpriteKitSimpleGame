//
//  GameScene.swift
//  SpriteKitSimpleGame
//
//  Created by Bob Pascazio on 1/20/16.
//  Copyright (c) 2016 Bytefly, Inc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.25
            sprite.yScale = 0.25
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
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
