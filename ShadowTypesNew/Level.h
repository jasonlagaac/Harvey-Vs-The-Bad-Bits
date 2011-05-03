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
}

@property (nonatomic, retain) GameLayer  *theGame;

-(id)initWithLevel:(int)levelNum game:(GameLayer *)game;

@end
