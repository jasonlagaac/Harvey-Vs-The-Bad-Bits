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

/* Item Types */
typedef enum {
  kCartridge,
  kAmmoPack
} ItemType;

/* Item Class: Items which are spawned in game */
@interface Item : Entity {
  /* Item type */
  ItemType item;
  
  /* Spawn Point */
  CGPoint spawnPos;
  
  /* Item Collected*/
  bool collected;
  
  /* Physics Attribs */
  cpBody *body;
  cpShape *shape;
  
}

@property (nonatomic, readwrite) ItemType item;
@property (nonatomic, readwrite) bool collected;
@property (nonatomic, readwrite) CGPoint spawnPos;

@property (nonatomic, readwrite) cpBody  *body;
@property (nonatomic, readwrite) cpShape *shape;

/** Initialise the item with an instance of the game
 *  @param game instance of the game
 *  @param objType is the type of object passed to the item
 *  @return instance of the item
 */
-(id) initWithGame:(GameLayer *)game 
          withType:(ItemType)objType;

/** Collision detection between the item, enemies and player
 */
-(void) checkItemCollision;

/** Reload and respawn the item
 */
-(void) reload;

@end
