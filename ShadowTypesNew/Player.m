//
//  Player.m
//  ShadowTypes
//
//  Created by neurologik on 20/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "BulletCache.h"

@interface Player (private)
// Player Initialisation
-(void) loadAnimations;
-(void) loadDefaultSprite;
-(void) loadPhysics;

// Player General Actions
-(void) playerAnimateMove;
-(void) playerStopAnimations;
-(void) playerJumpFallSprite;
-(void) playerJumpingFalling;
-(void) playerLanded;
-(void) playerAttack:(bool)fireButtonActive nextShotTime:(float*)nextShotTime totalTime:(float)totalTime;
-(void)playerRespawn;



@end

@implementation Player

@synthesize theGame;
@synthesize sprite;
@synthesize weapon;
@synthesize direction;
@synthesize playerMoving;
@synthesize playerAttacking;
@synthesize playerJumping;

@synthesize body;
@synthesize shape;

@synthesize knifeWalkAction;
@synthesize pistolWalkAction;
@synthesize machineGunWalkAction;
@synthesize shotgunWalkAction;
@synthesize phaserWalkAction;


#pragma mark - 
#pragma mark Player Attribute Initialisation

-(void) loadSprites {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];

    self.weapon = kPlayerWeaponMachineGun;
    
    [self loadDefaultSprite];
    [[self.sprite texture] setAliasTexParameters];
    
    self.sprite.flipX = NO;    
    self.direction = kPlayerMoveRight;
    self.sprite.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    [theGame addChild:sprite z:6];

    
}

-(void) loadDefaultSprite {    
    switch (self.weapon) {
        case kPlayerWeaponPistol:
            self.sprite = [CCSprite spriteWithSpriteFrameName:@"PistolStill.png"];
            break;
        case kPlayerWeaponMachineGun:
            self.sprite = [CCSprite spriteWithSpriteFrameName:@"MachineGunStill.png"];
            break;
        case kPlayerWeaponShotgun:
            self.sprite = [CCSprite spriteWithSpriteFrameName:@"ShotgunStill.png"];
            break;
        case kPlayerWeaponPhaser:
            self.sprite = [CCSprite spriteWithSpriteFrameName:@"PhaserStill.png"];
            break;
    }
}

-(void) loadAnimations {
    NSMutableArray *pistolWalkFrames = [NSMutableArray array];
    NSMutableArray *machineGunWalkFrames = [NSMutableArray array];
    NSMutableArray *shotgunWalkFrames = [NSMutableArray array];
    NSMutableArray *phaserWalkFrames = [NSMutableArray array];

    for (int i = 1; i <= 4; i++) {
        [pistolWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Pistol%d.png", i]]];    
        [machineGunWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"MachineGun%d.png", i]]]; 
      
        [shotgunWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Shotgun%d.png", i]]]; 
        
        [phaserWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Phaser%d.png", i]]]; 
    }
    
    CCAnimation *pistolWalkAnim = [CCAnimation animationWithFrames:pistolWalkFrames delay:0.07f];
    self.pistolWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:pistolWalkAnim]];
    
    
    CCAnimation *machineGunWalkAnim = [CCAnimation animationWithFrames:machineGunWalkFrames delay:0.07f];
    self.machineGunWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:machineGunWalkAnim]];
    
    
    CCAnimation *shotgunWalkAnim = [CCAnimation animationWithFrames:shotgunWalkFrames delay:0.07f];
    self.shotgunWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:shotgunWalkAnim]];
    
    
    CCAnimation *phaserWalkAnim = [CCAnimation animationWithFrames:phaserWalkFrames delay:0.07f];
    self.phaserWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:phaserWalkAnim]];
}


-(void) loadPhysics {    
    int numVert = 4;
    
    // Define the player's verticies
    CGPoint verts[] = {
        ccp(-21, -20),
        ccp(-21,  20),
        ccp( 21,  20),
        ccp( 21, -20)
    };
    
    // Define the mass and the movement of intertia
    body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, numVert, verts, CGPointZero));
    body->p = self.sprite.position;
    body->data = self;
    cpSpaceAddBody(theGame.space, body);
    
    // Define the polygonal shape
    shape = cpPolyShapeNew(body, numVert, verts, CGPointZero);
    shape->e = 0.0;
    shape->u = 1.0;
    shape->data = sprite;
    shape->group = 1;
    shape->collision_type = 1;
    cpBodySetMoment(shape->body, INFINITY);
    cpSpaceAddShape(theGame.space, shape);
    
}

#pragma mark -
#pragma mark Alloc / Init / Dealloc

-(id) initWithGame:(GameLayer *)game {    
    if( (self=[super init])) {
        self.theGame = game;
        self.playerMoving = NO;
        self.playerAttacking = NO;
        self.playerJumping = NO;
        
        [self loadSprites];
        [self loadAnimations];
        [self loadPhysics];
        
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
#pragma mark Player Animation / Sprite Actions

-(void) restoreDefaultSprite {    
    switch (self.weapon) {
        case kPlayerWeaponPistol:
            [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"PistolStill.png"]];
            break;
            
        case kPlayerWeaponMachineGun:
            [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"MachineGunStill.png"]];
            break;
            
        case kPlayerWeaponShotgun:
            [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ShotgunStill.png"]];
            break;
            
        case kPlayerWeaponPhaser:
            [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"PhaserStill.png"]];
            break;
    }
}


-(void) playerAnimateMove {
    switch (self.weapon) {
        case kPlayerWeaponPistol:
            [[self sprite] runAction: pistolWalkAction];
            break;
        case kPlayerWeaponMachineGun:
            [[self sprite] runAction: machineGunWalkAction];
            break;
            
        case kPlayerWeaponShotgun:
            [[self sprite] runAction: shotgunWalkAction];
            break;
            
        case kPlayerWeaponPhaser:
            [[self sprite] runAction: phaserWalkAction];
            break;
    }
}


-(void) playerStopAnimations {
    [[self sprite] stopAllActions];
}

#pragma mark - 
#pragma mark Player Movement Actions

-(void) playerMovementX:(float)velocity_x {
    if (velocity_x >= 10) {
        body->v.x = playerJumping ? 200 :  250;
    } else if (velocity_x <= -10) {
        body->v.x = playerJumping ? -200 : -250;
    } else {
        body->v.x = 0;
    }
}

-(void) playerFacingDirection:(float)velocity_x {
    if (velocity_x  < -10 && self.direction == kPlayerMoveRight ) {
        self.sprite.flipX = YES;
        self.direction = kPlayerMoveLeft;
    } else if (velocity_x  > 10 && self.direction == kPlayerMoveLeft ) {
        self.sprite.flipX = NO;
        self.direction = kPlayerMoveRight;
    }
}

-(void) playerAnimateMovement:(float)velocity_x {
    if (velocity_x < -100 || velocity_x > 100) {
        if (self.playerMoving == NO && !self.playerJumping) {
            self.playerMoving = YES;
            [self playerAnimateMove];
        }
    } else  {
        if (self.playerMoving == YES || self.playerJumping) {
            self.playerMoving = NO;
            [self playerStopAnimations];
            
            if (!self.playerJumping)
                [self restoreDefaultSprite];
        }
    }
}

-(void) playerJumpFallSprite {
    switch (self.weapon) {
        case kPlayerWeaponPistol:
            [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"PistolJump.png"]];
            break;
            
        case kPlayerWeaponMachineGun:
            [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"MachineGunJump.png"]];
            break;
            
        case kPlayerWeaponShotgun:
            [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ShotgunJump.png"]];
            break;
            
        case kPlayerWeaponPhaser:
            [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"PhaserJump.png"]];
            break;
    }
}


-(void) playerJumpingFalling {
    if (self.body->v.y != 0) {
        [self playerJumpFallSprite];
        [self playerStopAnimations];
    } else {
        [self restoreDefaultSprite];
    }
}


-(void) playerJump {
    self.body->v.y = 300.0f;
    self.playerJumping = YES; 
    [self playerJumpFallSprite];
}

-(void) playerLanded {
    if (self.playerJumping) {
        cpBodyResetForces(self.body);
        self.playerJumping = NO;
    }
}

-(void) playerAttack:(bool)fireButtonActive nextShotTime:(float*)nextShotTime totalTime:(float)totalTime {
    CGPoint shotPos = CGPointZero;
    
    if (self.direction == kPlayerMoveRight) {
        shotPos = CGPointMake(self.sprite.position.x + 25, self.sprite.position.y + 7.0f);
    } else {
        shotPos = CGPointMake(self.sprite.position.x - 25, self.sprite.position.y + 7.0f);
    }
    
    switch (self.weapon) {
        case kPlayerWeaponPistol: // Single shot for the pistol
            if (fireButtonActive && !playerAttacking) {
                playerAttacking = YES;
                BulletCache *bulletCache = [theGame bulletCache];
                
                [bulletCache shootBulletFrom:shotPos playerDirection:self.direction frameName:@"Bullet.png" weaponType:self.weapon];
            } else if (!fireButtonActive && playerAttacking) {
                playerAttacking = NO;
            }
            break;
        case kPlayerWeaponMachineGun: // Rapid shot for the machine gun
            if (fireButtonActive && totalTime > *nextShotTime) {
                playerAttacking = YES;
                *nextShotTime = totalTime + 0.1f;
                
                BulletCache *bulletCache = [theGame bulletCache];                
                [bulletCache shootBulletFrom:shotPos playerDirection:self.direction frameName:@"Bullet.png" weaponType:self.weapon];
                
            } else if (!fireButtonActive && playerAttacking) {
                playerAttacking = NO;
                nextShotTime = 0;
            }
            break;
            
        
        case kPlayerWeaponShotgun: // Single delayed shot for shotgun
            if (fireButtonActive && !playerAttacking && totalTime > *nextShotTime) {
                
                *nextShotTime = totalTime + 0.5f;
                
                
                playerAttacking = YES;
                BulletCache *bulletCache = [theGame bulletCache];
                
                [bulletCache shootBulletFrom:shotPos playerDirection:self.direction frameName:@"Bullet.png" weaponType:self.weapon];
            } else if (!fireButtonActive && playerAttacking == YES) {
                playerAttacking = NO;
            }
            
            break;
            
        case kPlayerWeaponPhaser: // Single shot for phaser
            if (fireButtonActive && !playerAttacking) {
                playerAttacking = YES;
                BulletCache *bulletCache = [theGame bulletCache];
                
                [bulletCache shootBulletFrom:shotPos playerDirection:self.direction frameName:@"PhaserBullet.png" weaponType:self.weapon];
            } else if (!fireButtonActive && playerAttacking) {
                playerAttacking = NO;
            }
            break;
         
    } 
    
}

-(void)playerRespawn {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];

    body->p = CGPointMake(screenSize.width / 2, screenSize.height +10);
}


#pragma mark -
#pragma mark Update actions

-(void)update:(ccTime)delta {
    [self playerJumpingFalling];
    
    if (self.sprite.position.y < -30.0f) {
        [self playerRespawn];
    }
}


@end
