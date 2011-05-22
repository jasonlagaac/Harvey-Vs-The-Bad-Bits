//
//  EnemyCache.m
//  ShadowTypesNew
//
//  Created by neurologik on 4/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnemyCache.h"
#import "GameScene.h"

@implementation EnemyCache

@synthesize theGame;        @synthesize enemies;
@synthesize startPoints;    @synthesize gameLevel;

/* Initialise the cache with game, level and spawn points */
-(id) initWithGame:(GameLayer *)game withLevel:(int)level 
   withStartPoints:(NSMutableArray *)startPointList {
  
  if ((self = [super init])) {
    self.theGame = game;
    self.enemies = [CCArray arrayWithCapacity:MAX_ENEMIES];
    self.startPoints = startPointList;
    self.gameLevel = level;
    
    // Allocate enemies into the cache
    for (int i = 0; i < MAX_ENEMIES; i++) {
      Enemy *e = [Enemy enemy];
      [[self enemies] addObject:e];
    }
  }
  
  return self;
}

- (void)dealloc {
  [theGame release];
  [super dealloc];
}


/* Spawn the enemy from the cache and load it into the game */
-(void) spawnEnemy { 
  // Determine the number of spawn points 
  int numSpawnPoints = [[self startPoints] count];
  
  // Get random spawn position
  CGPoint spawnPos = *(CGPoint *)[startPoints objectAtIndex:(arc4random() % numSpawnPoints)];
  
  // Find the next inactive enemy object
  for (int i = 0; i < MAX_ENEMIES; i++) {
    Enemy *enemy = [enemies objectAtIndex:i];
    
    if (![enemy activeInGame]) {
      [enemy loadIntoGame:self.theGame 
            withEnemyType:kEnemySmall
           withSpawnPoint:spawnPos];
      
      break;
    }
  }
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
