//
//  GameState.h
//  FunCircus
//
//  Created by vankhangfet on 4/8/14.
//  Copyright (c) 2014 khangfet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int highScore;
+ (instancetype)sharedInstance;
- (void) saveState;
@end
