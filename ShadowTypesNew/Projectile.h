//
//  Projectile.h
//  ShadowTypesNew
//
//  Created by neurologik on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

#import "GameScene.h"

typedef enum {
  kProjFlame,
  kProjMine,
  kProjGrenade,
  kProjCount
} projType;

@interface Projectile : CCSprite {
  /* Projectile Type */
  projType type;
  
  /* Physics Attribs */
  cpBody *body;          
  cpShape *shape; 
  
  /* Animation actions for objects */
  CCAction *flameAction;
  CCAction *mineAction;
}

@property (nonatomic, readwrite) projType type;

@end
