//
//  BulletCache.m
//  ShadowTypes
//
//  Created by neurologik on 17/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BulletCache.h"
#import "GameScene.h"

@implementation BulletCache
@synthesize theGame;
@synthesize bullets;


-(id) initWithGame:(GameLayer *) game;
{
	if ((self = [super init]))
	{
        self.theGame = game;
        self.bullets = [CCArray arrayWithCapacity:MAX_NUM_BULLETS];
        
        for (int i = 0; i < MAX_NUM_BULLETS; i++) {
            Bullet *b = [Bullet bullet];
            [[self bullets] addObject:b];
            [game addChild:b z:5];
        }
	}
	
	return self;
}


-(void) shootBulletFrom:(CGPoint)startPosition playerDirection:(PlayerMovement)direction 
              frameName:(NSString*)frameName weaponType:(PlayerWeapon)weapon {
    
    Bullet *b = nil;
    
    switch (weapon) {
        case kPlayerWeaponPistol:
            
            b = [bullets objectAtIndex:nextInactiveBullet];
            [b shootBulletAt:startPosition direction:direction frameName:frameName weaponType:weapon];
            nextInactiveBullet++;

            break;
        case kPlayerWeaponMachineGun:
            
            b = [bullets objectAtIndex:nextInactiveBullet];
            [b shootBulletAt:startPosition direction:direction frameName:frameName weaponType:weapon];
            nextInactiveBullet++;

            break;
            
        case kPlayerWeaponShotgun:
            for (int i = 0; i < 5; i++) {
                b = [bullets objectAtIndex:nextInactiveBullet + i];
                [b shootBulletAt:startPosition direction:direction  frameName:frameName weaponType:weapon];
            }
            if (nextInactiveBullet >= [bullets count])
            {
                nextInactiveBullet = 0;
            } else {
                nextInactiveBullet += 5;
            }
            
            break;
        case kPlayerWeaponPhaser:
            
            b = [bullets objectAtIndex:nextInactiveBullet];
            [b shootBulletAt:startPosition direction:direction frameName:frameName weaponType:weapon];
            nextInactiveBullet++;
            
            break;
        
    }
    
	if (nextInactiveBullet >= [bullets count])
	{
		nextInactiveBullet = 0;
	}

	
}

@end
