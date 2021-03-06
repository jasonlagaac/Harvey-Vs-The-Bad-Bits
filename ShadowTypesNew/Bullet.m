//
//  Bullet.m
//  ShadowTypes
//
//  Created by neurologik on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"


@interface Bullet (PrivateMethods) 
/* Initialise the bullet with default image */
- (id)initWithBulletImage;
- (void)bulletScatter;
@end

@implementation Bullet

@synthesize velocity;     @synthesize startPos;
@synthesize weaponType;   @synthesize damage;

#pragma mark - Initialisation / Deallocation / Singleton
/* Bullet Singleton */
+(id) bullet {
  return [[[self alloc] initWithBulletImage] autorelease];
}

/* Initialise with default image */
-(id) initWithBulletImage {
	if ((self = [super initWithSpriteFrameName:@"Bullet.png"])) {
    self.visible = NO;
  }
	return self;
}

/* Deallocate object */
-(void) dealloc {	
   GameLayer *game = [GameLayer sharedGameLayer];
   [game removeChild:self cleanup:YES];
   [super dealloc];
}


/* Reinitialise the bullet */
-(void)reinit {
  self.visible = NO;
  self.weaponType = 0;
  self.startPos = CGPointZero;
  
  // Stop actions and unschedule update
  [self stopAllActions];
  [self unscheduleAllSelectors];
}


#pragma mark - Bullet Action
/* Fire the bullet from a point */
-(void) fire:(CGPoint)startPosition direction:(int)direction frameName:(NSString*)frameName weaponType:(int)weapon {
  // Determine the bullet's velocity based on the weapon selected
  switch (weapon) {
    case kPlayerWeaponPistol:
      self.velocity = CGPointMake(10, 0);
      self.damage = 5;
      break;
    case kPlayerWeaponMachineGun:
      self.velocity = CGPointMake(10, 0);
      self.damage = 5;
      break;
      
    case kPlayerWeaponShotgun:
      self.velocity = CGPointMake((arc4random() % 6 + 4), 0);
      self.damage = 3;
      break;
    case kPlayerWeaponPhaser:
      self.velocity = CGPointMake(12, 0);
      self.damage = 5;
      break;
      
    case kPlayerWeaponGattlingGun:
      self.velocity = CGPointMake(15, 0);
      self.damage = 5;
      break;
      
    case kPlayerWeaponRevolver:
      self.velocity = CGPointMake(12, 0);
      self.damage = 10;
      break;

    case kPlayerWeaponRocket:
      self.velocity = CGPointMake(15, 0);
      self.damage = 10;
      break;
      
    case kPlayerWeaponLaser:
      self.velocity = CGPointMake(20, 0);
      self.damage = 30;
      break;
      
    case kPlayerWeaponShurikin:
      self.velocity = CGPointMake(15, 0);
      self.damage = 5;
      break;
      
    default:
      break;
  }
  
  // Direction of the velocity based on the player's movement
  if (direction == kPlayerMoveLeft) 
    self.velocity = CGPointMake(-self.velocity.x, 0);
  
	self.position = startPosition;
  self.startPos = startPosition;
	self.visible = YES;
  self.weaponType = weapon;
  
	// change the bullet's texture by setting a different SpriteFrame to be displayed
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
	[self setDisplayFrame:frame];
	[self bulletScatter];
  
  // Start the update
	[self scheduleUpdate];
  
}

- (void)bulletScatter {
  float randYVel;
  
  // Determine the scatter pattern of the bullet when 
  // fired from a specific weapon
  switch (weaponType) {
    case kPlayerWeaponMachineGun:
      randYVel = ((arc4random() % 2));
      
      randYVel = (arc4random() % 2) ? abs(randYVel) : -abs(randYVel);
      randYVel *= 0.5f;
      break;
      
    case kPlayerWeaponShotgun:
      randYVel = ((arc4random() % 3));
      
      randYVel = (arc4random() % 2) ? abs(randYVel) : -abs(randYVel);
      randYVel *= 0.5f;
      break;
      
    case kPlayerWeaponGattlingGun:
      randYVel = ((arc4random() % 3));
      
      randYVel = (arc4random() % 2) ? abs(randYVel) : -abs(randYVel);
      randYVel *= 0.5f;
      break;
      
    default:
      randYVel = 0;
      break;
  }
  
  // Determine bullet velocity
  self.velocity = CGPointMake(velocity.x, randYVel); 
}

#pragma mark - Collision Detection
/* Detect collision between the bullet and enemy */
- (void)detectEnemyCollision {
  GameLayer *game = [GameLayer sharedGameLayer];
  EnemyCache *ec = [game enemyCache];    
  
  for (int i = 0; i < MAX_ENEMIES; i++) {
    // Load an enemy from the enemy cache
    Enemy *e = [[ec enemies] objectAtIndex:i];   
    if (e.activeInGame) { 
      // Determine the distance
      if (ccpDistance(self.position, e.sprite.position) < 15) {
        if (weaponType == kPlayerWeaponRocket) {
          [[[GameLayer sharedGameLayer] explosionCache]blastAt:self.position explosionType:kExplosionPlayer];
        }
        
        [e damage:self.damage];   
        
        if (weaponType != kPlayerWeaponShotgun && weaponType != kPlayerWeaponLaser) 
          [self reinit];
      }
    }
  }
}


#pragma mark - Step / Update Function
/* Scheduled update function */
- (void)update:(ccTime)delta {
  
  
  // Move the bullet
	self.position = ccpAdd(self.position, velocity);
	
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
  
  // When the bullet leaves the screen, make it invisible
  switch (self.weaponType) {
    // Shotgun bullets have a shorter distance
    case kPlayerWeaponShotgun:
      if (self.position.x > (self.startPos.x + 100) || 
          self.position.x < (self.startPos.x - 100) || 
          self.position.x > screenSize.width  || self.position.x < 0){
        [self reinit];
      }
      break;
      
    case kPlayerWeaponRocket:
      if (self.position.x > screenSize.width || self.position.x < 0) {
        [[[GameLayer sharedGameLayer] explosionCache]blastAt:self.position explosionType:kExplosionPlayer];
        [self reinit];
      }
    default:
      if (self.position.x > screenSize.width || self.position.x < 0)
        [self reinit];
  }
  
  // Detect bullet collision with enemy object
  [self detectEnemyCollision];
}



@end
