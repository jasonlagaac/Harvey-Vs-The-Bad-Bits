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

-(id) initWithGame:(GameLayer *)game;
- (void)blastAt:(CGPoint)pos explosionType:(int)type;

@end
