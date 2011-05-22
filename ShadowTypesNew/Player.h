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

// Weapon Types
typedef enum  {
    kPlayerWeaponPistol,
    kPlayerWeaponMachineGun,
    kPlayerWeaponShotgun,
    kPlayerWeaponPhaser,
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
    int points;            
    
    /* Movement values */
    PlayerMovement direction;   // Direction of movment by player
    BOOL playerAttacking;       // Determine if the player is in attack mode
    BOOL playerJumping;         // Determine if the player is jumping
    
    
    /* Animation Actions */
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
@property (nonatomic, readwrite) BOOL playerAttacking;
@property (nonatomic, readwrite) BOOL playerJumping;
@property (nonatomic, readwrite) cpBody  *body;
@property (nonatomic, readwrite) cpShape *shape;
@property (nonatomic, retain) CCAction *knifeWalkAction;
@property (nonatomic, retain) CCAction *pistolWalkAction;
@property (nonatomic, retain) CCAction *machineGunWalkAction;
@property (nonatomic, retain) CCAction *shotgunWalkAction;
@property (nonatomic, retain) CCAction *phaserWalkAction;
@property (nonatomic, readwrite) int points;

/** Restore the default sprite
 */ 
- (void)restoreDefaultSprite;

/** Animate the player's movement
 */
- (void)animateMove;

/** Stop player animations
 */
- (void)stopAnimations;

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

- (void)addPoint;


@end