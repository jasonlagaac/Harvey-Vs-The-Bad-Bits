//
//  EntityActions.h
//  ShadowTypes
//
//  Created by neurologik on 22/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"

@class  GameLayer;

@protocol EntityActions

@required
-(id) initWithGame:(GameLayer *)game;
-(void) loadIntoLayer;
-(void) removeFromLayer;

@optional
-(void) loadObj:(int)objType spawnTime:(float)sTime;
-(void) loadObj:(int)objType spawnTime:(float)sTime removeTime:(float)rTime;


@end
