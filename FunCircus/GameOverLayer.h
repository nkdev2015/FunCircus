//
//  GameOverLayer.h
//  FunCircus
//
//  Created by khangfet on 4/8/14.
//  Copyright (c) 2014 khangfet. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>
#import "GameLayerHelper.h"

typedef NS_ENUM(NSUInteger, GameOverLayerButtonType)
{
    GameOverLayerPlayButton = 0,
    ShareFBButton = 1
};


@protocol GameOverLayerDelegate;
@interface GameOverLayer : GameLayerHelper
@property (nonatomic, assign) id<GameOverLayerDelegate> delegate;
@end


//**********************************************************************
@protocol GameOverLayerDelegate <NSObject>
@optional

- (void) gameOverLayer:(GameOverLayer*)sender tapRecognizedOnButton:(GameOverLayerButtonType) gameOverLayerButtonType;
@end