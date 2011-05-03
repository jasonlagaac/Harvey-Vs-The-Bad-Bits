//
//  Entity.h
//  ShadowTypes
//
//  Created by neurologik on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"

@class GameLayer;

@interface Entity : CCNode {
    CCSprite *sprite;
    GameLayer *theGame;
    float timeToSpawn;
}

@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, retain) GameLayer *theGame;
@property (nonatomic, readwrite) float timeToSpawn;

@end