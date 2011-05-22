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

/* Entity Class: Base Class for basic entities */
@interface Entity : CCNode {
  /* Entity sprite */
  CCSprite *sprite;
  
  /* Game Instance */
  GameLayer *theGame;
}

@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, retain) GameLayer *theGame;

@end