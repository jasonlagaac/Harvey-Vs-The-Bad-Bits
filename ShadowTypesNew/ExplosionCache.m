//
//  ExplosionCache.m
//  ShadowTypesNew
//
//  Created by neurologik on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExplosionCache.h"
#import "Explosion.h"


@implementation ExplosionCache

@synthesize explosions;

-(id) initWithGame:(GameLayer *)game {
  if ((self = [super init])) {
    theGame = game;
    self.explosions = [CCArray arrayWithCapacity:30];
    nextInactiveExplosion = 0;
    
    for (int i = 0; i < 30; i++) {
      Explosion *e = [Explosion explosion];
      [[self explosions] addObject:e];
      [game addChild:e z:4];
    }
  }
  return self;
}

- (void)dealloc {
  [theGame release];
  [super dealloc];
}

- (void)blastAt:(CGPoint)pos {
  Explosion *explosion = [self.explosions objectAtIndex:nextInactiveExplosion];
  
  [explosion blastAt:pos];
  
  nextInactiveExplosion++;
  
  if (nextInactiveExplosion >= [explosions count]) {
    nextInactiveExplosion = 0;
  }
}

@end
