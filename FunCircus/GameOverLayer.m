//
//  GameOverLayer.m
//  FunCircus
//
//  Created by khangfet on 4/8/14.
//  Copyright (c) 2014 khangfet. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameState.h"
#import <Social/Social.h>
@interface GameOverLayer()
@property (nonatomic, retain) SKSpriteNode* retryButton;
@property (nonatomic, retain) SKSpriteNode* fbButton;
@end

@implementation GameOverLayer

- (id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        SKSpriteNode* startGameText = [SKSpriteNode spriteNodeWithImageNamed:@"GameOverText"];
        startGameText.position = CGPointMake(size.width * 0.5f, size.height * 0.8f);
        startGameText.zPosition = 130;
        [self addChild:startGameText];
        
        
        
        SKSpriteNode* retryButton = [SKSpriteNode spriteNodeWithImageNamed:@"ResetButton"];
        retryButton.position = CGPointMake(size.width * 0.4f, size.height * 0.40f);
        retryButton.zPosition = 130;
        [self addChild:retryButton];
        
        [self setRetryButton:retryButton];
        
        SKSpriteNode* fbButton = [SKSpriteNode spriteNodeWithImageNamed:@"FaceBookButton"];
        fbButton.position = CGPointMake(size.width * 0.65f, size.height * 0.40f);
        fbButton.zPosition = 130;
        [self addChild:fbButton];
        
        [self setFbButton:fbButton];
        
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if ([_retryButton containsPoint:location])
    {
        if([self.delegate respondsToSelector:@selector(gameOverLayer:tapRecognizedOnButton:)])
        {
            [self.delegate gameOverLayer:self tapRecognizedOnButton:GameOverLayerPlayButton];
        }
    }
    if([_fbButton containsPoint:location])
    {
      
        if([self.delegate respondsToSelector:@selector(gameOverLayer:tapRecognizedOnButton:)])
        {
            [self.delegate gameOverLayer:self tapRecognizedOnButton:ShareFBButton];
        }
    }
}



@end
