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
  //CCSprite *projSprite = (CCSprite *) shape->data;
  //GameLayer *game = [GameLayer sharedGameLayer];
  
  cpSpaceRemoveBody(space, shape->body);
  cpSpaceRemoveShape(space, shape);
  cpBodyFree(shape->body);
  cpShapeFree(shape);
  
  //[game removeChild:projSprite cleanup:YES];
  
}

@interface Projectile (PrivateMethods)
- (id)initWithProjImage;
- (void)loadPhysics;
- (void)loadAnimations;
- (void) loadSprite;
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
  
  switch (playerWeapon) {
    case kPlayerWeaponGrenadeLauncher:
      self.type = kProjGrenade;
      break;
      
    case kPlayerWeaponFlamethrower:
      self.type = kProjFlame;
      break;
      
    default:
      break;
  }
  
  // Add sprite to the game
  [self loadSprite]; 
  self.position = pos;  
  
  [self loadPhysics];
  
  // Set visibility
  self.visible = YES;

  // Set elasticity so that it bounces
  shape->e = 30;
  
  // To be fired from the position  
  if (dir == kPlayerMoveLeft)
    cpBodyApplyImpulse(body, cpv(-350,80),cpv(0,0));
  else 
    cpBodyApplyImpulse(body, cpv(350,80),cpv(0,0));
  
  lifeTime = 0.0f;
}

-(void) updateProjectile:(ccTime)delta {
  GameLayer *game = [GameLayer sharedGameLayer];

  if (lifeTime < 0.3f) {
    lifeTime += delta;
  } else if (lifeTime > 3.0f && type == kProjGrenade) {
    ExplosionCache *ec = [game explosionCache];
    
    // Should run explosion etc
    [ec blastAt:self.position];
    
    // Reset lifetime
    lifeTime = 0;
    self.visible = NO;
    
    
    // Remove object from the environment
    cpSpaceAddPostStepCallback(game.space, (cpPostStepFunc)projUnload, shape, nil);
  } else {
    lifeTime = 0;
    self.visible = NO;
    cpSpaceAddPostStepCallback(game.space, (cpPostStepFunc)projUnload, shape, nil);
  }
}

                

@end
