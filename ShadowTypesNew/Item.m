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
-(CGRect) setItemSprite;
@end

@implementation Item

@synthesize item;
@synthesize collected;
@synthesize timeRemove;

/*****************************************
    Implementation of Private Methods 
*****************************************/
-(CGPoint) genRandPos {
    return ccp(arc4random() % 400, 40);
}

-(CGRect) setItemSprite{
    CGRect itemSprite;
    
    
    switch (self.item) {
		case kMedPack:
            itemSprite = CGRectMake(432, 238, 44, 44);
			break;
        case kAmmoPack:
            itemSprite = CGRectMake(2,384, 47, 31);
			break;
            
        // All weapons should be boxes
        case kWeaponPistol:
        case kWeaponShotgun:
        case kWeaponSMG:
            itemSprite = CGRectMake(348, 258, 82, 56);

            break;
	}
    
    return itemSprite;
}


/*****************************************
    Implementation of Item Methods 
*****************************************/

// Initialisation and object loading

-(id) initWithGame:(GameLayer *)game {    
    if( (self=[super init])) {
        self.theGame = game;
        self.collected = NO;
        
        [game addChild:self];
    }
    
    return self;
}

-(void) loadObj:(int)objType spawnTime:(float)sTime removeTime:(float)rTime {
    self.timeToSpawn = sTime;
    self.timeRemove = rTime;
    
    CCSpriteBatchNode *s = (CCSpriteBatchNode *) [theGame getChildByTag:K_SSheet1];
    
    self.item = objType;
    self.sprite = [CCSprite spriteWithBatchNode:s rect:[self setItemSprite]];
    [self.sprite setPosition:[self genRandPos]];
}

-(void)loadObj:(int)objType spawnTime:(float)sTime {
    [self loadObj:objType spawnTime:sTime removeTime:-1];
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

// Loading and removing sprite from scene

-(void) loadIntoLayer {
    CCSpriteBatchNode *s = (CCSpriteBatchNode *) [theGame getChildByTag:K_SSheet1];
    [sprite setOpacity:0];
    [[sprite texture] setAliasTexParameters];
    [s addChild:sprite z:3]; // Add sheet to layer
    [sprite runAction:[CCFadeIn actionWithDuration:5]];
    NSLog(@"%f",sprite.position.x);
    
    // Should animate fade in and schedule bounce
}        

-(void) removeFromLayer {
    [sprite runAction:[CCSequence actions:[CCFadeOut actionWithDuration:5],[CCCallFuncN actionWithTarget:self selector:@selector(removeSprite)],nil]];    
}

-(void) removeSprite {
    CCSpriteBatchNode *s = (CCSpriteBatchNode *) [theGame getChildByTag:K_SSheet1];
    [s removeChild:sprite cleanup:YES];
}


@end
