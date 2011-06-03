//
//  Explosion.m
//  ShadowTypesNew
//
//  Created by neurologik on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Explosion.h"

@interface Explosion (Private)
/* Initialise with default sprite */
-(id) initWithExplosionImage;

/* Load all the necessary animation actions*/
-(void) loadAnimation;

-(void) reload;

-(void) detectCollision;

@end

@implementation Explosion

@synthesize  explosionAnimation;


#pragma mark - Init / Dealloc / Singleton Functions
+(id) explosion {
  return [[[self alloc] initWithExplosionImage] autorelease];
}

-(id) initWithExplosionImage {
	if ((self = [super initWithSpriteFrameName:@"Blast5.png"])) {
    self.visible = NO;
    [self loadAnimation];
  }
  
  return self;
}

-(void) reload {
  self.visible = NO;
}

-(void) dealloc {
  [super dealloc];
}


#pragma mark - Attribute Initialisation Functions



-(void) loadAnimation {
  NSMutableArray *explosionFrames = [NSMutableArray array];
  
  for (int i = 1; i <= NUM_EXPLOSION_FRAMES; i++) {
    [explosionFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                spriteFrameByName:[NSString stringWithFormat:@"Blast%d.png", i]]];
  }
  
  self.explosionAnimation = [CCAnimation animationWithFrames:explosionFrames delay:0.10];
}

#pragma mark - Action Functions

-(void) blastAt:(CGPoint)pos {
  self.position = pos;  
  active = YES;
  self.visible = YES;

  [self runAction:[CCSequence actions:[CCAnimate actionWithAnimation:explosionAnimation],
                   [CCCallFunc actionWithTarget:self selector:@selector(reload)],
                   nil]];
  
  [[SimpleAudioEngine sharedEngine]playEffect:@"Explosion.m4a"];

  [self detectCollision];
  
}

-(void) detectCollision {
  EnemyCache *ec = [[GameLayer sharedGameLayer] enemyCache];

  for (int i = 0; i < MAX_ENEMIES; i++) {
    // Load an enemy from the enemy cache
    Enemy *e = [[ec enemies] objectAtIndex:i];   
    if (e.activeInGame) { 
      // Determine the distance
      if (ccpDistance(self.position, e.sprite.position) < 50) {
        [e damage:50];    
      }
    }
  }
}



@end
