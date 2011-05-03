//
//  Enemy.m
//  ShadowTypes
//
//  Created by neurologik on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"


@implementation Enemy

@synthesize sprite;
@synthesize theGame;

@synthesize enemyType;
@synthesize direction;

@synthesize health;
@synthesize points;
@synthesize attack;


#pragma mark -
#pragma mark Enemy Attribute Initialisation

-(void) loadDefaultSprite {
    switch (self.enemyType) {
        case kEnemySmall:
            self.sprite = [CCSprite spriteWithSpriteFrameName:@"EnemySmall2.png"];
            break;
        case kEnemyLarge:
            self.sprite = [CCSprite spriteWithSpriteFrameName:@"EnemyLarge.png"];
            break;
    }
}

-(void) loadAnimations {
    NSMutableArray *enemySmallWalkFrames = [NSMutableArray array];
    
    for (int i = 1; i <= 5; i++) {
        [enemySmallWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"EnemySmall%d.png", i]]];
    }
    
    CCAnimation *enemySmallWalkAnim = [CCAnimation animationWithFrames:enemySmallWalkFrames delay:0.07f];
    
    self.enemyWalkAction  = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:enemySmallWalkAnim]];
    
}

-(void) loadPhysics {
    
    int numVert = 4;
    
    CGPoint verts[] = {
        ccp(-11, -18),
        ccp(-11,  18),
        ccp( 11,  18),
        ccp( 11, -18),
    };
    
    // Define the mass and movement of intertia
    body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, numVert, verts, CGPointZero));
    body->p = self.sprite.position;
    body->data = self;
    cpSpaceAddBody(theGame.space, body);
    
    // Define the polygonal shape
    shape = cpPolyShapeNew(body, numVert, verts, CGPointZero);
    
}


#pragma mark -
#pragma mark Alloc / Init / Dealloc

-(id) initWithGame:(GameLayer *)game withEnemyType:(EnemyType)enemy {    
    if( (self=[super init])) {
        self.theGame = game;
               
        [game addChild:self];
    }
    return self;
}

-(void) dealloc
{
	// don't forget to call "super dealloc"
    [theGame release];
	[super dealloc];
}




@end
