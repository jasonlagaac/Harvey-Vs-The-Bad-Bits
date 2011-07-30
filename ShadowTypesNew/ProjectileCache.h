//
//  ProjectileCache.h
//  ShadowTypesNew
//
//  Created by neurologik on 2/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@class Projectile;
@class GameLayer;

@interface ProjectileCache : CCNode {
  GameLayer *theGame;
  
  CCArray *projectiles;
  
  int nextInactiveProjectile;
}

@property (nonatomic, retain) CCArray *projectiles;

-(id) initWithGame:(GameLayer *)game;
-(void)fireFrom:(CGPoint)pos direction:(PlayerMovement)dir;
-(void) runProjectileActions:(ccTime)delta;

@end
