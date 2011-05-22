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
  [theGame release];
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
        NSLog(@"Hit");
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
    case kPlayerWeaponPistol:
      bullet = [bullets objectAtIndex:nextInactiveBullet];
      [bullet fire:startPosition direction:direction frameName:frameName weaponType:weapon];
      nextInactiveBullet++;
      
      break;
    case kPlayerWeaponMachineGun:
      bullet = [bullets objectAtIndex:nextInactiveBullet];
      [bullet fire:startPosition direction:direction frameName:frameName weaponType:weapon];
      nextInactiveBullet++;
      
      break;
      
    case kPlayerWeaponShotgun:
      // Shotgun - Fires five bullets at once
      
      if ((nextInactiveBullet + 5) >= [bullets count])
        // If bullet count is greater than the total
        // then start again from 0
        nextInactiveBullet = 0;
      
      // Fire the next five bullets;
      for (int i = 0; i < 5; i++) {
        bullet = [bullets objectAtIndex:nextInactiveBullet + i];
        [bullet fire:startPosition direction:direction  frameName:frameName weaponType:weapon];
        nextInactiveBullet++;
      }
      
      break;
    case kPlayerWeaponPhaser:
      bullet = [bullets objectAtIndex:nextInactiveBullet];
      [bullet fire:startPosition direction:direction frameName:frameName weaponType:weapon];
      nextInactiveBullet++;
      
      break;
      
    default:
      break;
  }
  
	if (nextInactiveBullet >= [bullets count] || (nextInactiveBullet + 5) >= [bullets count])
	{
		nextInactiveBullet = 0;
	}
  
}

@end
