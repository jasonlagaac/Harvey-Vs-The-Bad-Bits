//
//  ProjectileCache.m
//  ShadowTypesNew
//
//  Created by neurologik on 2/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProjectileCache.h"
#import "Projectile.h"

@implementation ProjectileCache

@synthesize projectiles;

-(id) initWithGame:(GameLayer *)game {
  if ((self = [super init])) {
    theGame = game;
    self.projectiles = [CCArray arrayWithCapacity:60];
    nextInactiveProjectile = 0;
    
    for (int i = 0; i < 60; i++) {
      Projectile *p = [Projectile projectile];
      [[self projectiles] addObject:p];
      [game addChild:p z:8];
    }
  }
  return self;
}


-(void)fireFrom:(CGPoint)pos direction:(PlayerMovement)dir {
  if (nextInactiveProjectile >= [projectiles count]) {
    nextInactiveProjectile = 0;
  } else {
    Projectile *p = [self.projectiles objectAtIndex:nextInactiveProjectile];
    if (!p.visible)
      [p fireProjFrom:pos withPlayerhDirection:dir];
    
    nextInactiveProjectile++;
  }
}


-(void) runProjectileActions:(ccTime)delta {
  for (int i = 0; i < 60; i++) {
    Projectile *p = [[self projectiles] objectAtIndex:i];
    if (p.visible == YES) 
      [p updateProjectile:delta];
  }
}


@end
