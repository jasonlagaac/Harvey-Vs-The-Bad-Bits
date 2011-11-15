//
//  EnemyCache.m
//  ShadowTypesNew
//
//  Created by neurologik on 4/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnemyCache.h"
#import "GameScene.h"


@interface EnemyCache (Private)
@end


@implementation EnemyCache

@synthesize theGame;        @synthesize enemies;
@synthesize gameLevel;

/* Initialise the cache with game, level and spawn points */
-(id) initWithGame:(GameLayer *)game {
  
  if ((self = [super init])) {
    self.theGame = game;
    self.enemies = [CCArray arrayWithCapacity:MAX_ENEMIES];
    
    // Allocate enemies into the cache
    for (int i = 0; i < MAX_ENEMIES; i++) {
      Enemy *e = [Enemy enemy];
      [[self enemies] addObject:e];
    }
  }
  
  return self;
}

- (void)dealloc {
  [enemies release];
  enemies = nil;
    
  [theGame release];
  theGame = nil;
    
  [super dealloc];
}


/* Spawn the enemy from the cache and load it into the game */
-(void) spawnEnemy {
  // Find the next inactive enemy object
  for (int i = 0; i < MAX_ENEMIES; i++) {
    Enemy *enemy = [enemies objectAtIndex:i];
    
    if (![enemy activeInGame]) {
      [enemy loadIntoGame:self.theGame 
            withEnemyType:(arc4random() % 3)
           withSpawnPoint:[self genRandPos]];
      
      break;
    }
  }
}

/* Generate random position */
- (CGPoint)genRandPos {
  // Determine the possible spawn areas
  NSMutableArray *spawnPoints = [[theGame level] enemySpawnPos];
  int totalSpawnPoints = [spawnPoints count];
  CGPoint newSpawnPoint = CGPointZero;
  
  // Find a spawn point which doesn't match the current point and the 
  // position of the other sprite
  newSpawnPoint = [[spawnPoints objectAtIndex:(arc4random() % totalSpawnPoints)] CGPointValue];
  
  return newSpawnPoint;
}

/* Run regular enemy operations */
-(void) runEnemyActions {
  for (int i = 0; i < MAX_ENEMIES; i++) {
    Enemy *enemy = [enemies objectAtIndex:i];
    if ([enemy activeInGame]) {
      [enemy move];   // Move the enemy
      
      // Change direction if colliding with wall
      [enemy switchMoveDirection]; 
      
      // Detect enemy falling
      [enemy detectFall];
      
      // Respawn the enemy once it falls into the hole
      if (enemy.sprite.position.y < -30.0f)
        [enemy respawn];
    }
  }
}



@end
