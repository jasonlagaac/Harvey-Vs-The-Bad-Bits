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

/* Enemy Types */
typedef enum {
  kEnemySmall,
  kEnemyJuggernaut
} EnemyType;

/* Enemy movement options */
typedef enum {
  kEnemyMoveRight,
  kEnemyMoveLeft,
  kNumEnemyMovements
} EnemyMovement;

@class GameLayer;

/** Enemy Object Class
 */
@interface Enemy : CCNode {
  /* Game Instance */
  GameLayer *theGame;
  
  /* Physics Attributes */
  cpBody *body;
  cpShape *shape;
  
  /* Enemy object attributes */
  CCSprite *sprite;
  EnemyType enemyType;
  CGPoint spawnPos;
  int health;
  int respawnCount;
  
  /* Object location on screen attribute */
  float prevPos_x;
  
  /* Status Values */
  bool activeInGame;
  bool enemyFalling;
  bool started;
  bool dead;
  
  /* Enemy Movement */
  EnemyMovement direction;
  
  /* Animation Action */
  CCAction *enemyWalkAction;
  CCAction *juggernautWalkAction;
  
}

@property (nonatomic, retain) GameLayer *theGame;

@property (nonatomic, readwrite) cpBody  *body;
@property (nonatomic, readwrite) cpShape *shape;

@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, readwrite) EnemyType enemyType;
@property (nonatomic, readwrite) CGPoint spawnPos;
@property (nonatomic, readwrite) int health;


@property (nonatomic, readwrite) EnemyMovement direction;
@property (nonatomic, retain) CCAction *enemyWalkAction;
@property (nonatomic, retain) CCAction *juggernautWalkAction;

@property (nonatomic, readwrite) float prevPos_x;

@property (nonatomic, readwrite) bool enemyFalling;
@property (nonatomic, readwrite) bool started;
@property (nonatomic, readwrite) bool activeInGame;
@property (nonatomic, readwrite) bool dead;


/** Enemy Singleton
 */
+ (id)enemy;


/** Load the enemy into the game instance 
 *  @param |game| reference to the game instance
 *  @param |type| of enemy to be loaded
 *  @param |spawnPoint| Position the enemy should spawn from
 */
- (void) loadIntoGame:(GameLayer *)game 
        withEnemyType:(EnemyType)type 
       withSpawnPoint:(CGPoint)spawnPoint;

/** Move the enemy along its path
 */
- (void)move;

/** Change the enemy's movement direction
 */
- (void)switchMoveDirection;

/** Detect if the player is falling
 */
- (void)detectFall;

/** Respawn the enemy back into a visible position
 */
- (void)respawn;

/** Remove health from enemy
 */
- (void)damage:(int)damage;

@end
