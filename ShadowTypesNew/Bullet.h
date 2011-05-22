//
//  Bullet.h
//  ShadowTypes
//
//  Created by neurologik on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


#import "Player.h"
#import "GameScene.h"
#import "EnemyCache.h"

/** Bullet: Bullet object to be fired by the player
 */
@interface Bullet : CCSprite {
  /* Bullet velocity */
  CGPoint velocity;
  
  /* Bullet start position */
  CGPoint startPos;
  
  /* Bullet type in regards to weapon */
  int weaponType;
  
  /* Damage that bullet deals */
  int damage;
}

@property (readwrite, nonatomic) CGPoint velocity;
@property (readwrite, nonatomic) CGPoint startPos;
@property (readwrite, nonatomic) int weaponType;
@property (readwrite, nonatomic) int damage;

/** Bullet Singleton
 */
+ (id)bullet;


/** Fire: Fire bullet
 *  @param startPosition: fire bullet from position
 *  @param direction: direction the bullet is to be fired
 *  @param frameName: bullet type frame
 *  @param weapon: Bullet from weapon type
 */
- (void)fire:(CGPoint)startPosition 
            direction:(int)direction 
            frameName:(NSString*)frameName 
           weaponType:(int)weapon;

/** Reinit: Re-initialise the bullet
 */
- (void)reinit;

@end
