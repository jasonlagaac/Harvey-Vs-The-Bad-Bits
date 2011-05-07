//
//  Enemy.m
//  ShadowTypes
//
//  Created by neurologik on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"


@interface Enemy (private)
-(void) loadDefaultSprite;
-(void) loadAnimations;
-(void) loadPhysics;
@end


@implementation Enemy

@synthesize sprite;
@synthesize theGame;

@synthesize enemyType;
@synthesize direction;

@synthesize health;
@synthesize points;

@synthesize prevPos_x;
@synthesize spawnPos;

@synthesize body;
@synthesize shape;

@synthesize enemyFalling;
@synthesize started;
@synthesize active;

@synthesize enemyWalkAction;


#pragma mark -
#pragma mark Init/Dealloc and Singleton Methods

+(id)enemy {
    return [[[self alloc] init] autorelease];
}

-(id) init {
	if ((self = [super init])) {
        
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
    
    self.sprite.position = self.spawnPos;
    [theGame addChild:sprite z:5];
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
-(void) LoadIntoGame:(GameLayer *)game withEnemyType:(EnemyType)type withSpawnPoint:(CGPoint) spawn withOrder:(int)order {    
    self.theGame = game;
    self.enemyType = type;
    self.spawnPos = spawn;
    
    if (arc4random() % kNumEnemyMovements) {
        self.sprite.flipX = YES;
        self.direction = kEnemyMoveRight;
    } else {
        self.sprite.flipX = NO;
        self.direction = kEnemyMoveLeft;
    } 
    
    
    self.prevPos_x = (int)sprite.position.x;
    
    enemyFalling = NO;
    started = NO;
    
    [self loadDefaultSprite];
    [self loadAnimations];
    [self loadPhysics];
    
    [[self sprite] runAction:enemyWalkAction];
    self.prevPos_x = (int)sprite.position.x;
    
    enemyFalling = NO;
    started = NO;
    self.active = YES;
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

-(void)enemyRespawn {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    if (arc4random() % kNumEnemyMovements) {
        self.sprite.flipX = YES;
        self.direction = kEnemyMoveRight;
    } else {
        self.sprite.flipX = NO;
        self.direction = kEnemyMoveLeft;
    }
    
    self.body->p = CGPointMake(screenSize.width / 2, screenSize.height + 10);
    self.prevPos_x = (int)sprite.position.x;
    
    enemyFalling = NO;
    started = NO;

}

#pragma mark -
#pragma mark Enemy Update Method 
-(void) update:(ccTime)delta { 
    [self moveEnemy];
    [self switchMoveDirection];
    [self enemyFall];
    
    if (self.sprite.position.y < -30.0f)
        [self enemyRespawn];
    
    NSLog(@"pos y:%f", self.sprite.position.y);
}





@end
