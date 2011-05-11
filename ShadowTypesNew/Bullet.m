//
//  Bullet.m
//  ShadowTypes
//
//  Created by neurologik on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"


@interface Bullet (PrivateMethods) 
-(id) initWithBulletImage;
@end


@implementation Bullet

@synthesize velocity;
@synthesize startPos;
@synthesize weaponType;
@synthesize damage;

#pragma mark Initialisation and Singleton Methods

+(id) bullet {
    return [[[self alloc] initWithBulletImage] autorelease];
}

-(id) initWithBulletImage
{
	// Uses the Texture Atlas now.
	if ((self = [super initWithSpriteFrameName:@"Bullet.png"])) {
        self.visible = NO;
	}
	
	return self;
}

-(void) dealloc
{	
	[super dealloc];
}

-(void)bulletReinit {
    self.visible = NO;
    self.weaponType = 0;
    self.startPos = CGPointZero;
    [self stopAllActions];
    [self unscheduleAllSelectors];
}


#pragma mark Public Methods

-(void) shootBulletAt:(CGPoint)startPosition direction:(int)direction frameName:(NSString*)frameName weaponType:(int)weapon
{
    // Determine the bullet's velocity based on the weapon selected
    switch (weapon) {
        case kPlayerWeaponPistol:
            self.velocity = CGPointMake(6, 0);
            self.damage = 1;
            break;
        case kPlayerWeaponMachineGun:
            self.velocity = CGPointMake(7, 0);
            self.damage = 3;
            break;
            
        case kPlayerWeaponShotgun:
            self.velocity = CGPointMake((arc4random() % 6 + 5), 0);
            self.damage = 1;
            break;
        case kPlayerWeaponPhaser:
            self.velocity = CGPointMake(9, 0);
            self.damage = 5;
            break;
    }
    
    // Direction of the velocity based on the player's movement
    if (direction == kPlayerMoveLeft) 
        self.velocity = CGPointMake(-self.velocity.x, 0);
    
	self.position = startPosition;
    self.startPos = startPosition;
	self.visible = YES;
    self.weaponType = weapon;
    
	// change the bullet's texture by setting a different SpriteFrame to be displayed
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
	[self setDisplayFrame:frame];
	
	[self scheduleUpdate];

}

-(void)bulletEnemyCollision {
    GameLayer *game = [GameLayer sharedGameLayer];
    EnemyCache *ec = [game enemyCache];    
    
    for (int i = 0; i < MAX_ENEMIES; i++) {
        Enemy *e = [[ec enemies] objectAtIndex:i];   
        if (e.activeInGame) {
            if (ccpDistance(self.position, e.sprite.position) < 15) {
                [e enemyDamage:self.damage];
                [self bulletReinit];
            }
        }
    }
}


-(void) update:(ccTime)delta
{
    float randYVel;
    
    // Determine the scatter pattern of the bullet when fired from a specific weapon
    switch (weaponType) {
        
    
        case kPlayerWeaponMachineGun:
            randYVel = ((arc4random() % 6));
            
            randYVel = (arc4random() % 2) ? abs(randYVel) : -abs(randYVel);
            randYVel *= 0.5f;
            break;
            
        case kPlayerWeaponShotgun:
            randYVel = ((arc4random() % 9));
            
            randYVel = (arc4random() % 2) ? abs(randYVel) : -abs(randYVel);
            randYVel *= 0.5f;
            break;
            
        default:
            randYVel = 0;
            break;
    }
    
    self.velocity = CGPointMake(velocity.x, randYVel); 
	self.position = ccpAdd(self.position, velocity);
	
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
	// When the bullet leaves the screen, make it invisible
    
    switch (self.weaponType) {
            
        case kPlayerWeaponShotgun:
            if (self.position.x > (self.startPos.x + 100) || self.position.x < (self.startPos.x - 100) 
                || self.position.x > screenSize.width  || self.position.x < 0)
            {
                [self bulletReinit];
            }
            break;
            
        default:
            if (self.position.x > screenSize.width || self.position.x < 0)
            {
                [self bulletReinit];
            }
    }
    
    [self bulletEnemyCollision];
}



@end
