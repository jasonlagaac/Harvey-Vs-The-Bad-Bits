//
//  Explosion.h
//  ShadowTypesNew
//
//  Created by neurologik on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameScene.h"

#define NUM_EXPLOSION_FRAMES 5

typedef enum {
  kExplosionPlayer,
  kExplosionEnemy
} explosionType;

@interface Explosion : CCSprite {
  /* Explosion Type */
  explosionType type;
  
  /* Explosion animation */
  CCAnimation *explosionAnimation;
  
  BOOL active;
}

@property (nonatomic, retain) CCAnimation *explosionAnimation;

/* Explosion Singleton */
+(id) explosion;

/* Run explosion animation */
-(void) blastAt:(CGPoint)pos;

@end
