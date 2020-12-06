//
//  StartGameLayer.m
//  FunCircus
//
//  Created by khangfet on 4/8/14.
//  Copyright (c) 2014 khangfet. All rights reserved.
//

#import "StartGameLayer.h"

@interface StartGameLayer()
@property (nonatomic, retain) SKSpriteNode* playButton;
@end


@implementation StartGameLayer

- (id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        SKSpriteNode* startGameText = [SKSpriteNode spriteNodeWithImageNamed:@"FlappyBirdText"];
        startGameText.position = CGPointMake(size.width * 0.5f, size.height * 0.8f);
        startGameText.zPosition = 130;
        [self addChild:startGameText];
        
        SKSpriteNode* playButton = [SKSpriteNode spriteNodeWithImageNamed:@"PlayButton"];
        playButton.position = CGPointMake(size.width * 0.5f, size.height * 0.40f);
        playButton.zPosition = 130;
        [self addChild:playButton];
        
        [self setPlayButton:playButton];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if ([_playButton containsPoint:location])
    {
        if([self.delegate respondsToSelector:@selector(startGameLayer:tapRecognizedOnButton:)])
        {
            [self.delegate startGameLayer:self tapRecognizedOnButton:StartGameLayerPlayButton];
        }
    }
}
@end