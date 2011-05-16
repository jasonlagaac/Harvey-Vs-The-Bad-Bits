//
//  Item.h
//  ShadowTypes
//
//  Created by neurologik on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

#import "Entity.h"
#import "EntityActions.h"

typedef enum {
  kCartridge,
  kAmmoPack
} ItemType;

@interface Item : Entity {
  ItemType item;
  bool collected;
  
  // Physics Attribs
  cpBody *body;
  cpShape *shape;
  
}

@property (nonatomic, readwrite) ItemType item;
@property (nonatomic, readwrite) bool collected;

@property (nonatomic, readwrite) cpBody  *body;
@property (nonatomic, readwrite) cpShape *shape;

-(id) initWithGame:(GameLayer *)game withType:(ItemType)objType;
-(void) checkItemCollision;
-(void) reload;

@end
