//
//  Bullet.h
//  ShadowTypes
//
//  Created by neurologik on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Player.h"
#import "GameScene.h"

@interface Bullet : CCSprite {
    GameLayer *theGame;
    CGPoint velocity;
    CGPoint startPos;
    float outsideScreen;
    int weaponType;
}


@property (readwrite, nonatomic) CGPoint velocity;
@property (readwrite, nonatomic) CGPoint startPos;
@property (readwrite, nonatomic) int weaponType;

+(id)bullet;
-(void) shootBulletAt:(CGPoint)startPosition direction:(int)direction 
            frameName:(NSString*)frameName weaponType:(int)weapon;

@end
