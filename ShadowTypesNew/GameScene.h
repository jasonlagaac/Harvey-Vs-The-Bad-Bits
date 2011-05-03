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
#import "Bullet.h"
#import "Level.h"

#define K_SSheet1 0
#define K_BulletCache 1

#define MAX_ITEMS 10
#define MAX_ENEMIES 30

typedef enum
{
	GameSceneLayerTagGame = 1,
	GameSceneLayerTagInput,
    GameSceneNodeTagBulletCache,
	
} GameSceneLayerTags;

@class Item;
@class Enemy;
@class Player;
@class BulletCache;
@class Level;

// HelloWorldLayer
@interface GameLayer : CCColorLayer
{
    // Physics Entities
    cpSpace *space;
    
    // Game Entities
    Item *items[10];
    Enemy *enemies[30];
    Player *player;
    BulletCache *bulletCache;
    Level *level;
    
    int playerLevel;
    int score;
    int remainingTime;
}

@property (nonatomic, readwrite) int playerLevel;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) int remainingTime;

// Physics space
@property (nonatomic, readwrite) cpSpace *space;

@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) BulletCache *bulletCache;
@property (nonatomic, retain) Level *level;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void) checkItemSpawnTime;
+(GameLayer*) sharedGameLayer;


@end
