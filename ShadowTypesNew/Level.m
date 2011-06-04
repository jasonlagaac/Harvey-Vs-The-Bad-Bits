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


#pragma mark -
#pragma mark Alloc / Dealloc

- (id)initWithLevel:(int)levelNum game:(GameLayer *)game {
  
  if  ((self=[super init])) {
    
    // Save Instance of Game
    self.theGame = game;
    self.itemSpawnPos = [[NSMutableArray alloc] init];
    
    // Loading Tilemap
    CCTMXTiledMap *map = [CCTMXTiledMap tiledMapWithTMXFile:[NSString stringWithFormat:@"Level%d.tmx",levelNum]];
    [game addChild: map];
    
    CCTMXLayer *level = [map layerNamed:@"Level"];
    [[level texture] setAliasTexParameters];
  
    [game reorderChild:level z:1];
    
    
    
    CCTMXObjectGroup *levelObj = [map objectGroupNamed:@"Object Layer"];
    
    for (NSMutableDictionary *d in [levelObj objects]) {
      CGPoint pos = CGPointMake([[d valueForKey:@"x"] floatValue], [[d valueForKey:@"y"] floatValue]);
      [self loadLevelObjWith:pos height:[[d valueForKey:@"height"] floatValue] width: [[d valueForKey:@"width"] floatValue]];
    }
    
    CCTMXLayer *itemSpawnPoints = [map layerNamed:@"Item Spawn"];        
    CGSize s = [itemSpawnPoints layerSize];
    
    for( int x=0; x<s.width;x++) {
      for( int y=0; y< s.height; y++ ) 
        if ([itemSpawnPoints tileAt:ccp(x,y)])
          [itemSpawnPos addObject:[NSValue valueWithCGPoint:[itemSpawnPoints tileAt:ccp(x,y)].position]];
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
    shape->e = 0.02f; shape->u = 0.1f;
  } else { 
    // Vertical platform definition
    CGPoint endPoint = CGPointMake(pos.x, (pos.y + height));
    shape = cpSegmentShapeNew(staticBody, pos, endPoint, 0.5f);
    shape->e = 0.00f; shape->u = 0.0f;

  }
  
  // Add shape into the space
  cpSpaceAddStaticShape(theGame.space, shape);
  
}


@end
