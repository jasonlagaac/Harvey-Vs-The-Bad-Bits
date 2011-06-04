//
//  EnemyCache.h
//  ShadowTypesNew
//
//  Created by neurologik on 4/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameScene.h"
#import "Enemy.h"

#define MAX_ENEMIES 2

/** EnemyCache: Storing and reloading enemy objects
 */
@interface EnemyCache : CCNode {
    /* Game instance */
    GameLayer *theGame;
  
    /* Enemy array */
    CCArray *enemies;
    
    /* Spawn points for enemies */
    NSMutableArray *startPoints;
  
    /* Game Level */
    int gameLevel;
}

@property (nonatomic, retain) GameLayer *theGame;
@property (nonatomic, retain) CCArray *enemies;
@property (nonatomic, retain) NSMutableArray *startPoints;
@property (nonatomic, readwrite) int gameLevel;

/** Initialise with game instance, level and specific spawn points
 *  @param game: Instance of game
 *  @param level: Stage loaded
 *  @param startPointList: List of spawn points
 *  @return
 */
-(id) initWithGame:(GameLayer *)game 
         withLevel:(int)level 
   withStartPoints:(NSMutableArray *)startPointList;

/** Spawn an enemy from the cache 
 */
-(void)spawnEnemy;

/** Enemy Step actions
 */
-(void) runEnemyActions;

@end
