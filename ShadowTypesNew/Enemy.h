//
//  Enemy.h
//  ShadowTypes
//
//  Created by neurologik on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "GameScene.h"


typedef enum {
    kEnemySmall,
    kEnemyLarge
} EnemyType;

typedef enum {
    kEnemyMoveRight,
    kEnemyMoveLeft,
    kNumEnemyMovements
} EnemyMovement;

@class GameLayer;

@interface Enemy : CCNode {
    // Game Entities
    GameLayer *theGame;
    
    // Physics Attribs
    cpBody *body;
    cpShape *shape;
    
    // Enemy Attributes
    CCSprite *sprite;
    EnemyType enemyType;
    CGPoint spawnPos;
    int health;
    
    float prevPos_x;
    
    // Sentinal Value
    bool active;
    bool enemyFalling;
    bool started;
    
    // Enemy Movement Values
    EnemyMovement direction;
    
    // Animation Actions
    CCAction *enemyWalkAction;
    
}

@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, retain) GameLayer *theGame;

@property (nonatomic, readwrite) EnemyType enemyType;
@property (nonatomic, readwrite) EnemyMovement direction;

@property (nonatomic, retain) CCAction *enemyWalkAction;

@property (nonatomic, readwrite) cpBody  *body;
@property (nonatomic, readwrite) cpShape *shape;

@property (nonatomic, readwrite) CGPoint spawnPos;

@property (nonatomic, readwrite) bool enemyFalling;
@property (nonatomic, readwrite) bool started;
@property (nonatomic, readwrite) bool active;


@property (nonatomic, readwrite) int health;
@property (nonatomic, readwrite) int points;
@property (nonatomic, readwrite) float prevPos_x;

+(id)enemy;

-(void) LoadIntoGame:(GameLayer *)game 
       withEnemyType:(EnemyType)type 
      withSpawnPoint:(CGPoint)spawnPoint
           withOrder:(int)order;

-(void) moveEnemy;
-(void) switchMoveDirection;
-(void) enemyFall;
-(void) enemyRespawn;

@end
