//
//  ViewController.m
//  FunCircus
//
//  Created by khangfet on 4/7/14.
//  Copyright (c) 2014 khangfet. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "StartScene.h"
#import <QuartzCore/QuartzCore.h>
@implementation ViewController

- (void)viewDidLoad
{
    
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        //skView.showsFPS = YES;
        //skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
               [self initBanner:skView];
        
        // Present the scene.
        [skView presentScene:scene];
    }
}


-(void)initBanner:(SKView*)skView
{
    return;
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
