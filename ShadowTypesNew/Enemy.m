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

@synthesize prevPos_x;


@synthesize body;
@synthesize shape;

@synthesize enemyFalling;
@synthesize started;

@synthesize enemyWalkAction;


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
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];

    
    self.sprite.position = CGPointMake(screenSize.width / 2, screenSize.height + 10);
    [theGame addChild:sprite z:10];
}

-(void) loadAnimations {
    NSMutableArray *enemySmallWalkFrames = [NSMutableArray array];
    
    for (int i = 1; i <= 5; i++) {
        [enemySmallWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"EnemySmall%d.png", i]]];
    }
    
    CCAnimation *enemySmallWalkAnim = [CCAnimation animationWithFrames:enemySmallWalkFrames delay:0.09f];
    
    self.enemyWalkAction  = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:enemySmallWalkAnim]];
    
}

-(void) loadPhysics {
    
    int numVert = 4;
    
    CGPoint verts[] = {
        ccp(-10.5, -18),
        ccp(-10.5,  18),
        ccp( 10.5,  18),
        ccp( 10.5, -18),
    };
    
    // Define the mass and movement of intertia
    body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, numVert, verts, CGPointZero));
    body->p = self.sprite.position;
    body->data = self;
    cpSpaceAddBody(theGame.space, body);
    
    // Define the polygonal shape
    shape = cpPolyShapeNew(body, numVert, verts, CGPointZero);
    shape->e = 0.0;
    shape->u = 1.0;
    shape->data = self.sprite;
    shape->group = 1;
    shape->collision_type = 0;
    cpBodySetMoment(shape->body, INFINITY);
    cpSpaceAddShape(theGame.space, shape);
    
}


#pragma mark -
#pragma mark Alloc / Init / Dealloc

-(id) initWithGame:(GameLayer *)game withEnemyType:(EnemyType)enemy {    
    if( (self=[super init])) {
        self.theGame = game;

        self.enemyType = kEnemySmall;
        self.direction = kEnemyMoveLeft;
        [self loadDefaultSprite];
        [self loadAnimations];
        [self loadPhysics];
    
        [[self sprite] runAction:enemyWalkAction];
        self.prevPos_x = (int)sprite.position.x;
        
        enemyFalling = NO;
        started = NO;
        
        [game addChild:self z:5];
                
		[self scheduleUpdate];
    }
    return self;
}

-(void) dealloc
{
	// don't forget to call "super dealloc"
    cpBodyFree(body);
    cpShapeFree(shape);
    [theGame release];
	[super dealloc];
}


#pragma mark - 
#pragma mark Enemy Movement

-(void) moveEnemy {
    if (self.direction == kEnemyMoveRight && self.body->v.y == 0)
        self.body->v.x = 100;
    else if (self.direction == kEnemyMoveLeft && self.body->v.y == 0)
        self.body->v.x = -100;
    
    if (self.body->v.x != 0)
        self.started = YES;
}

-(void) switchMoveDirection {
    if (prevPos_x == (int)self.sprite.position.x) {
        if (self.direction == kEnemyMoveLeft) {
            self.direction = kEnemyMoveRight;
            self.sprite.flipX = YES;
        } else {
            self.direction = kEnemyMoveLeft;
            self.sprite.flipX = NO;
        }
    }
    
    prevPos_x = (int)self.sprite.position.x;
}

// FIXME: Need to fix this damn thing. Freezes the whole thing!
-(void) enemyFall {
    if (self.body->v.y != 0 && enemyFalling == NO) {
        [[self sprite] stopAllActions];
        [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"EnemySmall2.png"]];
        enemyFalling = YES;
    } else if (self.body->v.y == 0 && enemyFalling == YES && started == YES) {
        [[self sprite] runAction:enemyWalkAction];
        enemyFalling = NO;
    }
}

#pragma mark -
#pragma mark Enemy Update Method 
-(void) update:(ccTime)delta {
    NSLog(@"Being called");
    [self moveEnemy];
    [self switchMoveDirection];
    [self enemyFall];
}





@end
