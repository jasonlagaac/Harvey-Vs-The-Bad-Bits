//
//  Projectile.m
//  ShadowTypesNew
//
//  Created by neurologik on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Projectile.h"

/*  
 Cocos2d unloading function to cleanup bodies and shapes
 This function is called during the cpSpaceAddPostStepCallback function
 */
static void projUnload (cpSpace *space, cpShape *shape, void *unused) {
  cpSpaceRemoveBody(space, shape->body);
  cpSpaceRemoveShape(space, shape);
  cpBodyFree(shape->body);
  cpShapeFree(shape);
  
}

@interface Projectile (PrivateMethods)
- (id)initWithProjImage;
- (void)loadPhysics;
- (void)loadAnimations;
- (void) loadSprite;
- (bool)detectEnemyCollision;
@end

@implementation Projectile

@synthesize type;


#pragma mark - Initialisation / Dealloc / Singleton Functions

+(id) projectile {
  return [[[self alloc] initWithProjImage] autorelease];
}

/* Initialisation and object loading */
- (id)initWithProjImage {    
  if ((self = [super initWithSpriteFrameName:@"Grenade.png"])) {
    self.visible = NO;
    self.type = kProjGrenade;
    [self loadAnimations];
  }
  
  return self;
}

- (void)dealloc {
  GameLayer *game = [GameLayer sharedGameLayer];
  [game removeChild:self cleanup:YES];
  [super dealloc];
}
#pragma mark - Load Attribute Functions 


-(void) loadPhysics {    
  int numVert = 4;
  
  GameLayer *gameInstance = [GameLayer sharedGameLayer];
                        
  // Define the player's verticies
  CGPoint verts[] = {
    ccp(-4, -4),
    ccp(-4,  4),
    ccp( 4,  4),
    ccp( 4, -4)
  };
  
  // Define the mass and the movement of intertia
  body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, numVert, verts, CGPointZero));
  body->p = self.position;
  body->data = self;
  cpSpaceAddBody(gameInstance.space, body);
  
  // Define the polygonal shape
  shape = cpPolyShapeNew(body, numVert, verts, CGPointZero);
  shape->e = 0.8;
  shape->u = 2.0;
  shape->data = self;
  shape->group = 1;
  shape->collision_type = 1;
  cpBodySetMoment(shape->body, INFINITY);
  cpSpaceAddShape(gameInstance.space, shape);
  
}

-(void) loadAnimations {
  NSMutableArray *flameFrames = [NSMutableArray array];
  
  for (int i = 1; i <= 3; i++) {
    [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                     spriteFrameByName:[NSString stringWithFormat:@"Flame%d.png", i]]];
  }
  CCAnimation *flameAnim = [CCAnimation animationWithFrames:flameFrames delay:0.07f];
  flameAction  = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:flameAnim]];
}

-(void) loadSprite {
  switch (self.type) {
    default:
      break;
  }
}

-(void) fireProjFrom:(CGPoint)pos 
  withPlayerhDirection:(PlayerMovement)dir {
  GameLayer *game = [GameLayer sharedGameLayer];
  PlayerWeapon playerWeapon = [[game player] weapon];
  
  // Add sprite to the game
  [self loadSprite]; 
  self.position = pos;  
  
  [self loadAnimations];
  [self loadPhysics];
  
  // Set visibility
  self.visible = YES;
  
  lifeTime = 0.0f;

  
  switch (playerWeapon) {
    case kPlayerWeaponGrenadeLauncher:
      [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                             spriteFrameByName:@"Grenade.png"]];
      self.type = kProjGrenade;
      // Set elasticity so that it bounces
      shape->e = 30;
      
      // To be fired from the position  
      if (dir == kPlayerMoveLeft)
        cpBodyApplyImpulse(body, cpv(-300,30),cpv(0,0));
      else 
        cpBodyApplyImpulse(body, cpv(300,30),cpv(0,0));
      break;
      
    case kPlayerWeaponFlamethrower:
      self.opacity = 200;
      [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:@"Flame3.png"]];
      self.type = kProjFlame;
      
      // Set elasticity so that it bounces
      shape->e = 0;
      shape->u = (((arc4random() % 100) / 100) + 50);
      
      // To be fired from the position  
      float vel_x = ((arc4random() % 200) + 200);
      
      if (dir == kPlayerMoveLeft) 
        cpBodyApplyImpulse(body, cpv(-vel_x,30), cpvzero);
      else 
        cpBodyApplyImpulse(body, cpv(vel_x,30), cpvzero);
      
      break;
      
    default:
      break;
  }
}

- (bool)detectEnemyCollision {
  GameLayer *game = [GameLayer sharedGameLayer];
  EnemyCache *ec = [game enemyCache];    
  
  for (int i = 0; i < MAX_ENEMIES; i++) {
    // Load an enemy from the enemy cache
    Enemy *e = [[ec enemies] objectAtIndex:i];   
    if (e.activeInGame) { 
      // Determine the distance
      if (ccpDistance(self.position, e.sprite.position) < 15) {
        if (self.type == kProjGrenade) {
          [[[GameLayer sharedGameLayer] explosionCache]blastAt:self.position];
        } else
          [e damage:7];
      
        return YES;
      }
    }
  }
  
  return NO;
}


-(void) updateProjectile:(ccTime)delta {
  GameLayer *game = [GameLayer sharedGameLayer];
    
  lifeTime += delta;
  
  if (self.type == kProjFlame && ![self numberOfRunningActions]) {
    [self runAction:flameAction];
  }
  
  // Detect Enemy collision
  if ([self detectEnemyCollision]) {
    if (self.type == kProjGrenade) {
      // Reset lifetime
      lifeTime = 0;
      self.visible = NO;
  
      // Remove object from the environment
      cpSpaceAddPostStepCallback(game.space, (cpPostStepFunc)projUnload, shape, nil);
    }
  }
  
  
  if (lifeTime > 3.0f && type == kProjGrenade) {
    ExplosionCache *ec = [game explosionCache];
    
    // Should run explosion etc
    [ec blastAt:self.position];
    
    // Reset lifetime
    lifeTime = 0;
    self.visible = NO;
    
    
    // Remove object from the environment
    cpSpaceAddPostStepCallback(game.space, (cpPostStepFunc)projUnload, shape, nil);
  } else if (lifeTime > 2.0f && type == kProjFlame) {
    lifeTime = 0;
    self.visible = NO;
    [self stopAllActions];
    cpSpaceAddPostStepCallback(game.space, (cpPostStepFunc)projUnload, shape, nil);
  }
}

                

@end
