//
//  Enemy.m
//  ShadowTypes
//
//  Created by neurologik on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "AppDelegate.h"

/*  
    Cocos2d unloading function to cleanup bodies and shapes
    This function is called during the cpSpaceAddPostStepCallback function
 */
static void enemyUnload (cpSpace *space, cpShape *shape, void *unused) {
  CCSprite *enemySprite = (CCSprite *) shape->data;
  GameLayer *game = [GameLayer sharedGameLayer];
  
  cpSpaceRemoveBody(space, shape->body);
  cpSpaceRemoveShape(space, shape);
  cpBodyFree(shape->body);
  cpShapeFree(shape);
  
  [game removeChild:enemySprite cleanup:YES];
  
}

@interface Enemy (private)
/* Load the default sprite */
-(void) loadDefaultSprite;

/* Load the animations for sprite*/
-(void) loadAnimations;

/* Load physics properties */
-(void) loadPhysics;

/* Load sound files */
-(void) loadSound;

/* Enemy object "death" actions */
-(void)death;

@end


@implementation Enemy

@synthesize sprite;                 @synthesize theGame;
@synthesize enemyType;              @synthesize direction;
@synthesize health;                 @synthesize prevPos_x;
@synthesize spawnPos;               @synthesize body;
@synthesize shape;                  @synthesize enemyFalling;
@synthesize started;                @synthesize activeInGame;
@synthesize dead;                   @synthesize enemyWalkAction;
@synthesize juggernautWalkAction;   @synthesize exploderWalkAction;



#pragma mark -
#pragma mark Inititialisation / Deallocation / Singleton

/* Enemy singleton */
+(id)enemy {
  return [[[self alloc] init] autorelease];
}

/* Initialisation */
-(id) init {
	if ((self = [super init])) {
    
	}	
	return self;
}

/* Deallocation */
-(void) dealloc {
	// don't forget to call "super dealloc"
  cpBodyFree(body);
  cpShapeFree(shape);
  [theGame release];
	[super dealloc];
}

#pragma mark -
#pragma mark Enemy Attribute Initialisation / Load Defaults

/* Load / Initialise default sprites */
- (void)loadDefaultSprite {
  switch (self.enemyType) {
    case kEnemySmall:
      self.sprite = [CCSprite spriteWithSpriteFrameName:@"EnemySmall2.png"];
      self.health = 10;
      break;
    case kEnemyJuggernaut:
      self.sprite = [CCSprite spriteWithSpriteFrameName:@"Juggernaut2.png"];
      self.health = 25;
      break;
    case kEnemyExploder:
      self.sprite = [CCSprite spriteWithSpriteFrameName:@"Exploder2.png"];
      self.health = 15;
      break;
  }
  
  self.sprite.position = self.spawnPos;
  [theGame addChild:sprite z:5];
}

/* Load Animation for enemy types */
- (void)loadAnimations {
  NSMutableArray *enemySmallWalkFrames = [NSMutableArray array];
  NSMutableArray *juggernautWalkFrames = [NSMutableArray array];
  NSMutableArray *exploderWalkFrames = [NSMutableArray array];

  
  for (int i = 1; i <= NUM_ENEMY_WALK_FRAMES; i++) {
    [enemySmallWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                     spriteFrameByName:[NSString stringWithFormat:@"EnemySmall%d.png", i]]];
    [juggernautWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                     spriteFrameByName:[NSString stringWithFormat:@"Juggernaut%d.png", i]]];
    [exploderWalkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                     spriteFrameByName:[NSString stringWithFormat:@"Exploder%d.png", i]]];

  }
  
  CCAnimation *enemySmallWalkAnim = [CCAnimation animationWithFrames:enemySmallWalkFrames delay:0.07f];
  CCAnimation *juggernautWalkAnim = [CCAnimation animationWithFrames:juggernautWalkFrames delay:0.07f];
  CCAnimation *exploderWalkAnim = [CCAnimation animationWithFrames:exploderWalkFrames delay:0.07f];

  
  self.enemyWalkAction  = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:enemySmallWalkAnim]];
  self.juggernautWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:juggernautWalkAnim]];
  self.exploderWalkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:exploderWalkAnim]];

}

/* Load physics attributes */
- (void)loadPhysics {
  
  int numVert = 4;
  CGPoint *verts = (CGPoint *)malloc(sizeof(CGPoint) * 4);
  
  // Define the verticies of the sprite
  if (self.enemyType != kEnemyJuggernaut) {
    verts[0] = ccp(-10.5, -18);
    verts[1] = ccp(-10.5,  18);
    verts[2] = ccp( 10.5,  18);
    verts[3] = ccp( 10.5, -18);
  } else {
    verts[0] = ccp(-10.5, -23);
    verts[1] = ccp(-10.5,  23);
    verts[2] = ccp( 10.5,  23);
    verts[3] = ccp( 10.5, -23);
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

/* Load the sound files */
- (void)loadSound {
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"EnemyHit.m4a"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"EnemyDeath.m4a"];

}


/* Load enemy object into the game */
- (void)loadIntoGame:(GameLayer *)game 
       withEnemyType:(EnemyType)type 
      withSpawnPoint:(CGPoint) spawn {    
  
  self.theGame = game;
  self.enemyType = type;
  self.spawnPos = spawn;  

  
  // Determine the enemy's movement direction
  if (arc4random() % kNumEnemyMovements) {
    self.sprite.flipX = YES;
    self.direction = kEnemyMoveRight;
  } else {
    self.sprite.flipX = NO;
    self.direction = kEnemyMoveLeft;
  } 
  
  
  self.prevPos_x = (int)sprite.position.x;
  
  enemyFalling = NO;
  started = NO;
  dead = NO;
  
  // Load all the necessary attributes
  [self loadDefaultSprite];
  [self loadAnimations];
  [self loadPhysics];
  
  
  // Start running actions
  switch (enemyType) {
    case kEnemySmall:
      [[self sprite] runAction:enemyWalkAction];
      break;
      
    case kEnemyJuggernaut:
      [[self sprite] runAction:juggernautWalkAction];
      break;
      
    case kEnemyExploder:
      [[self sprite] runAction:exploderWalkAction];
      break;
      
    default:
      break;
  }
  
  self.prevPos_x = (int)sprite.position.x;
  
  enemyFalling = NO;
  started = NO;
  activeInGame = YES;
}

#pragma mark - 
#pragma mark Enemy Movement

/* Move the enemy on the X axis */
- (void)move {
  if (self.direction == kEnemyMoveRight && self.body->v.y == 0)
    self.body->v.x = 100;
  else if (self.direction == kEnemyMoveLeft && self.body->v.y == 0)
    self.body->v.x = -100;
  
  if (self.body->v.x != 0)
    self.started = YES;
}

/* Change the movement direction of the enemy */
- (void)switchMoveDirection {
  // Detect if the previous position on the X axis is
  // the same as the current step. If it matches, we 
  // have a collision... Ow!
  if (prevPos_x == (int)self.sprite.position.x) {
    if (self.direction == kEnemyMoveLeft) {
      self.direction = kEnemyMoveRight;
      self.sprite.flipX = YES;
    } else {
      self.direction = kEnemyMoveLeft;
      self.sprite.flipX = NO;
    }
  }
  
  prevPos_x = (int)self.sprite.position.x;
}

/* Detect if the enemy is falling */
- (void)detectFall {
  // Detect change in the body's velocity in the Y axis
  if (self.body->v.y != 0 && enemyFalling == NO) {
    [[self sprite] stopAllActions];
    
    switch (self.enemyType) {
      case kEnemySmall:
        [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"EnemySmall2.png"]];
        break;
      case kEnemyJuggernaut:
        [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Juggernaut2.png"]];
        break;
        
      case kEnemyExploder:
        [[self sprite] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Exploder2.png"]];
        break;
      default:
        break;
    }
    
    enemyFalling = YES;
  } else if (self.body->v.y == 0 && enemyFalling == YES && started == YES) {
    // Enemy falling from the spawn point
    switch (enemyType) {
      case kEnemySmall:
        [[self sprite] runAction:enemyWalkAction];
        break;
        
      case kEnemyJuggernaut:
        [[self sprite] runAction:juggernautWalkAction];
        break;
        
      case kEnemyExploder:
        [[self sprite] runAction:exploderWalkAction];
        break;
        
      default:
        break;
    }
    
    enemyFalling = NO;
  }
}

/* Respawn the enemy object */
- (void)respawn {

  
  // Randomly select new movement direction
  if (arc4random() % kNumEnemyMovements) {
    self.sprite.flipX = YES;
    self.direction = kEnemyMoveRight;
  } else {
    self.sprite.flipX = NO;
    self.direction = kEnemyMoveLeft;
  }
  
  /*
  // Move the enemy object to the start
  self.body->p = CGPointMake(screenSize.width / 2, screenSize.height + 10);
  self.prevPos_x = (int)sprite.position.x;
  */
  
  self.body->p = [[theGame enemyCache] genRandPos];
  self.prevPos_x = (int)sprite.position.x;
  
  // Re-initialise
  enemyFalling = NO;
  started = NO;
  self.sprite.visible = YES;
  
   
}

/* Enemy Death operation */
- (void)death {
  self.dead = YES;
  self.activeInGame = NO;  
  [[self sprite] stopAllActions];
  
  CCParticleSystem *explosion;
  
  explosion = [CCParticleSystemPoint particleWithFile:@"EnemyExplode.plist"];
  explosion.autoRemoveOnFinish = YES;
  
  [self.theGame addChild:explosion z:7];
  [explosion setPosition:self.sprite.position];
  
  [[SimpleAudioEngine sharedEngine]playEffect:@"EnemyDeath.m4a"];
  
  [[self.theGame player] killedEnemy];
  
  /* Particle Effects */
  if (enemyType == kEnemyExploder) {
    [[theGame explosionCache] blastAt:self.sprite.position explosionType:kExplosionEnemy];
  }
  
  switch (enemyType) {
    case kEnemySmall:
      [[[AppDelegate get] gameStats] addEnemyKill:@"Shadow"];
      break;
    
    case kEnemyJuggernaut:
      [[[AppDelegate get] gameStats] addEnemyKill:@"Juggernaut"];
      break;
      
    case kEnemyExploder:
      [[[AppDelegate get] gameStats] addEnemyKill:@"Exploder"];
  }
  
  // Cocos2d must run this after the step that all bodies are accounted for
  // and that they are all cleaned up
  cpSpaceAddPostStepCallback(theGame.space, (cpPostStepFunc)enemyUnload, self.shape, nil);
}


/* Enemy damage from being hit */
- (void)damage:(int)damage {
  
  self.health -= damage;
  [[self sprite] setColor:ccc3(255,255,255)];
  self.sprite.visible = YES;
  [[SimpleAudioEngine sharedEngine]playEffect:@"EnemyHit.m4a"];
  
  if (self.health <= 0) {
    [self death];
  }
}





@end
