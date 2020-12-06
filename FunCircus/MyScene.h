//
//  MyScene.h
//  FunCircus
//

//  Copyright (c) 2014 khangfet. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "StartGameLayer.h"
#import "GameOverLayer.h"
@import AVFoundation;
@interface MyScene : SKScene <SKPhysicsContactDelegate,StartGameLayerDelegate,GameOverLayerDelegate>
{
    NSTimeInterval _dt;
    SKSpriteNode *buttonBack ;
    NSMutableArray *runPlay;
    StartGameLayer* _startGameLayer;
    GameOverLayer* _gameOverLayer;
    BOOL _gameStarted;
    BOOL _gameOver;
    int _score;

    int _highScore;
    int actualDurationFire ;
    int actualDurationBall;

    SKLabelNode * _lblScore;
    SKLabelNode * _lblBest;
    int _countBall;
    int tempBall ;
    int _countFire;
    
    AVAudioPlayer *jumAudio;
     AVAudioPlayer *mapAudio;
    AVAudioPlayer *gameOverAudio;
   
}
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) SKSpriteNode*  backgroundImageNode;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@end
