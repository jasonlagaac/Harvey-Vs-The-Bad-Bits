//
//  BulletCache.m
//  ShadowTypes
//
//  Created by neurologik on 17/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BulletCache.h"
#import "GameScene.h"

@implementation BulletCache

@synthesize theGame;        @synthesize bullets;

/* Initialise the game */
-(id) initWithGame:(GameLayer *) game
{
	if ((self = [super init]))
	{
    self.theGame = game;
    self.bullets = [CCArray arrayWithCapacity:MAX_NUM_BULLETS];
    nextInactiveBullet = 0;
    
    // Load bullet instances into the cache
    for (int i = 0; i < MAX_NUM_BULLETS; i++) {
      Bullet *b = [Bullet bullet];
      [[self bullets] addObject:b];
      [game addChild:b z:7];
    }
	}
	
	return self;
}

- (void)dealloc {
  [bullets release];
  bullets = nil;
    
  [theGame release];
  theGame = nil;
  
  [super dealloc];
}

/* Determine if any bullets in the cache have collided with an enemy */
-(void)bulletEnemyCollision {
  
  EnemyCache *enemyCache = [[self theGame] enemyCache];
  
  for (int i = 0; i < MAX_ENEMIES; i++) {
    Enemy *enemy = [[enemyCache enemies] objectAtIndex:i];   
    for (int j = 0; i < MAX_NUM_BULLETS; j++) {
      Bullet *bullet = [bullets objectAtIndex:j];
      if (ccpDistance(bullet.position, enemy.sprite.position) < 70) {
        [enemy damage:bullet.damage];
        [bullet reinit];
      }
    }
  }
}


/* Fire bullet from the cache */
-(void) shootBulletFrom:(CGPoint)startPosition playerDirection:(PlayerMovement)direction 
              frameName:(NSString*)frameName weaponType:(PlayerWeapon)weapon {
  
  Bullet *bullet = nil;
  
  switch (weapon) {
      
    case kPlayerWeaponShotgun:
      
      // Fire the next five bullets;
      for (int i = 0; i < 5; i++) {
        if ((nextInactiveBullet + i) < MAX_NUM_BULLETS) {
          // Check if the next bullet is within the MAX limits.
          bullet = [bullets objectAtIndex:nextInactiveBullet + i];
          [bullet fire:startPosition direction:direction  frameName:frameName weaponType:weapon];
          nextInactiveBullet++;
        } else {
          // Reset back to the first bullet
          nextInactiveBullet = 0;
        }
      }
      break;

    default:
      bullet = [bullets objectAtIndex:nextInactiveBullet];
      [bullet fire:startPosition direction:direction frameName:frameName weaponType:weapon];
      nextInactiveBullet++;
      break;
  }
  
  if (nextInactiveBullet >= MAX_NUM_BULLETS)
	{
		nextInactiveBullet = 0;
	}
  
}

@end
