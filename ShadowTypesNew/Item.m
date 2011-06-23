//
//  Item.m
//  ShadowTypes
//
//  Created by neurologik on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Item.h"


@interface Item (private) 
/** Generate random position for spawn
 */
-(CGPoint) genRandPos;

/** Set the item sprite
 */
-(void) setItemSprite;

/** Load physics restraints
 */
-(void) loadPhysics;

/** Weapon Feedback Txt 
 */
- (void)weaponPickupFeedback;

/** Remove sprites from the layer
 */
- (void)removeSprite:(CCNode*)n;

/** Display the text for feedback 
 */
- (void)displayText:(NSString *)string;

@end

@implementation Item

@synthesize item;       @synthesize collected;
@synthesize body;       @synthesize shape;
@synthesize spawnPos;

#pragma mark - 
#pragma mark Initialisation / Deallocation

/* Initialisation and object loading */
- (id)initWithGame:(GameLayer *)game withType:(ItemType)objType {    
  if( (self=[super init])) {
    self.theGame = game;
    self.item = objType;
    self.collected = NO;
    
    [self setItemSprite];
    self.spawnPos = [self genRandPos];
    self.sprite.position = spawnPos;
    [self loadPhysics];        
    
    [game addChild:self];
  }
  
  return self;
}

/* Deallocate Object */
- (void)dealloc
{
  cpBodyFree(body);
  cpShapeFree(shape);
  [theGame release];
	[super dealloc];
}

#pragma mark - 
#pragma mark Load options / configurations

/* Load Sound */
-(void) loadSound {
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"CartridgePickup.m4a"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"WeaponPickup.m4a"];

}

/* Generate random position */
- (CGPoint)genRandPos {
  // Determine the possible spawn areas
  NSMutableArray *spawnPoints = [[theGame level] itemSpawnPos];
  int totalSpawnPoints = [spawnPoints count];
  CGPoint newSpawnPoint = CGPointZero;
  
  // Find a spawn point which doesn't match the current point and the 
  // position of the other sprite
  while (true) {
    // Obtain a new spawn point
    newSpawnPoint = [[spawnPoints objectAtIndex:(arc4random() % totalSpawnPoints)] CGPointValue];
    
    // Determine if the current spawn point is equal to the new spawn point
    if (CGPointEqualToPoint(newSpawnPoint, self.spawnPos) == NO) {
      
      // Determine the item type and make sure they dont have the same spawn position
      if (self.item == kAmmoPack) {
        if (CGPointEqualToPoint(newSpawnPoint, theGame.cartridge.spawnPos) == NO && (newSpawnPoint.y != self.spawnPos.y))
          break;
      } else if (self.item == kCartridge ) {
        if (CGPointEqualToPoint(newSpawnPoint, theGame.ammoBox.spawnPos) == NO && (newSpawnPoint.y != self.spawnPos.y))
          break;
      }
    }
  }
  
  return newSpawnPoint;
}

/* Set the default sprite */
- (void)setItemSprite {    
  switch (self.item) {
		case kCartridge:
      self.sprite = [CCSprite spriteWithSpriteFrameName:@"Cartridge2.png"];
			break;
    case kAmmoPack:
      self.sprite = [CCSprite spriteWithSpriteFrameName:@"AmmoBox.png"];
			break;
      break;
  }
  
  [self.theGame addChild:self.sprite z:5];
}


/* Load the physics properties */
- (void)loadPhysics {
  int numVert = 4;
  CGPoint verts[4];
  
  if (self.item == kCartridge) {
    verts[0] = ccp(-8, -9);
    verts[1] = ccp(-8,  9);
    verts[2] = ccp( 8,  9);
    verts[3] = ccp( 8, -9);
  } else if (self.item == kAmmoPack) {
    verts[0] = ccp(-13, -10);
    verts[1] = ccp(-13,  10);
    verts[2] = ccp( 13,  10);
    verts[3] = ccp( 13, -10);
  }
  
  // Define the mass and movement of intertia
  body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, numVert, verts, CGPointZero));
  body->p = self.sprite.position;
  body->data = self;
  cpSpaceAddBody(theGame.space, body);
  
  // Define the polygonal shape
  shape = cpPolyShapeNew(body, numVert, verts, CGPointZero);
  shape->e = 0.0;
  shape->u = 1.0;
  shape->data = self.sprite;
  shape->group = 1;
  shape->collision_type = 0;
  cpBodySetMoment(shape->body, INFINITY);
  cpSpaceAddShape(theGame.space, shape);
}

#pragma mark - 
#pragma mark General Operations

/* Reload and respawn the sprite to new location */
- (void)reload {
  [sprite setOpacity:0];
  self.spawnPos = [self genRandPos];
  self.body->p = spawnPos;
  
  [sprite runAction:[CCFadeIn actionWithDuration:0.5]];
}

/* Determine if the player has collided with the item */
- (void)checkItemCollision {
  Player *player = theGame.player;
  
    
  if (ccpDistance(player.sprite.position, self.sprite.position) < 25) {
    if (self.item == kAmmoPack) {
      [player changeWeapon];
      [[SimpleAudioEngine sharedEngine]playEffect:@"WeaponPickup.m4a"];
      /* Particle Effects */
      CCParticleSystem *weaponPickup;
      
      weaponPickup = [CCParticleSystemPoint particleWithFile:@"WeaponPickup.plist"];
      weaponPickup.autoRemoveOnFinish = YES;
      
      [self.theGame addChild:weaponPickup z:7];      
      [weaponPickup setPosition:player.sprite.position];
      
      [self weaponPickupFeedback];
    } else {
      [[SimpleAudioEngine sharedEngine]playEffect:@"CartridgePickup.m4a"];
      [player addPoint];
    }
    
    [self reload];
  }
  
  if (self.sprite.position.y < -50) 
    [self reload];
}

- (void)weaponPickupFeedback {
  Player *player = theGame.player;

  switch (player.weapon) {
    case kPlayerWeaponMachineGun:
      [self displayText:@"Machine\n  Gun"];
      break;
    
    case kPlayerWeaponPhaser:
      [self displayText:@"Phaser"];
      break;
      
    case kPlayerWeaponShotgun:
      [self displayText:@"Shotgun"];
      break;
      
    case kPlayerWeaponFlamethrower:
      [self displayText:@"Flamethrower"];
      break;
      
    case kPlayerWeaponGattlingGun:
      [self displayText:@"Gattling\n  Gun"];
      break;
      
    case kPlayerWeaponGrenadeLauncher:
      [self displayText:@"Grenade\n\t\tLauncher"];
      break;
      
    case kPlayerWeaponRevolver:
      [self displayText:@"Revolver"];
      break;
      
    case kPlayerWeaponRocket:
      [self displayText:@"Rocket\n\t\tLauncher"];
      break;

    default:
      break;
  }
  
}

- (void)displayText:(NSString *)string {
  
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  
  CCLabelBMFont *feedbackTxt;
  
  feedbackTxt = [CCLabelBMFont labelWithString:string fntFile:@"weaponFeedback.fnt"];
  [self.theGame addChild:feedbackTxt z:8];
  [feedbackTxt setPosition:CGPointMake((screenSize.width / 2), (screenSize.height / 2))];
  
  
  [feedbackTxt runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.2],
                          [CCDelayTime actionWithDuration:0.2],
                          [CCFadeOut actionWithDuration:0.2],
                          [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)], nil]];
}


- (void)removeSprite:(CCNode*)n {
  [self.theGame removeChild:n cleanup:YES];
}


@end
