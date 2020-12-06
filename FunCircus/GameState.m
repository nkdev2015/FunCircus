//
//  GameState.m
//  FunCircus
//
//  Created by vankhangfet on 4/8/14.
//  Copyright (c) 2014 khangfet. All rights reserved.
//

#import "GameState.h"

@implementation GameState
+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    static GameState *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[super alloc] init];
    });
    return _sharedInstance;
}

- (id) init
{
    if (self = [super init]) {
        // Init
        _score = 0;
        _highScore = 0;
        // Load game state
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        id highScore = [defaults objectForKey:@"highScore"];
        if (highScore) {
            _highScore = [highScore intValue];
        }
            }
    return self;
}
- (void) saveState
{
    // Update highScore if the current score is greater
    _highScore = MAX(_score, _highScore);
    // Store in user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:_highScore] forKey:@"highScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
