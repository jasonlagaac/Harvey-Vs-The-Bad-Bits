//
//  HelloWorldLayer.h
//  ShadowTypes
//
//  Created by neurologik on 20/03/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// Importing Chipmunk Headers
#import "chipmunk.h"

// Importing additional class headers
#import "InputLayer.h"
#import "PauseLayer.h"
#import "Bullet.h"
#import "Level.h"

#define K_SSheet1 0
#define K_BulletCache 1
#define K_ScoreLabel 2

#define MAX_ITEMS 10

typedef enum {
	GameSceneLayerTagGame = 1,
	GameSceneLayerTagInput,
  GameSceneNodeTagBulletCache,
	
} GameSceneLayerTags;

@class Item;
@class Enemy;
@class Player;
@class BulletCache;
@class EnemyCache;
@class ExplosionCache;
@class ProjectileCache;
@class Level;
@class ParallaxNode;

@interface GameScene : CCScene {
  
}
@end

// HelloWorldLayer
@interface GameLayer : CCLayer {
  // Physics Entities
  cpSpace *space;
  
  // Game Entities
  EnemyCache *enemyCache;
  BulletCache *bulletCache;
  ExplosionCache *explosionCache;
  ProjectileCache *projectileCache;
  
  Player *player;
  Level *level;
  Item *cartridge;
  
  int playerLevel;
  int score;
  int remainingTime;

  ccTime nextSpawnTime;
  
}


@property (nonatomic, readwrite) int playerLevel;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) int remainingTime;

// Physics space
@property (nonatomic, readwrite) cpSpace *space;

@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) BulletCache *bulletCache;
@property (nonatomic, retain) EnemyCache *enemyCache;
@property (nonatomic, retain) ExplosionCache *explosionCache;
@property (nonatomic, retain) ProjectileCache *projectileCache;


@property (nonatomic, retain) Level *level;
@property (nonatomic, retain) Item *cartridge;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene:(int)level;
+(GameLayer*) sharedGameLayer;
-(void) updateScore;
-(void) shakeScreen;
-(void) restoreScreen;
-(void) gameOver;
-(void) pauseGame;
-(void) resume;

@end
