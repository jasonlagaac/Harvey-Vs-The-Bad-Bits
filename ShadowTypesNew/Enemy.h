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
    kEnemyMoveLeft
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
    int attack;
    
    // Enemy Movement Values
    EnemyMovement direction;
    
    // Animation Actions
    CCAction *enemyWalkAction;
    
}

@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, retain) GameLayer *theGame;


@property (nonatomic, readwrite) EnemyType enemyType;
@property (nonatomic, readwrite) EnemyMovement direction;

@property (nonatomic, readwrite) CCAction *enemyWalkAction;


@property (nonatomic, readwrite) int health;
@property (nonatomic, readwrite) int points;
@property (nonatomic, readwrite) int attack;

-(id) initWithGame:(GameLayer *)game withEnemyType:(EnemyType)enemy;

@end
