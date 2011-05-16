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
#import "EnemyCache.h"

@interface Bullet : CCSprite {
  CGPoint velocity;
  CGPoint startPos;
  float outsideScreen;
  int weaponType;
  int damage;
}

@property (readwrite, nonatomic) CGPoint velocity;
@property (readwrite, nonatomic) CGPoint startPos;
@property (readwrite, nonatomic) int weaponType;
@property (readwrite, nonatomic) int damage;

+ (id)bullet;
- (void)shootBulletAt:(CGPoint)startPosition 
            direction:(int)direction 
            frameName:(NSString*)frameName 
           weaponType:(int)weapon;

- (void)bulletReinit;

@end
