//
//  BulletCache.h
//  ShadowTypes
//
//  Created by neurologik on 17/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Bullet.h"
#import "GameScene.h"

#define MAX_NUM_BULLETS 100


/** 
 *  BulletCache Class: Storing and reloading bullets
 */

@interface BulletCache : CCNode 
{
  /* Game Instance */
  GameLayer *theGame;
  
  /* Bullet Array */
  CCArray *bullets;
  
  /* Next bullet available number */
	int nextInactiveBullet;
}

/* Instance of the game */
@property (nonatomic, retain) GameLayer *theGame;

/* Array to hold the bullet objects */
@property (nonatomic, retain) CCArray *bullets;

/** Fire a stored bullet from the |bullets| array
 *  @param startPosition is the bullets start point
 *  @param direction which way the player is facing (determine direction)
 *  @param frameName bullet image to be loaded from image cache
 *  @param weapon type of weapon which player is currently assigned
 */

-(void) shootBulletFrom:(CGPoint)startPosition 
        playerDirection:(PlayerMovement)direction 
              frameName:(NSString*)frameName 
             weaponType:(PlayerWeapon)weapon;


/** Determine if the bullet has collided with an enemy
 */
-(void)bulletEnemyCollision;

@end