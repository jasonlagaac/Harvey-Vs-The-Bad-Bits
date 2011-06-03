//
//  ExplosionCache.h
//  ShadowTypesNew
//
//  Created by neurologik on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Explosion;
@class GameLayer;

@interface ExplosionCache : CCNode {
  GameLayer *theGame;
  
  CCArray *explosions;
  
  int nextInactiveExplosion;
}
@property (nonatomic, retain) CCArray *explosions;

-(void) blastAt:(CGPoint)pos;

@end
