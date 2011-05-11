//
//  Item.m
//  ShadowTypes
//
//  Created by neurologik on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Item.h"


@interface Item (private) 
-(CGPoint) genRandPos;
-(void) setItemSprite;
-(void) loadPhysics;
@end

@implementation Item

@synthesize item;
@synthesize collected;

@synthesize body;
@synthesize shape;


/*****************************************
    Implementation of Private Methods 
*****************************************/
-(CGPoint) genRandPos {
    NSMutableArray *spawnPoints = [[theGame level] itemSpawnPos];
    int totalSpawnPoints = [spawnPoints count];
    CGPoint newSpawnPoint = CGPointZero;
    
    while (true) {
        newSpawnPoint = [[spawnPoints objectAtIndex:(arc4random() % totalSpawnPoints)] CGPointValue];
        
        if (newSpawnPoint.x != self.sprite.position.x && newSpawnPoint.y != self.sprite.position.y)
            break;
    }
    
    return newSpawnPoint;
}

-(void) setItemSprite {    
    switch (self.item) {
		case kCartridge:
            self.sprite = [CCSprite spriteWithSpriteFrameName:@"Cartridge2.png"];
			break;
        case kAmmoPack:
            self.sprite = [CCSprite spriteWithSpriteFrameName:@"AmmoBox.png"];
			break;
        break;
	}
    
    [self.theGame addChild:self.sprite z:5];
}


/*****************************************
    Implementation of Item Methods 
*****************************************/

// Initialisation and object loading

-(id) initWithGame:(GameLayer *)game withType:(ItemType)objType {    
    if( (self=[super init])) {
        self.theGame = game;
        self.item = objType;
        self.collected = NO;
        
        [self setItemSprite];
        self.sprite.position = [self genRandPos];
        [self loadPhysics];        
        
        [game addChild:self];
    }
    
    return self;
}

-(void) loadPhysics {
    int numVert = 4;
    CGPoint verts[4];
    
    if (self.item == kCartridge) {
        verts[0] = ccp(-8, -9);
        verts[1] = ccp(-8,  9);
        verts[2] = ccp( 8,  9);
        verts[3] = ccp( 8, -9);
    } else if (self.item == kAmmoPack) {
        verts[0] = ccp(-13, -10);
        verts[1] = ccp(-13,  10);
        verts[2] = ccp( 13,  10);
        verts[3] = ccp( 13, -10);
    }
    
    // Define the mass and movement of intertia
    body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, numVert, verts, CGPointZero));
    body->p = self.sprite.position;
    body->data = self;
    cpSpaceAddBody(theGame.space, body);
    
    // Define the polygonal shape
    shape = cpPolyShapeNew(body, numVert, verts, CGPointZero);
    shape->e = 0.0;
    shape->u = 1.0;
    shape->data = self.sprite;
    shape->group = 1;
    shape->collision_type = 0;
    cpBodySetMoment(shape->body, INFINITY);
    cpSpaceAddShape(theGame.space, shape);
}

-(void) reloadObject {
    [sprite setOpacity:0];
    [self.sprite setPosition:[self genRandPos]];
    self.body->p = self.sprite.position;
    [sprite runAction:[CCFadeIn actionWithDuration:0.5]];
}

-(void) checkItemCollision {
    //EnemyCache *ec = theGame.enemyCache;
    Player *p = theGame.player;
    
    
    if (ccpDistance(p.sprite.position, self.sprite.position) < 25) {
        if (self.item == kAmmoPack) {
            [p playerChangeWeapon];
        } else {
            [p playerAddPoint];
        }
        
        [self reloadObject];
    }
  
    /*
    if (self.item == kCartridge) {
    
        for (int i = 0; i < MAX_ENEMIES; i++) {
            Enemy *e = [ec.enemies objectAtIndex:i];
        
            if (e.activeInGame) {
                if (ccpDistance(self.sprite.position, e.sprite.position) < 10) {
                    [self reloadObject];
                    break;
                }
            }
        }
        
    }
     */
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
