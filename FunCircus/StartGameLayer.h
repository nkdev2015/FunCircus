//
//  StartGameLayer.h
//  FunCircus
//
//  Created by khangfet on 4/8/14.
//  Copyright (c) 2014 khangfet. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameLayerHelper.h"
typedef NS_ENUM(NSUInteger, StartGameLayerButtonType)
{
    StartGameLayerPlayButton = 0
};


@protocol StartGameLayerDelegate;
@interface StartGameLayer : GameLayerHelper
@property (nonatomic, assign) id<StartGameLayerDelegate> delegate;
@end


//**********************************************************************
@protocol StartGameLayerDelegate <NSObject>
@optional

- (void) startGameLayer:(StartGameLayer*)sender tapRecognizedOnButton:(StartGameLayerButtonType) startGameLayerButton;
@end