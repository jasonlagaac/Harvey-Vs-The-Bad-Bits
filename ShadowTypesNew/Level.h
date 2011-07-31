//
//  Level.h
//  ShadowTypesNew
//
//  Created by neurologik on 27/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "GameScene.h"


@interface Level : CCNode {
  GameLayer *theGame;
  NSMutableArray *itemSpawnPos;
  NSMutableArray *enemySpawnPos;
  NSMutableArray *playerSpawnPos;
}

@property (nonatomic, retain) GameLayer *theGame;
@property (nonatomic, retain) NSMutableArray  *itemSpawnPos;
@property (nonatomic, retain) NSMutableArray  *enemySpawnPos;
@property (nonatomic, retain) NSMutableArray  *playerSpawnPos;


-(id)initWithLevel:(int)levelNum game:(GameLayer *)game;

@end
