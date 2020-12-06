//
//  MyScene.m
//  FunCircus
//
//  Created by khangfet on 4/7/14.
//  Copyright (c) 2014 khangfet. All rights reserved.
//

#import "MyScene.h"
#import "Constans.h"
#import "StartScene.h"
#import "GameState.h"
#import  <Social/Social.h>
@implementation MyScene

static const uint32_t playerCategory     =  0x1 << 0;
static const uint32_t ballCategory       =  0x1 << 1;
static const uint32_t colCategory        =  0x1 << 2;

#define BOTTOM_BACKGROUND_Z_POSITION    100
#define START_GAME_LAYER_Z_POSITION     150
#define GAME_OVER_LAYER_Z_POSITION      200
#define COLUP     @"colUp"
#define TIME 1.5

#define UPWARD_PILLER @"RegUp"
#define Downward_PILLER @"RegDown"


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self initializeBackGround:size];
        [self initializeStartGameLayer];
        [self initializeGameOverLayer];
        [self showStartGameLayer];
        
        //Set gravity to 0 so that bird remains in its position in start page
        self.physicsWorld.gravity = CGVectorMake(0, 0.0);
        
        //To detect collision detection
        self.physicsWorld.contactDelegate = self;
        _gameOver = NO;
        _gameStarted = NO;
        [self initStaticroad];

        [self initScore];
        tempBall =4;
        _countFire =0;
        // Play sound
        NSError *errorMap;
        NSURL *mapMusicURL = [[NSBundle mainBundle] URLForResource:@"Map.mp3" withExtension:nil];
        mapAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusicURL error:&errorMap];
        mapAudio.numberOfLoops = -1;
        mapAudio.volume = 1.0;
        [mapAudio play];
        
        // Play sound
        NSError *error;
        NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"MarioDies.mp3" withExtension:nil];
        gameOverAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
        gameOverAudio.volume = 1.0;
        
        //
        NSError *errorJump;
        NSURL *jumMusicURL = [[NSBundle mainBundle] URLForResource:@"Jump.mp3" withExtension:nil];
        jumAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:jumMusicURL error:&errorJump];
        jumAudio.volume = 1.0;
        
    }
    return self;
}





-(void)initScore
{
    
    // Score
    _score =0;
    _lblScore = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    _lblScore.fontSize = 25;
    _lblScore.fontColor = [SKColor whiteColor];
    _lblScore.position = CGPointMake(120, self.size.height-40);
    _lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    // 5
    
    [self addChild:_lblScore];
    
    
    // Score
    _lblBest = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    _lblBest.fontSize = 25;
    _lblBest.fontColor = [SKColor whiteColor];
    _lblBest.position = CGPointMake(self.size.width-20, self.size.height-40);
    _lblBest.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    // 5
    [self addChild:_lblBest];
    _lblBest.zPosition = 130;
    _lblScore.zPosition = 130;

}


- (void) initializeBackGround:(CGSize) sceneSize
{
    self.backgroundImageNode = [SKSpriteNode spriteNodeWithImageNamed:@"ScreenCirCusLignt"];
    self.backgroundImageNode.size = sceneSize;
    self.backgroundImageNode.position = CGPointMake(self.backgroundImageNode.size.width/2, self.frame.size.height/2);
    SKAction *back = [SKAction animateWithTextures:SPRITES_BACKGROUND timePerFrame:0.2];
    SKAction *backAnim = [SKAction repeatActionForever:back];
    [self.backgroundImageNode runAction:backAnim];
    [self addChild:self.backgroundImageNode];
}


- (void) initializeStartGameLayer
{
    _startGameLayer = [[StartGameLayer alloc]initWithSize:self.size];
    _startGameLayer.userInteractionEnabled = YES;
    _startGameLayer.zPosition = START_GAME_LAYER_Z_POSITION;
    _startGameLayer.delegate = self;
}



- (void) initializeGameOverLayer
{
    _gameOverLayer = [[GameOverLayer alloc]initWithSize:self.size];
    _gameOverLayer.userInteractionEnabled = YES;
    _gameOverLayer.zPosition = GAME_OVER_LAYER_Z_POSITION;
    _gameOverLayer.delegate = self;
}



- (SKSpriteNode*) createPillerWithUpwardDirection:(BOOL) isUpwards
{
    NSString* pillerImageName = nil;
    if (isUpwards)
    {
        pillerImageName = UPWARD_PILLER;
    }
    else
    {
        pillerImageName = Downward_PILLER;
    }
    
    SKSpriteNode * piller = [SKSpriteNode spriteNodeWithImageNamed:pillerImageName];
    piller.name = COLUP;
    
    /*
     * Create a physics and specify its geometrical shape so that collision algorithm
     * can work more prominently
     */
    piller.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:piller.size];
    
    //Category to which this object belongs to
    piller.physicsBody.categoryBitMask = colCategory;
    
    //To notify intersection with objects
    piller.physicsBody.contactTestBitMask = playerCategory;
    
    //To detect collision with category of objects. Default all categories
    piller.physicsBody.collisionBitMask = 0;
    
    /*
     * Has to be explicitely mentioned. If not mentioned, pillar starts moving down becuase of gravity.
     */
    piller.physicsBody.affectedByGravity = NO;
    
    [self addChild:piller];
    
    return piller;
}

#pragma mark - Collision Detection
- (void)col:(SKSpriteNode *)cal didCollideWithBird:(SKSpriteNode *)player
{
    for (int i = self.children.count - 1; i >= 0; i--)
    {
        SKNode* childNode = [self.children objectAtIndex:i];
        if(childNode.physicsBody.categoryBitMask == colCategory)
        {
            [childNode removeAllActions];
            [childNode removeFromParent];
        }
    }
    [self.player removeFromParent];
    _gameOver = YES;
    [[GameState sharedInstance] saveState];
    [self showGameOverLayer];
}



- (void)didBeginContact:(SKPhysicsContact *)contact
{
    //return;
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & colCategory) != 0 &&
        (secondBody.categoryBitMask & playerCategory) != 0)
    {
        [self col:(SKSpriteNode *) firstBody.node didCollideWithBird:(SKSpriteNode *) secondBody.node];
    }
    
}

#pragma mark - GameStatus calls
- (void) showStartGameLayer
{
    
    for (int i = self.children.count - 1; i >= 0; i--)
    {
        SKNode* childNode = [self.children objectAtIndex:i];
        if(childNode.physicsBody.categoryBitMask == colCategory)
        {
            [childNode removeFromParent];
        }
    }
    
    //Move player node to center of the scene
    self.player.position = CGPointMake(self.backgroundImageNode.size.width * 0.5f, self.frame.size.height * 0.6f);
    
    [_gameOverLayer removeFromParent];
    
    self.player.hidden = NO;
    //Remove currently exising on pillars from scene and purge them
    [self addChild:_startGameLayer];
}



- (void) showGameOverLayer
{
    //Remove currently exising on pillars from scene and purge them
    for (int i = self.children.count - 1; i >= 0; i--)
    {
        SKNode* childNode = [self.children objectAtIndex:i];
        if(childNode.physicsBody.categoryBitMask == colCategory)
        {
            [childNode removeAllActions];
        }
    }
    
    [self.player removeAllActions];
    self.player.physicsBody.velocity = CGVectorMake(0, 0);
    self.physicsWorld.gravity = CGVectorMake(0, 0.0);
    self.player.hidden = YES;

    _lastUpdateTimeInterval = 0;
    _lastSpawnTimeInterval = 0;
    [_startGameLayer removeFromParent];
    [self addChild:_gameOverLayer];
    
    [gameOverAudio play];
}


-(void)initPlayer
{
    
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"ngua0002"];
    //self.player.position = CGPointMake(170, 180);
    if(self.frame.size.height > 320)
    {
        self.player.position = CGPointMake(self.frame.size.width*0.25, self.frame.size.height*0.5);
    }
    else
    {
        self.player.position = CGPointMake(self.frame.size.width*0.30, self.frame.size.height*0.5);
    }
    self.player.zPosition = 100;
    
    /*
     * Create a physics and specify its geometrical shape so that collision algorithm
     * can work more prominently
     */

    //Category to which this object belongs to
    self.player.physicsBody.categoryBitMask = playerCategory;
    
    //To notify intersection with objects
    self.player.physicsBody.contactTestBitMask = colCategory | ballCategory; //| moneyCategory;
    
    //To detect collision with category of objects
    self.player.physicsBody.collisionBitMask = 0;
    
    self.player.physicsBody.allowsRotation = NO;
    self.player.physicsBody.restitution = 1.0f;
    self.player.physicsBody.angularDamping = 0.0f;
    self.player.physicsBody.linearDamping = 0.0f;
    self.player.physicsBody.friction = 0.0f;
    
    [self addChild:self.player];
    
    SKAction *walk = [SKAction animateWithTextures:SPRITES_PLAYER timePerFrame:0.2];
    //[SKAction repeatActionForever:]
    SKAction *walkAnim = [SKAction repeatActionForever:walk];
    [self.player runAction:walkAnim];
    
    /*
     * Create a physics and specify its geometrical shape so that collision algorithm
     * can work more prominently
     */
    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    self.player.physicsBody.allowsRotation = NO;
    self.player.physicsBody.dynamic = YES;
    
    
}

-(void)initBall
{
    float postY = self.frame.size.height*0.46;
    SKSpriteNode *  ball = [SKSpriteNode spriteNodeWithImageNamed:@"BongLan0001"];
    //ball.position = CGPointMake(self.frame.size.width + ball.size.width/2, 150);
     ball.position = CGPointMake(self.frame.size.width + ball.size.width/2, postY);
    ball.zPosition = 80;
    [self addChild:ball];
    
    SKAction * actionMoveFire = [SKAction moveTo:CGPointMake(-ball.size.width/2 , postY) duration:actualDurationBall];
    SKAction * actionMoveDoneFire = [SKAction removeFromParent];
    [ball runAction:[SKAction sequence:@[actionMoveFire, actionMoveDoneFire]]];
    
    
    SKAction *fireAction = [SKAction animateWithTextures:SPRITES_BALL timePerFrame:0.1];
    //[SKAction repeatActionForever:]
    SKAction *fireAnim = [SKAction repeatActionForever:fireAction];
    [ball runAction:fireAnim];
    
    ball.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ball.size];
    
    //Category to which this object belongs to
    ball.physicsBody.categoryBitMask = ballCategory;
    
    //To notify intersection with objects
    ball.physicsBody.contactTestBitMask = playerCategory;
    
    //To detect collision with category of objects. Default all categories
    ball.physicsBody.collisionBitMask = 0;
    
    /*
     * Has to be explicitely mentioned. If not mentioned, pillar starts moving down becuase of gravity.
     */
    ball.physicsBody.affectedByGravity = NO;
 
    


}


-(void)initStaticBall
{
    float postY = self.frame.size.height*0.46;
    SKSpriteNode *  ball = [SKSpriteNode spriteNodeWithImageNamed:@"BongLan0001"];
    //ball.position = CGPointMake(self.frame.size.width + ball.size.width/2, 150);
    ball.position = CGPointMake(self.frame.size.width + ball.size.width/2, postY);
    ball.zPosition = 80;
    [self addChild:ball];
    
    //SKAction * actionMoveFire = [SKAction moveTo:CGPointMake(-ball.size.width/2 , 150) duration:1.5];
    SKAction * actionMoveFire = [SKAction moveTo:CGPointMake(-ball.size.width/2 , postY) duration:1.5];
    SKAction * actionMoveDoneFire = [SKAction removeFromParent];
    [ball runAction:[SKAction sequence:@[actionMoveFire, actionMoveDoneFire]]];
    
    
    SKAction *fireAction = [SKAction animateWithTextures:SPRITES_BALL timePerFrame:0.1];
    //[SKAction repeatActionForever:]
    SKAction *fireAnim = [SKAction repeatActionForever:fireAction];
    [ball runAction:fireAnim];
    
    ball.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ball.size];
    
    //Category to which this object belongs to
    ball.physicsBody.categoryBitMask = ballCategory;
    
    //To notify intersection with objects
    ball.physicsBody.contactTestBitMask = playerCategory;
    
    //To detect collision with category of objects. Default all categories
    ball.physicsBody.collisionBitMask = 0;
    
    /*
     * Has to be explicitely mentioned. If not mentioned, pillar starts moving down becuase of gravity.
     */
    ball.physicsBody.affectedByGravity = NO;
    
    
    
}


#pragma mark - Delegates
#pragma mark -StartGameLayer
- (void)startGameLayer:(StartGameLayer *)sender tapRecognizedOnButton:(StartGameLayerButtonType)startGameLayerButton
{
    _gameStarted = YES;
    [self startGame];
}



- (void)gameOverLayer:(GameOverLayer *)sender tapRecognizedOnButton:(GameOverLayerButtonType)gameOverLayerButtonType
{
    if(gameOverLayerButtonType ==0)
    {
    _gameOver = NO;
    _gameStarted = NO;
    [self showStartGameLayer];
    _gameStarted = NO;
    [_gameOverLayer removeFromParent];
    //[self startGame];
    }
    if(gameOverLayerButtonType==1)
    {
      [self postFB];
    }
}


- (void) startGame
{
    _score = 0;
    actualDurationFire =  duration_Fire; //2.5f;//2.5f
    actualDurationBall =  duration_Ball; //3.5f;
    _gameStarted = YES;
     _highScore =[GameState sharedInstance].highScore;
    [_lblBest setText:[NSString stringWithFormat:@"Best: %d",_highScore]];
    [_lblScore setText:@"Score: 0"];    [_startGameLayer removeFromParent];
    [self initPlayer];

    //To have Gravity effect on Bird so that bird flys down when not tapped
    if(self.frame.size.height <=320)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -6.0);
    }
    else
    {
         self.physicsWorld.gravity = CGVectorMake(0, -9.0);
        
    }

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    float factorJum = 0;
    float postY =0;
    if(self.frame.size.height > 320)
    {
        factorJum = 1.03;
        postY =  570;//self.frame.size.height* factorJum;
        NSLog(@"%f",postY);
    }
    if(self.frame.size.height <= 320)
    {
      factorJum = 1.03;
        postY = 330;
    }
    //float postY = self.frame.size.height * factorJum;
           if(_gameStarted && _gameOver == NO)
            {
                
                
                [jumAudio play];
                self.player.physicsBody.velocity = CGVectorMake(0, postY); //330
                if(self.player.frame.origin.y >= self.frame.size.height||self.player.frame.origin.x < 0) // 330
                {
                    
                    for (int i = self.children.count - 1; i >= 0; i--)
                    {
                        SKNode* childNode = [self.children objectAtIndex:i];
                        if(childNode.physicsBody.categoryBitMask == colCategory)
                        {
                            [childNode removeAllActions];
                            [childNode removeFromParent];
                        }
                    }
                    [self.player removeFromParent];
                    _gameOver = YES;
                    [[GameState sharedInstance] saveState];
                    [self showGameOverLayer];

                
                }
                //[self.player.physicsBody applyImpulse:CGVectorMake(0.0f, 20.0f)];
            }
}

//------- Update Road -------
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self addMonster];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    
    
    if(_gameOver == NO)
    {
        if (self.lastUpdateTimeInterval)
        {
            _dt = currentTime - _lastUpdateTimeInterval;
        }
        else
        {
            _dt = 0;
        }
        
        CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
        self.lastUpdateTimeInterval = currentTime;
        if (timeSinceLast > TIME)
        {
            timeSinceLast = 1.0 / (TIME * 60.0);
            self.lastUpdateTimeInterval = currentTime;
        }
        
       
        [self updateScore];
        
        if(_gameStarted)
        {
            [self updateWithTimeSinceLastUpdate:timeSinceLast];
        }
    }
    
}

- (void)addMonster {
    
    int rand = arc4random()%2 +1;
    _countBall +=1;
    [self initRoad];
    if(_gameStarted)
    {
        if(_countBall==tempBall)
      {
            [self initBall];
            _countBall =0;
           [self initStaticBall];
        //tempBall =  arc4random()%3 +2;
      }
      else if(_countBall == rand )
      {
          [self initBall];
        
        }
     [self initRingFire];
        
        _countFire +=1;
     [self initCol];
        
        //if(_countBall==tempBall)
        //{
        
            //_countBall =0;
            //tempBall =  arc4random()%3 +1;
       // }
        
    
    }
    
}

-(void)initRingFire
{
    // Add Ring Fire Back
    float marginFire =0;
    
    if(self.frame.size.height > 320)
    {
        marginFire = 30;
    }
    else
    {
        marginFire = 15;
    
    }
    
    float postY = self.frame.size.height * 0.75; //self.frame.size.height * 0.75
    SKSpriteNode *  fire = [SKSpriteNode spriteNodeWithImageNamed:@"Luaduoi0001"];
    fire.position = CGPointMake(self.frame.size.width + fire.size.width/2, postY); //240
    fire.zPosition = 80;
    [self addChild:fire];
    
   // SKAction * actionMoveFire = [SKAction moveTo:CGPointMake(-fire.size.width/2, 240) duration:actualDurationFire];
     SKAction * actionMoveFire = [SKAction moveTo:CGPointMake(-fire.size.width/2, postY) duration:actualDurationFire];
    SKAction * actionMoveDoneFire = [SKAction removeFromParent];
    [fire runAction:[SKAction sequence:@[actionMoveFire, actionMoveDoneFire]]];
    
    
    SKAction *fireAction = [SKAction animateWithTextures:SPRITES_FIRE_BACK timePerFrame:0.2];
    //[SKAction repeatActionForever:]
    SKAction *fireAnim = [SKAction repeatActionForever:fireAction];
    [fire runAction:fireAnim];
    
    
    // Add Ring Fire Front
    SKSpriteNode *  fireFront = [SKSpriteNode spriteNodeWithImageNamed:@"LuaTren0001"];
    //fireFront.position = CGPointMake(self.frame.size.width + fireFront.size.width/2 +30 , 240);
    fireFront.position = CGPointMake(self.frame.size.width + fireFront.size.width/2 + marginFire , postY);
    fireFront.zPosition = 120;
    [self addChild:fireFront];
    //SKAction * actionMoveFireFont = [SKAction moveTo:CGPointMake(-fireFront.size.width/2+30, 240) duration:actualDurationFire];
    SKAction * actionMoveFireFont = [SKAction moveTo:CGPointMake(-fireFront.size.width/2 + marginFire, postY) duration:actualDurationFire]; //
    SKAction * actionMoveDoneFireFont = [SKAction removeFromParent];
    [fireFront runAction:[SKAction sequence:@[actionMoveFireFont, actionMoveDoneFireFont]]];
    
    SKAction *fontAction = [SKAction animateWithTextures:SPRITES_FIRE_FONT timePerFrame:0.2];
    SKAction *fontAnim = [SKAction repeatActionForever:fontAction];
    [fireFront runAction:fontAnim];
    
}
-(void)initStaticroad
{
    float postY = self.frame.size.height * 0.42; // 0.43
    for (int i = 0; i < 2; i++)
    {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"day"];
        float  bottomScrollerHeight = bg.size.height;
        bg.position = CGPointMake(i * bottomScrollerHeight, postY); // 135
        bg.anchorPoint = CGPointZero;
        bg.name = @"bg";
        bg.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bg.size];
        bg.physicsBody.collisionBitMask = 0;
        
        bg.physicsBody.affectedByGravity = NO;
        [self addChild:bg];
    }
    
}

-(void)initRoad
{
    
    // Create sprite
    float postY = self.frame.size.height * 0.425;
    SKSpriteNode *  road = [SKSpriteNode spriteNodeWithImageNamed:@"day"];
    // and along a random position along the Y axis as calculated above
    road.position = CGPointMake(self.frame.size.width + road.size.width/2, postY); //138
    [self addChild:road];
    int actualDuration =  30.0;
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-road.size.width/2, postY) duration:actualDuration]; //138
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [road runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    

}
-(void)initCol
{
    float postY = self.frame.size.height;
    float postYUp = self.frame.size.height *1.1;

    SKSpriteNode* upwardPiller = [self createPillerWithUpwardDirection:YES];
    upwardPiller.position = CGPointMake(self.frame.size.width + upwardPiller.size.width/2 + 10, postYUp); // 320

    
    
   SKSpriteNode* downwardPiller = [self createPillerWithUpwardDirection:NO];
    downwardPiller.position = CGPointMake(self.frame.size.width + downwardPiller.size.width/2 + 15, postY/2); //160
    
    
    /*
     * Create Upward Piller actions.
     * First action has to be the movement of pillar. Right to left.
     * Once first action is complete, remove that node from Scene
     */
    //int tempTime = _countFire*actualDurationFire;
    SKAction * upwardPillerActionMove = [SKAction moveTo:CGPointMake(-upwardPiller.size.width/2 + 10, postYUp) duration:actualDurationFire]; // 320
    SKAction * upwardPillerActionMoveDone = [SKAction removeFromParent];
    [upwardPiller runAction:[SKAction sequence:@[upwardPillerActionMove, upwardPillerActionMoveDone]]];
    
    
    // Create Downward Piller actions
    SKAction * downwardPillerActionMove = [SKAction moveTo:CGPointMake(-downwardPiller.size.width/2 + 15, postY/2) duration:actualDurationFire]; // 160
    SKAction * downwardPillerActionMoveDone = [SKAction removeFromParent];
    [downwardPiller runAction:[SKAction sequence:@[downwardPillerActionMove, downwardPillerActionMoveDone]]];
    
    
}


#pragma mark - Update Score
- (void) updateScore
{
    
    [self enumerateChildNodesWithName:COLUP usingBlock:^(SKNode *node, BOOL *stop)
     {
         if(self.player.position.x > node.position.x)
         {
             node.name = @"";    //Reset the name to empty name so as to not track the pillar once it has passed beyond the bird's position
             if(!_gameOver&&_gameStarted)
             _score+=1;
             
             /* Since there are 2 pillars(Top and bottom), we will this function will be fired 2 times.
              * So we take a reminder by dividing the current score with 2
              */
             [_lblScore setText:[NSString stringWithFormat:@"Score: %d",_score/2]];
             [GameState sharedInstance].score =_score/2;
             *stop = YES;    //To stop enumerating
         }
     }];
}



-(void)postFB
{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString * temp = [NSString stringWithFormat:@"Great! Your score is  %d points. You can get it now :)) %@",_score/2,@" https://itunes.apple.com/us/app/fun-circus/id864653276?l=vi&ls=1&mt=8"];
        [controller setInitialText:temp];
        [controller addImage:[UIImage imageNamed:@"AnhDangFaceBook.png"]];
        UIViewController *vc = self.view.window.rootViewController;
        [vc presentViewController:controller animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Fun Circus" message:@"Please login with your Facebook Acount in Setting " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


@end
