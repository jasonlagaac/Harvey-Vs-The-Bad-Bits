//
//  Projectile.m
//  ShadowTypesNew
//
//  Created by neurologik on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Projectile.h"

@interface Projectile (PrivateMethods)
- (void)loadPhysics;
- (void)loadAnimations;
- (void) loadSprite;
@end

@implementation Projectile

@synthesize type;


#pragma mark - Initialisation / Dealloc / Singleton Functions

+(id) explosion {
  return [[[self alloc] init] autorelease];
}

/* Initialisation and object loading */
- (id)init {    
  if ((self = [super initWithSpriteFrameName:@"Grenade.png"])) {
    self.visible = NO;
    self.type = kProjGrenade;
    
    [self loadPhysics];
    [self loadAnimations];
  }
  
  return self;
}

- (void)dealloc {
  [super dealloc];
}
#pragma mark - Load Attribute Functions 


-(void) loadPhysics {    
  int numVert = 4;
  
  GameLayer *gameInstance = [GameLayer sharedGameLayer];
                        
  // Define the player's verticies
  CGPoint verts[] = {
    ccp(-21, -20),
    ccp(-21,  20),
    ccp( 21,  20),
    ccp( 21, -20)
  };
  
  // Define the mass and the movement of intertia
  body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, numVert, verts, CGPointZero));
  body->p = self.position;
  body->data = self;
  cpSpaceAddBody(gameInstance.space, body);
  
  // Define the polygonal shape
  shape = cpPolyShapeNew(body, numVert, verts, CGPointZero);
  shape->e = 0.0;
  shape->u = 1.0;
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

-(void) releaseProjAt:(CGPoint)pos 
  witPlayerhDirection:(PlayerMovement)dir {
  
  
}


                

@end
