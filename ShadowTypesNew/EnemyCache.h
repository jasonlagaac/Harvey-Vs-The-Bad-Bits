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

#define MAX_ENEMIES 20

@interface EnemyCache : CCNode {
    GameLayer *theGame;
    CCArray *enemies;
    
    NSMutableArray *startPoints;
    int gameLevel;
}

@property (nonatomic, retain) GameLayer *theGame;
@property (nonatomic, retain) CCArray *enemies;
@property (nonatomic, retain) NSMutableArray *startPoints;
@property (nonatomic, readwrite) int gameLevel;


-(id) initWithGame:(GameLayer *)game withLevel:(int)level withStartPoints:(NSMutableArray *)startPointList;
-(void)spawnEnemy;
-(void) runEnemyActions;

@end
