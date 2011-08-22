//
//  Player.m
//  ShadowTypes
//
//  Created by neurologik on 20/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "BulletCache.h"
#import "ProjectileCache.h"

@interface Player (private)
// Player Initialisation
- (void)loadAnimations;
- (void)loadSound;
- (void)loadPhysics;

// Player General Actions
- (void)animateMove;
- (void)landedCheck;
- (void)respawn;
- (int)weaponRecoil;

- (void)facingDirection:(float)velocity_x;
- (void)animateMovement:(float)velocity_x;

- (void)attack:(bool)fireButtonActive 
  nextShotTime:(float*)nextShotTime 
     totalTime:(float)totalTime;
@end

@implementation Player

@synthesize theGame;                    @synthesize sprite;
@synthesize weapon;                     @synthesize direction;
@synthesize playerAttacking;            @synthesize playerJumping;
@synthesize body;                       @synthesize shape;
@synthesize pistolWalkAction;           @synthesize machineGunWalkAction;       
@synthesize phaserWalkAction;           @synthesize points;
@synthesize rocketWalkAction;           @synthesize revolverWalkAction;
@synthesize flamethrowerWalkAction;     @synthesize gattlingGunWalkAction;
@synthesize grenadeLauncherWalkAction;  @synthesize laserWalkAction;
@synthesize shurikinWalkAction;         @synthesize shotgunWalkAction;



#pragma mark - 
#pragma mark Player Attribute Initialisation

-(void) loadSprites {
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  
  self.weapon = kPlayerWeaponPistol;
  self.sprite = [CCSprite spriteWithSpriteFrameName:@"Pistol1.png"];

  
  [[self.sprite texture] setAliasTexParameters];
  
  self.sprite.flipX = NO;    
  self.direction = kPlayerMoveRight;
  self.sprite.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
  [super addChild:sprite z:11];
}


-(void) loadAnimations {
  NSMutableArray *pistolWalkFrames = [NSMutableArray array];
  NSMutableArray *machineGunWalkFrames = [NSMutableArray array];
  NSMutableArray *shotgunWalkFrames = [NSMutableArray array];
  NSMutableArray *phaserWalkFrames = [NSMutableArray array];
  NSMutableArray *rocketWalkFrames = [NSMutableArray array];
  NSMutableArray *revolverWalkFrames = [NSMutableArray array];
  NSMutableArray *flamethrowerWalkFrames = [NSMutableArray array];
  NSMutableArray *gattlingGunWalkFrames = [NSMutableArray array];
  NSMutableArray *grenadeLauncherWalkFrames = [NSMutableArray array];
  NSMutableArray *laserWalkFrames = [NSMutableArray array];
  NSMutableArray *shurikinWalkFrames = [NSMutableArray array];

  
  for (int i = 1; i <= NUM_PLAYER_WALK_FRAMES; i++) {
    [pistolWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                 spriteFrameByName:[NSString stringWithFormat:@"Pistol%d.png", i]]];    
    [machineGunWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                     spriteFrameByName:[NSString stringWithFormat:@"MachineGun%d.png", i]]]; 
    
    [shotgunWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                  spriteFrameByName:[NSString stringWithFormat:@"Shotgun%d.png", i]]]; 
    
    [phaserWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                 spriteFrameByName:[NSString stringWithFormat:@"Phaser%d.png", i]]]; 
    
    [rocketWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                 spriteFrameByName:[NSString stringWithFormat:@"Rocket%d.png", i]]];
    
    [revolverWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                 spriteFrameByName:[NSString stringWithFormat:@"Revolver%d.png", i]]];
    
    [flamethrowerWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                   spriteFrameByName:[NSString stringWithFormat:@"Flamethrower%d.png", i]]];
    
    [gattlingGunWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                       spriteFrameByName:[NSString stringWithFormat:@"Gattling%d.png", i]]];
    
    [grenadeLauncherWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                      spriteFrameByName:[NSString stringWithFormat:@"Grenade%d.png", i]]];
    
    [laserWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                               spriteFrameByName:[NSString stringWithFormat:@"Laser%d.png", i]]];

    [shurikinWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                spriteFrameByName:[NSString stringWithFormat:@"Shurikin%d.png", i]]];

     
  }
  
  CCAnimation *pistolWalkAnim = [CCAnimation animationWithFrames:pistolWalkFrames delay:0.07f];
  self.pistolWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:pistolWalkAnim]];
  
  
  CCAnimation *machineGunWalkAnim = [CCAnimation animationWithFrames:machineGunWalkFrames delay:0.07f];
  self.machineGunWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:machineGunWalkAnim]];
  
  
  CCAnimation *shotgunWalkAnim = [CCAnimation animationWithFrames:shotgunWalkFrames delay:0.07f];
  self.shotgunWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:shotgunWalkAnim]];
  
  
  CCAnimation *phaserWalkAnim = [CCAnimation animationWithFrames:phaserWalkFrames delay:0.07f];
  self.phaserWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:phaserWalkAnim]];

  CCAnimation *rocketWalkAnim = [CCAnimation animationWithFrames:rocketWalkFrames delay:0.07f];
  self.rocketWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:rocketWalkAnim]];
  
  CCAnimation *revolverWalkAnim = [CCAnimation animationWithFrames:revolverWalkFrames delay:0.07f];
  self.revolverWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:revolverWalkAnim]];

  CCAnimation *flamethrowerWalkAnim = [CCAnimation animationWithFrames:flamethrowerWalkFrames delay:0.07f];
  self.flamethrowerWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flamethrowerWalkAnim]];
  
  CCAnimation *gattlingGunWalkAnim = [CCAnimation animationWithFrames:gattlingGunWalkFrames delay:0.07f];
  self.gattlingGunWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:gattlingGunWalkAnim]];

  CCAnimation *grenadeWalkAnim = [CCAnimation animationWithFrames:grenadeLauncherWalkFrames delay:0.07f];
  self.grenadeLauncherWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:grenadeWalkAnim]];
  
  CCAnimation *laserWalkAnim = [CCAnimation animationWithFrames:laserWalkFrames delay:0.07f];
  self.laserWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:laserWalkAnim]];
  
  CCAnimation *shurikinWalkAnim = [CCAnimation animationWithFrames:shurikinWalkFrames delay:0.07f];
  self.shurikinWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:shurikinWalkAnim]];
  
}

-(void) loadPhysics {    
  int numVert = 4;
  
  // Define the player's verticies
  CGPoint verts[] = {
    ccp(-15, -22),
    ccp(-15,  22),
    ccp( 15,  22),
    ccp( 15, -22)
  };
  
  // Define the mass and the movement of intertia
  body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, numVert, verts, CGPointZero));
  body->p = self.sprite.position;
  body->data = self;
  cpSpaceAddBody(theGame.space, body);
  
  // Define the polygonal shape
  shape = cpPolyShapeNew(body, numVert, verts, CGPointZero);
  shape->e = 0.0;
  shape->u = 1.0;
  shape->data = sprite;
  shape->group = 1;
  shape->collision_type = 1;
  cpBodySetMoment(shape->body, INFINITY);
  cpSpaceAddShape(theGame.space, shape);
  
}

#pragma mark -
#pragma mark Alloc / Init / Dealloc

-(id) initWithGame:(GameLayer *)game {    
  if( (self=[super init])) {
    self.theGame = game;
    self.playerAttacking = NO;
    self.playerJumping = NO;
    changeWeapon = NO;
    
    [self loadSprites];
    [self loadAnimations];
    [self loadPhysics];
    
    [game addChild:self z:9];
    
    [self scheduleUpdate];
  }
  
  return self;
}

-(void) dealloc
{
	// don't forget to call "super dealloc"
  cpBodyFree(body);
  cpShapeFree(shape);
  [theGame release];
	[super dealloc];
}


#pragma mark -
#pragma mark Player Animation / Sprite Actions

-(void) restoreDefaultSprite {    
  switch (self.weapon) {
    case kPlayerWeaponPistol:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"Pistol1.png"]];
      break;
      
    case kPlayerWeaponMachineGun:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"MachineGun1.png"]];
      break;
      
    case kPlayerWeaponShotgun:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"Shotgun1.png"]];
      break;
      
    case kPlayerWeaponPhaser:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"Phaser1.png"]];
      break;
      
    case kPlayerWeaponRevolver:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"Revolver1.png"]];
      break;
      
    case kPlayerWeaponRocket:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"Rocket1.png"]];
      break;
      
    case kPlayerWeaponFlamethrower:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"Flamethrower1.png"]];
      break;
      
    case kPlayerWeaponGattlingGun:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"Gattling1.png"]];
      break;
      
    case kPlayerWeaponGrenadeLauncher:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"Grenade1.png"]];
      break;
      
    case kPlayerWeaponLaser:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"Laser1.png"]];
      break;
      
    case kPlayerWeaponShurikin:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"Shurikin1.png"]];
      break;
      
    default:
      break;
  }
}


-(void) animateMove {
  if ([self.sprite numberOfRunningActions] == 0) {
    switch (self.weapon) {
      case kPlayerWeaponPistol:
        [[self sprite] runAction: pistolWalkAction];
        break;
      case kPlayerWeaponMachineGun:
        [[self sprite] runAction: machineGunWalkAction];
        break;
        
      case kPlayerWeaponShotgun:
        [[self sprite] runAction: shotgunWalkAction];
        break;
        
      case kPlayerWeaponPhaser:
        [[self sprite] runAction: phaserWalkAction];
        break;
        
      case kPlayerWeaponRocket:
        [[self sprite] runAction: rocketWalkAction];
        break;     
        
      case kPlayerWeaponRevolver:
        [[self sprite] runAction: revolverWalkAction];
        break;
        
      case kPlayerWeaponFlamethrower:
        [[self sprite] runAction: flamethrowerWalkAction];
        break;  
        
      case kPlayerWeaponGattlingGun:
        [[self sprite] runAction: gattlingGunWalkAction];
        break;  
        
      case kPlayerWeaponGrenadeLauncher:
        [[self sprite] runAction: grenadeLauncherWalkAction];
        break;  
        
      case kPlayerWeaponLaser:
        [[self sprite] runAction: laserWalkAction];
        break;
        
      case kPlayerWeaponShurikin:
        [[self sprite] runAction: shurikinWalkAction];
        break;
        
      default:
        break;
    }
  }
}



#pragma mark - 
#pragma mark Player Movement Actions

-(void) move:(float)velocity_x activeFireButton:(bool)fireButtonActive {
  int recoil = 0;
  
  if (fireButtonActive)
    recoil = [self weaponRecoil];
  
  [self facingDirection:velocity_x];
  [self animateMovement:velocity_x];
    
  if (velocity_x >= 10) {
    body->v.x = playerJumping ? (200 - recoil) :  (250 - recoil);
  } else if (velocity_x <= -10) {
    body->v.x = playerJumping ? (-200 + recoil) : (-250 + recoil);
  } else {
    if (self.direction == kPlayerMoveRight) 
      body->v.x = -(recoil);
    else
      body->v.x = recoil;
  }
}

-(void) facingDirection:(float)velocity_x {
  if (velocity_x  < -10 && self.direction == kPlayerMoveRight ) {
    self.sprite.flipX = YES;
    self.direction = kPlayerMoveLeft;
  } else if (velocity_x  > 10 && self.direction == kPlayerMoveLeft ) {
    self.sprite.flipX = NO;
    self.direction = kPlayerMoveRight;
  }
}

-(void) animateMovement:(float)velocity_x {  
  // Movement in the horizontal direction
  if ((velocity_x < -50 || velocity_x > 50)) {
    [self animateMove];
  } else {
    [[self sprite] stopAllActions];
    [self restoreDefaultSprite];
  }
}


-(void) jump {
  if (!self.playerJumping)
    [[SimpleAudioEngine sharedEngine]playEffect:@"PlayerJump.m4a"];
  self.body->v.y = 600.0f;
}

-(void) land {
  if (self.playerJumping) {
    self.body->v.y = 0.0f;
  }
}

-(void) attack:(bool)fireButtonActive nextShotTime:(float*)nextShotTime totalTime:(float)totalTime {
  
  CGPoint shotPos = CGPointZero;
  
  if (self.direction == kPlayerMoveRight) 
      shotPos = CGPointMake(self.sprite.position.x + 20, self.sprite.position.y + 7);
  else
      shotPos = CGPointMake(self.sprite.position.x - 20, self.sprite.position.y + 7);
  
  switch (self.weapon) {
    case kPlayerWeaponPistol: // Single shot for the pistol
      if (fireButtonActive && !playerAttacking) {
        playerAttacking = YES;
        BulletCache *bulletCache = [theGame bulletCache];
        
        [bulletCache shootBulletFrom:shotPos playerDirection:self.direction 
                           frameName:@"Bullet.png" weaponType:self.weapon];
        
        [[SimpleAudioEngine sharedEngine]playEffect:@"Pistol.m4a"];
      } else if (!fireButtonActive && playerAttacking) {
        playerAttacking = NO;
      }
      break;
    case kPlayerWeaponMachineGun: // Rapid shot for the machine gun
      if (fireButtonActive && totalTime > *nextShotTime) {
        playerAttacking = YES;
        *nextShotTime = totalTime + 0.1f;
        
        BulletCache *bulletCache = [theGame bulletCache];                
        [bulletCache shootBulletFrom:shotPos playerDirection:self.direction 
                           frameName:@"Bullet.png" weaponType:self.weapon];
        
        [[SimpleAudioEngine sharedEngine]playEffect:@"MachineGun.m4a"];
      } else if (!fireButtonActive && playerAttacking) {
        playerAttacking = NO;
        nextShotTime = 0;
      }
      break;
      
      
    case kPlayerWeaponShotgun: // Single delayed shot for shotgun
      if (fireButtonActive && !playerAttacking && totalTime > *nextShotTime) {
        
        *nextShotTime = totalTime + 0.5f;
        
        
        playerAttacking = YES;
        BulletCache *bulletCache = [theGame bulletCache];
        
        [bulletCache shootBulletFrom:shotPos playerDirection:self.direction 
                           frameName:@"Bullet.png" weaponType:self.weapon];
        
        [[SimpleAudioEngine sharedEngine]playEffect:@"Shotgun.m4a"];

      } else if (!fireButtonActive && playerAttacking == YES) {
        playerAttacking = NO;
      }
      
      break;
      
    case kPlayerWeaponPhaser: // Single shot for phaser
      if (fireButtonActive && !playerAttacking) {
        playerAttacking = YES;
        BulletCache *bulletCache = [theGame bulletCache];
        
        [bulletCache shootBulletFrom:shotPos playerDirection:self.direction 
                           frameName:@"PhaserBullet.png" weaponType:self.weapon];
        
        [[SimpleAudioEngine sharedEngine]playEffect:@"Phaser.m4a"];
      } else if (!fireButtonActive && playerAttacking) {
        playerAttacking = NO;
      }
      break;
      
    case kPlayerWeaponRevolver: // Single shot for the revolver
      if (fireButtonActive && !playerAttacking) {
        playerAttacking = YES;
        BulletCache *bulletCache = [theGame bulletCache];
        
        [bulletCache shootBulletFrom:shotPos playerDirection:self.direction 
                           frameName:@"BulletLarge.png" weaponType:self.weapon];
        
        [[SimpleAudioEngine sharedEngine]playEffect:@"Revolver.m4a"];
        [[GameLayer sharedGameLayer] shakeScreen];

      } else if (!fireButtonActive && playerAttacking) {
        playerAttacking = NO;
      } else
        [[GameLayer sharedGameLayer] restoreScreen];

      break;
  
      
    case kPlayerWeaponGattlingGun: // Rapid shot for the machine gun
      if (fireButtonActive && totalTime > *nextShotTime) {
        playerAttacking = YES;
        *nextShotTime = totalTime + 0.02f;
        
        BulletCache *bulletCache = [theGame bulletCache];                
        [bulletCache shootBulletFrom:shotPos playerDirection:self.direction 
                           frameName:@"Bullet.png" weaponType:self.weapon];
        
        [[SimpleAudioEngine sharedEngine]playEffect:@"MachineGun.m4a"];
        [[GameLayer sharedGameLayer] shakeScreen];
        
      } else if (!fireButtonActive && playerAttacking) {
        playerAttacking = NO;
        nextShotTime = 0;
      }
      
      break;
      
    case kPlayerWeaponGrenadeLauncher: // Single delayed shot for shotgun
      if (fireButtonActive && totalTime > *nextShotTime) {
        
        *nextShotTime = totalTime + 2.0f;
        
        NSLog(@"Grenade Fired %f", *nextShotTime);
        
        playerAttacking = YES;
        ProjectileCache *projCache = [theGame projectileCache];
        
        [projCache fireFrom:shotPos direction:self.direction];
        
      } else if (!fireButtonActive && playerAttacking == YES) {
        playerAttacking = NO;
      }
      
      break;
      
    case kPlayerWeaponFlamethrower: // Single delayed shot for shotgun
      if (fireButtonActive && totalTime > *nextShotTime) {
        
        *nextShotTime = totalTime + 0.09f;
        
        
        playerAttacking = YES;
        ProjectileCache *projCache = [theGame projectileCache];
        
        [projCache fireFrom:shotPos direction:self.direction];
        
      } else if (!fireButtonActive && playerAttacking == YES) {
        playerAttacking = NO;
        nextShotTime = 0;
      }
      break;
      
    case kPlayerWeaponRocket:
      if (fireButtonActive && !playerAttacking && totalTime > *nextShotTime) {
        
        *nextShotTime = totalTime + 3.0f;
        
        
        playerAttacking = YES;
        BulletCache *bulletCache = [theGame bulletCache];
        
        [bulletCache shootBulletFrom:shotPos playerDirection:self.direction 
                           frameName:@"BulletLarge.png" weaponType:self.weapon];
        
        //[[SimpleAudioEngine sharedEngine]playEffect:@"Shotgun.m4a"];
        
      } else if (!fireButtonActive && playerAttacking == YES) {
        playerAttacking = NO;
      }
      break;
      
    case kPlayerWeaponLaser:
      if (fireButtonActive && !playerAttacking && totalTime > *nextShotTime) {
        
        *nextShotTime = totalTime + 3.0f;
        
        
        playerAttacking = YES;
        BulletCache *bulletCache = [theGame bulletCache];
        
        [bulletCache shootBulletFrom:shotPos playerDirection:self.direction 
                           frameName:@"Laser.png" weaponType:self.weapon];
        
        //[[SimpleAudioEngine sharedEngine]playEffect:@"Shotgun.m4a"];
        
      } else if (!fireButtonActive && playerAttacking == YES) {
        playerAttacking = NO;
      }
      
      break;
      
    case kPlayerWeaponShurikin: // Single shot for the revolver
      if (fireButtonActive && !playerAttacking) {
        playerAttacking = YES;
        BulletCache *bulletCache = [theGame bulletCache];
        
        [bulletCache shootBulletFrom:shotPos playerDirection:self.direction 
                           frameName:@"Shurikin.png" weaponType:self.weapon];
        
        //[[SimpleAudioEngine sharedEngine]playEffect:@"Revolver.m4a"];        
      } else if (!fireButtonActive && playerAttacking) {
        playerAttacking = NO;
      } 
      break;

    default:
      break;
  } 
  

  
}

-(int) weaponRecoil {
  switch (self.weapon) {
    case kPlayerWeaponMachineGun:
      return 30;
      break;
      
    case kPlayerWeaponGattlingGun:
      return 120;
      break;
      
    default:
      break;
  }
  
  return 0;
}

-(void) respawn {
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  
  body->p = CGPointMake(screenSize.width / 2, screenSize.height +10);
}

-(void) changeWeapon {
  PlayerWeapon chosenWeapon = kPlayerWeaponPistol;
  
  while (true) {
    chosenWeapon = (arc4random() % kPlayerWeaponCount);
    
    if (chosenWeapon != self.weapon) 
      break;
  }
  [[self sprite] stopAllActions];
  
  
  
  self.weapon = chosenWeapon;
  self.playerAttacking = NO;
  
}

-(void) checkEnemyCollision {
  EnemyCache *ec = [self.theGame enemyCache];
  
  for (int i = 0; i < MAX_ENEMIES; i++) {
    Enemy *e = [[ec enemies] objectAtIndex:i];
    if ([e activeInGame]) {
      if (ccpDistance(self.sprite.position, e.sprite.position) < 10) {
        self.points = 0;
        [theGame updateScore];
        // Player death action should happen here
      }
    }
  }
}


# pragma mark -
# pragma mark Player Statistics Actions

-(void) addPoint {
  self.points++;
  [theGame updateScore];
}

#pragma mark -
#pragma mark Update actions

-(void)update:(ccTime)delta {    
  CGSize screenSize = [[CCDirector sharedDirector] winSize];

  if (self.sprite.position.y > (screenSize.height + 5)) {
   self.body->p  = CGPointMake(self.sprite.position.x, screenSize.height + 5);
  }
  
  if (self.sprite.position.y < -30.0f) {
    [self respawn];
  }
  
  if (changeWeapon) {
    [self stopAllActions];
    [self restoreDefaultSprite];
    changeWeapon = NO;
  }
}


@end
