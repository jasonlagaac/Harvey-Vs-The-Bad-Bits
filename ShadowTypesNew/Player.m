//
//  Player.m
//  ShadowTypes
//
//  Created by neurologik on 20/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "BulletCache.h"

@interface Player (private)
// Player Initialisation
- (void)loadAnimations;
- (void)loadDefaultSprite;
- (void)loadSound;
- (void)loadPhysics;

// Player General Actions
- (void)animateMove;
- (void)stopAnimations;
- (void)changeToJumpFallSprite;
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

@synthesize theGame;                @synthesize sprite;
@synthesize weapon;                 @synthesize direction;
@synthesize playerAttacking;        @synthesize playerJumping;
@synthesize body;                   @synthesize shape;
@synthesize knifeWalkAction;        @synthesize pistolWalkAction;
@synthesize machineGunWalkAction;   @synthesize shotgunWalkAction;
@synthesize phaserWalkAction;       @synthesize points;


#pragma mark - 
#pragma mark Player Attribute Initialisation

-(void) loadSprites {
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  
  self.weapon = kPlayerWeaponPistol;
  
  [self loadDefaultSprite];
  [[self.sprite texture] setAliasTexParameters];
  
  self.sprite.flipX = NO;    
  self.direction = kPlayerMoveRight;
  self.sprite.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
  [theGame addChild:sprite z:6];
  
  
}

-(void) loadDefaultSprite {    
  switch (self.weapon) {
    case kPlayerWeaponPistol:
      self.sprite = [CCSprite spriteWithSpriteFrameName:@"PistolStill.png"];
      break;
    case kPlayerWeaponMachineGun:
      self.sprite = [CCSprite spriteWithSpriteFrameName:@"MachineGunStill.png"];
      break;
    case kPlayerWeaponShotgun:
      self.sprite = [CCSprite spriteWithSpriteFrameName:@"ShotgunStill.png"];
      break;
    case kPlayerWeaponPhaser:
      self.sprite = [CCSprite spriteWithSpriteFrameName:@"PhaserStill.png"];
      break;
  }
}

-(void) loadAnimations {
  NSMutableArray *pistolWalkFrames = [NSMutableArray array];
  NSMutableArray *machineGunWalkFrames = [NSMutableArray array];
  NSMutableArray *shotgunWalkFrames = [NSMutableArray array];
  NSMutableArray *phaserWalkFrames = [NSMutableArray array];
  
  for (int i = 1; i <= 4; i++) {
    [pistolWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                 spriteFrameByName:[NSString stringWithFormat:@"Pistol%d.png", i]]];    
    [machineGunWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                     spriteFrameByName:[NSString stringWithFormat:@"MachineGun%d.png", i]]]; 
    
    [shotgunWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                  spriteFrameByName:[NSString stringWithFormat:@"Shotgun%d.png", i]]]; 
    
    [phaserWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                 spriteFrameByName:[NSString stringWithFormat:@"Phaser%d.png", i]]]; 
  }
  
  CCAnimation *pistolWalkAnim = [CCAnimation animationWithFrames:pistolWalkFrames delay:0.07f];
  self.pistolWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:pistolWalkAnim]];
  
  
  CCAnimation *machineGunWalkAnim = [CCAnimation animationWithFrames:machineGunWalkFrames delay:0.07f];
  self.machineGunWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:machineGunWalkAnim]];
  
  
  CCAnimation *shotgunWalkAnim = [CCAnimation animationWithFrames:shotgunWalkFrames delay:0.07f];
  self.shotgunWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:shotgunWalkAnim]];
  
  
  CCAnimation *phaserWalkAnim = [CCAnimation animationWithFrames:phaserWalkFrames delay:0.07f];
  self.phaserWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:phaserWalkAnim]];
}


/* Preload the sound files */
-(void) loadSound {
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"Pistol.m4a"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"MachineGun.m4a"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"Phaser.m4a"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"Shotgun.m4a"];
  
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"PlayerJump.m4a"];
}

-(void) loadPhysics {    
  int numVert = 4;
  
  // Define the player's verticies
  CGPoint verts[] = {
    ccp(-21, -20),
    ccp(-21,  20),
    ccp( 21,  20),
    ccp( 21, -20)
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
    
    [self loadSprites];
    [self loadAnimations];
    [self loadSound];
    [self loadPhysics];
    
    [game addChild:self z:5];
    
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
                                      spriteFrameByName:@"PistolStill.png"]];
      break;
      
    case kPlayerWeaponMachineGun:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"MachineGunStill.png"]];
      break;
      
    case kPlayerWeaponShotgun:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"ShotgunStill.png"]];
      break;
      
    case kPlayerWeaponPhaser:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"PhaserStill.png"]];
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
        
      default:
        break;
    }
  }
}

-(void) stopAnimations {
  if ([self.sprite numberOfRunningActions])
    [[self sprite] stopAllActions];
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
  if (velocity_x < -50 || velocity_x > 50) {
    [self animateMove];
  } else  {
    [self stopAnimations];
    [self restoreDefaultSprite];
  }
  
  // Movement in the vertical direction
  if (self.body->v.y != 0) {
    self.playerJumping = YES; 
    [self changeToJumpFallSprite];
    [self stopAnimations];
    
  } else {
    self.playerJumping = NO;
    [self restoreDefaultSprite];
  }
}

-(void) changeToJumpFallSprite {
  switch (self.weapon) {
    case kPlayerWeaponPistol:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"PistolJump.png"]];
      break;
      
    case kPlayerWeaponMachineGun:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"MachineGunJump.png"]];
      break;
      
    case kPlayerWeaponShotgun:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"ShotgunJump.png"]];
      break;
      
    case kPlayerWeaponPhaser:
      [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                      spriteFrameByName:@"PhaserJump.png"]];
      break;
      
    default:
      break;
  }
}


-(void) jump {
  
  if (!self.playerJumping) {
    [[SimpleAudioEngine sharedEngine]playEffect:@"PlayerJump.m4a"];
  
    /* Particle Effects */
    CCParticleSystem *jump;
  
    jump = [CCParticleSystemPoint particleWithFile:@"PlayerJump.plist"];
    jump.autoRemoveOnFinish = YES;
  
    [self.theGame addChild:jump z:7];
    CGPoint jumpSpot = CGPointMake(self.sprite.position.x, (self.sprite.position.y - 10.0f));
    
    [jump setPosition:jumpSpot];
  }
  
  self.body->v.y = 400.0f;
}

-(void) land {
  if (self.playerJumping) {
    self.body->v.y = 0.0f;
  }
}

-(void) attack:(bool)fireButtonActive nextShotTime:(float*)nextShotTime totalTime:(float)totalTime {
  
  CGPoint shotPos = CGPointZero;
  
  if (self.direction == kPlayerMoveRight) {
    shotPos = CGPointMake(self.sprite.position.x + 25, self.sprite.position.y + 7.0f);
  } else {
    shotPos = CGPointMake(self.sprite.position.x - 25, self.sprite.position.y + 7.0f);
  }
  
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
      
    default:
      break;
  } 
  
}

-(int) weaponRecoil {
  switch (self.weapon) {
    case kPlayerWeaponMachineGun:
      return 30;
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
    
    if (chosenWeapon == kPlayerWeaponPistol)
      chosenWeapon++;
    
    if (chosenWeapon != self.weapon) 
      break;
  }
  
  self.weapon = chosenWeapon;
  [self stopAllActions];
  [self restoreDefaultSprite];
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
  
}


@end
