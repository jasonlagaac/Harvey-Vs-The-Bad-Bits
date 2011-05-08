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


-(id) initWithGame:(GameLayer *) game
{
	if ((self = [super init]))
	{
        self.theGame = game;
        self.bullets = [CCArray arrayWithCapacity:MAX_NUM_BULLETS];
        
        for (int i = 0; i < MAX_NUM_BULLETS; i++) {
            Bullet *b = [Bullet bullet];
            [[self bullets] addObject:b];
            [game addChild:b z:7];
        }
	}
	
	return self;
}


-(void)bulletEnemyCollision {
    
    EnemyCache *ec = [[self theGame] enemyCache];
    
    for (int i = 0; i < MAX_ENEMIES; i++) {
        Enemy *e = [[ec enemies] objectAtIndex:i];   
        for (int j = 0; i < MAX_NUM_BULLETS; j++) {
            Bullet *b = [bullets objectAtIndex:j];
            if (ccpDistance(b.position, e.sprite.position) < 70) {
                NSLog(@"Hit");
                [e enemyDamage:b.damage];
                [b bulletReinit];
            }
        }
    }
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
            
            if ((nextInactiveBullet + 5) >= [bullets count])
            {
                nextInactiveBullet = 0;
            } else {
                nextInactiveBullet += 5;
            }
            
            for (int i = 0; i < 5; i++) {
                b = [bullets objectAtIndex:nextInactiveBullet + i];
                [b shootBulletAt:startPosition direction:direction  frameName:frameName weaponType:weapon];
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
