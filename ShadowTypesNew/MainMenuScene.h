//
//  MainMenuScene.h
//  ShadowTypesNew
//
//  Created by neurologik on 26/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;

@interface MainMenuScene : CCScene {
}

@end


@interface MainMenuLayer : CCLayer {
  GameLayer *game;
}

@end
