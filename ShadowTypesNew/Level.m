//
//  Level.m
//  ShadowTypesNew
//
//  Created by neurologik on 27/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Level.h"

@interface Level (private)
- (void)loadLevelObjWith:(CGPoint)pos height:(float)height width:(float)width;
@end

@implementation Level
@synthesize theGame;
@synthesize itemSpawnPos;
@synthesize enemySpawnPos;
@synthesize playerSpawnPos;


#pragma mark -
#pragma mark Alloc / Dealloc

- (id)initWithLevel:(int)levelNum game:(GameLayer *)game {
  
  if  ((self=[super init])) {
    
    // Save Instance of Game
    self.theGame = game;
    self.itemSpawnPos = [[NSMutableArray alloc] init];
    self.enemySpawnPos = [[NSMutableArray alloc] init];
    self.playerSpawnPos = [[NSMutableArray alloc] init];
    
    // Loading Tilemap
    CCTMXTiledMap *map = [CCTMXTiledMap tiledMapWithTMXFile:[NSString stringWithFormat:@"Level%d.tmx",levelNum]];
    [game addChild: map];
    
    CCTMXObjectGroup *levelObj = [map objectGroupNamed:@"Object Layer"];
    
    for (NSMutableDictionary *d in [levelObj objects]) {
      CGPoint pos = CGPointMake([[d valueForKey:@"x"] floatValue], [[d valueForKey:@"y"] floatValue]);
      [self loadLevelObjWith:pos height:[[d valueForKey:@"height"] floatValue] width: [[d valueForKey:@"width"] floatValue]];
    }
    
    CCTMXLayer *enemySpawnPoints = [map layerNamed:@"Enemy Spawn"];        
    CGSize s = [enemySpawnPoints layerSize];    
        
    for( int x = 0; x < s.width;x++) {
      for( int y = 0; y < s.height; y++ ) {
        if ([enemySpawnPoints tileAt:ccp(x,y)])
          [enemySpawnPos addObject:[NSValue valueWithCGPoint:[enemySpawnPoints tileAt:ccp(x,y)].position]];
      }
    }
        
    CCTMXLayer *itemSpawnPoints = [map layerNamed:@"Item Spawn"];        
    s = [itemSpawnPoints layerSize];
    
    for( int x=0; x<s.width;x++) {
      for( int y=0; y< s.height; y++ ) 
        if ([itemSpawnPoints tileAt:ccp(x,y)])
          [itemSpawnPos addObject:[NSValue valueWithCGPoint:[itemSpawnPoints tileAt:ccp(x,y)].position]];
    }
    
    CCTMXLayer *playerSpawnPoints = [map layerNamed:@"Player Spawn"];        
    s = [playerSpawnPoints layerSize];
    
    for( int x=0; x<s.width;x++) {
      for( int y=0; y< s.height; y++ ) 
        if ([playerSpawnPoints tileAt:ccp(x,y)])
          [playerSpawnPos addObject:[NSValue valueWithCGPoint:[playerSpawnPoints tileAt:ccp(x,y)].position]];
    }
  }
  
  return self;
}

- (void)dealloc
{
	// don't forget to call "super dealloc"
  [theGame release];
	[super dealloc];
}

#pragma mark -
#pragma mark Level Loading

- (void)loadLevelObjWith:(CGPoint)pos height:(float)height width:(float)width  {
  
  cpBody *staticBody = cpBodyNewStatic(); // Initialise the static body
  cpShape *shape; // Initialise the shape
  
  
  if (width > 20) {
    // Horizontal platform definition
    CGPoint endPoint = CGPointMake((pos.x + width), pos.y);
    shape = cpSegmentShapeNew(staticBody, pos, endPoint, 0.0f);
    shape->e = 0.02f; shape->u = 0.05f;
  } else { 
    // Vertical platform definition
    CGPoint endPoint = CGPointMake(pos.x, (pos.y + height - 5.0f));
    shape = cpSegmentShapeNew(staticBody, pos, endPoint, 3.0f);
    shape->e = 0.0f; shape->u = 0.0f;

  }
  
  // Add shape into the space
  cpSpaceAddStaticShape(theGame.space, shape);
  
}


@end
