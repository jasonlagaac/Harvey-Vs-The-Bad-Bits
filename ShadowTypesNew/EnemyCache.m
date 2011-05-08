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

@synthesize theGame;
@synthesize enemies;
@synthesize startPoints;
@synthesize gameLevel;

-(id) initWithGame:(GameLayer *)game withLevel:(int)level withStartPoints:(NSMutableArray *)startPointList {
    if ((self = [super init])) {
        self.theGame = game;
        self.enemies = [CCArray arrayWithCapacity:MAX_ENEMIES];
        self.startPoints = startPointList;
        self.gameLevel = level;
        
        for (int i = 0; i < MAX_ENEMIES; i++) {
            Enemy *e = [Enemy enemy];
            [[self enemies] addObject:e];
        }
    }
    
    return self;
}


-(void) spawnEnemy { 
    int numSpawnPoints = [[self startPoints] count];
    
    CGPoint spawnPos = *(CGPoint *) [startPoints objectAtIndex:(arc4random() % numSpawnPoints)];
    
    for (int i = 0; i < MAX_ENEMIES; i++) {
        Enemy *e = [enemies objectAtIndex:i];
        if (![e activeInGame]) {
            [e LoadIntoGame:self.theGame withEnemyType:kEnemySmall withSpawnPoint:spawnPos withOrder:(i+5)];
            break;
        }
    }
}


-(void) runEnemyActions {
    for (int i = 0; i < MAX_ENEMIES; i++) {
        Enemy *e = [enemies objectAtIndex:i];
        if ([e activeInGame]) {
            [e moveEnemy];
            [e switchMoveDirection];
            [e enemyFall];
            
            if (e.sprite.position.y < -30.0f)
                [e enemyRespawn];
        }
        
    }
}



@end
