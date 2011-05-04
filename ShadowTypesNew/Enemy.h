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
    int health;
    
    float prevPos_x;
    
    // Sentinal Value
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

@property (nonatomic, readwrite) bool enemyFalling;
@property (nonatomic, readwrite) bool started;

@property (nonatomic, readwrite) int health;
@property (nonatomic, readwrite) int points;
@property (nonatomic, readwrite) float prevPos_x;

-(id) initWithGame:(GameLayer *)game withEnemyType:(EnemyType)enemy;

@end
