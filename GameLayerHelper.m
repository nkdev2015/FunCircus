//
//  GameLayerHelper.m
//  FunCircus
//
//  Created by khangfet on 4/8/14.
//  Copyright (c) 2014 khangfet. All rights reserved.
//

#import "GameLayerHelper.h"

@implementation GameLayerHelper
- (id)initWithSize:(CGSize)size
{
    self = [super init];
    if (self)
    {
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithWhite:1.0 alpha:0.0] size:size];
        node.anchorPoint = CGPointZero;
        [self addChild:node];
        node.zPosition = -1;
        node.name = @"transparent";
    }
    return self;
}
@end
