//
//  Player.h
//  ShadowTypes
//
//  Created by neurologik on 20/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "SimpleAudioEngine.h"

#import "GameScene.h"

#define NUM_PLAYER_WALK_FRAMES 4

// Weapon Types
typedef enum  {
    kPlayerWeaponPistol,
    kPlayerWeaponMachineGun,
    kPlayerWeaponShotgun,
    kPlayerWeaponPhaser,
    kPlayerWeaponRocket,
    kPlayerWeaponRevolver,
    kPlayerWeaponFlamethrower,
    kPlayerWeaponGattlingGun,
    kPlayerWeaponGrenadeLauncher,
    kPlayerWeaponLaser,
    kPlayerWeaponShurikin,
    kPlayerWeaponCount
} PlayerWeapon;

// Movement Directions
typedef enum  {
    kPlayerMoveRight,
    kPlayerMoveLeft
} PlayerMovement;


@class GameLayer;

@interface Player : CCNode {
    /* Game Instance */
    GameLayer *theGame;    
  
    /* Physics Attribs */
    cpBody *body;          
    cpShape *shape;        
    
    /* Player Attributes */
    CCSprite *sprite;      
    PlayerWeapon weapon;   
    
    /* Movement values */
    PlayerMovement direction;   // Direction of movment by player
    BOOL playerAttacking;       // Determine if the player is in attack mode
    BOOL playerJumping;         // Determine if the player is jumping
    BOOL changeWeapon;
    BOOL playerDead;
    
    /* Animation Actions */
    CCAction *pistolWalkAction;
    CCAction *machineGunWalkAction;
    CCAction *shotgunWalkAction;
    CCAction *phaserWalkAction;
    CCAction *rocketWalkAction;
    CCAction *revolverWalkAction;
    CCAction *flamethrowerWalkAction;
    CCAction *gattlingGunWalkAction;
    CCAction *grenadeLauncherWalkAction;
    CCAction *laserWalkAction;
    CCAction *shurikinWalkAction;
}

@property (nonatomic, retain) GameLayer *theGame;
@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, readwrite) PlayerWeapon weapon;
@property (nonatomic, readwrite) PlayerMovement direction;
@property (nonatomic, readwrite) BOOL playerAttacking;
@property (nonatomic, readwrite) BOOL playerJumping;
@property (nonatomic, readwrite) BOOL playerDead;

@property (nonatomic, readwrite) cpBody  *body;
@property (nonatomic, readwrite) cpShape *shape;


@property (nonatomic, retain) CCAction *pistolWalkAction;
@property (nonatomic, retain) CCAction *machineGunWalkAction;
@property (nonatomic, retain) CCAction *shotgunWalkAction;
@property (nonatomic, retain) CCAction *phaserWalkAction;
@property (nonatomic, retain) CCAction *rocketWalkAction;
@property (nonatomic, retain) CCAction *revolverWalkAction;
@property (nonatomic, retain) CCAction *flamethrowerWalkAction;
@property (nonatomic, retain) CCAction *gattlingGunWalkAction;
@property (nonatomic, retain) CCAction *grenadeLauncherWalkAction;
@property (nonatomic, retain) CCAction *laserWalkAction;
@property (nonatomic, retain) CCAction *shurikinWalkAction;

-(id) initWithGame:(GameLayer *)game;
/** Restore the default sprite
 */ 
- (void)restoreDefaultSprite;

/** Animate the player's movement
 */
- (void)animateMove;

-(void)killedEnemy;

/** Move the player along the X axis
 *  @param velocity_x velocity on the x-axis from the input layer
 *  @param fireButtonActive;
 */
- (void)move:(float)velocity_x activeFireButton:(bool)fireButtonActive;


- (void)attack:(bool)fireButtonActive 
  nextShotTime:(float*)nextShotTime 
     totalTime:(float)totalTime;

- (void)jump;
- (void)land;
- (void)checkEnemyCollision;
- (void)changeWeapon;

@end