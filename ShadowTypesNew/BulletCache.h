//
//  BulletCache.h
//  ShadowTypes
//
//  Created by neurologik on 17/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Bullet.h"
#import "GameScene.h"

#define MAX_NUM_BULLETS 100

@interface BulletCache : CCNode 
{

    GameLayer *theGame;
    CCArray *bullets;
	int nextInactiveBullet;
}

@property (nonatomic, retain) GameLayer *theGame;
@property (nonatomic, retain) CCArray *bullets;

-(void) shootBulletFrom:(CGPoint)startPosition playerDirection:(PlayerMovement)direction 
              frameName:(NSString*)frameName weaponType:(PlayerWeapon)weapon;

@end