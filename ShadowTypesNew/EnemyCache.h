//
//  EnemyCache.h
//  ShadowTypesNew
//
//  Created by neurologik on 4/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameScene.h"
#import "Enemy.h"

@interface EnemyCache : CCNode {
    GameLayer *theGame;
    CCArray *enemies;
    
    
}

@end
