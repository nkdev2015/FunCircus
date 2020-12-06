//
//  StartScene.m
//  FunCircus
//
//  Created by khangfet on 4/7/14.
//  Copyright (c) 2014 khangfet. All rights reserved.
//

#import "StartScene.h"
#import "MyScene.h"
@implementation StartScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        /*
         SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:SPRITES_TEX_BACKGROUND];
         background.anchorPoint = CGPointMake(0, 0);
         // add the background image to the SKScene; by default it is added to position 0,0 (bottom left corner) of the scene
         [self addChild: background];
         */
        NSLog(@"Size:%@",NSStringFromCGSize(size));
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Resource/Background/ScreenSelectSmall"];
        background.anchorPoint = CGPointZero;
        background.position = CGPointZero;
        
        [self addChild:background];
        [self initButton];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    /* Called when a touch begins */
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        // NSLog(@"** TOUCH LOCATION ** \nx: %f / y: %f", location.x, location.y);
        
        if([buttonStart containsPoint:location])
        {
            NSLog(@"Touch on Start Button");
            
           // [self showSoundButtonForTogglePosition:_soundOff];
            SKView * skView = (SKView *)self.view;
            SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            [skView presentScene:scene];
        }
        if([buttonStart containsPoint:location])
        {
            
        }
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


-(void)initButton
{
    buttonStart = [SKSpriteNode spriteNodeWithImageNamed:@"NewGameButton"];
    buttonStart.name = @"buttonStart";
    
    buttonStart.position = CGPointMake(280,90);
    [self addChild:buttonStart];
    
    buttonHighScore = [SKSpriteNode spriteNodeWithImageNamed:@"HighScoreButton"];
    buttonHighScore.name = @"HighScoreButton";
    
    buttonHighScore.position = CGPointMake(280,50);
    [self addChild:buttonHighScore];
    

}

@end
