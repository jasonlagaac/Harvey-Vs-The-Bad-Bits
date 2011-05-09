//
//  Player.h
//  ShadowTypes
//
//  Created by neurologik on 20/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"


typedef enum  {
    kPlayerWeaponPistol,
    kPlayerWeaponMachineGun,
    kPlayerWeaponShotgun,
    kPlayerWeaponPhaser
} PlayerWeapon;

typedef enum  {
    kPlayerMoveRight,
    kPlayerMoveLeft
} PlayerMovement;


@class GameLayer;

@interface Player : CCNode {
    // Game Entities
    GameLayer *theGame;
    
    // Phyiscs Attribs
    cpBody *body;
    cpShape *shape;
    
    // Player Attribs
    CCSprite *sprite;
    PlayerWeapon weapon; 
    int hp;
    int points;
    
    
    // Movement values;
    PlayerMovement direction;
    BOOL playerMoving;
    BOOL playerAttacking;
    BOOL playerJumping;
    
    
    // Animation Actions
    CCAction *knifeWalkAction;    
    CCAction *pistolWalkAction;
    CCAction *machineGunWalkAction;
    CCAction *shotgunWalkAction;
    CCAction *phaserWalkAction;
}

@property (nonatomic, retain) GameLayer *theGame;
@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, readwrite) PlayerWeapon weapon;

@property (nonatomic, readwrite) PlayerMovement direction;
@property (nonatomic, readwrite) BOOL playerMoving;
@property (nonatomic, readwrite) BOOL playerAttacking;
@property (nonatomic, readwrite) BOOL playerJumping;


@property (nonatomic, readwrite) cpBody  *body;
@property (nonatomic, readwrite) cpShape *shape;

@property (nonatomic, retain) CCAction *knifeWalkAction;
@property (nonatomic, retain) CCAction *pistolWalkAction;
@property (nonatomic, retain) CCAction *machineGunWalkAction;
@property (nonatomic, retain) CCAction *shotgunWalkAction;
@property (nonatomic, retain) CCAction *phaserWalkAction;

-(void) restoreDefaultSprite;
-(void) playerAnimateMove;
-(void) playerStopAnimations;

-(void) playerMovementX:(float)velocity_x;
-(void) playerFacingDirection:(float)velocity_x;
-(void) playerAnimateMovement:(float)velocity_x;

-(void) playerAttack:(bool)fireButtonActive 
        nextShotTime:(float*)nextShotTime 
           totalTime:(float)totalTime;

-(void) playerJump;
-(void) playerLanded;
-(void) playerEnemyCollision;


@end