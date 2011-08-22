//
//  InputLayer.m
//  ShadowTypes
//
//  Created by neurologik on 5/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputLayer.h"
#import "GameScene.h"
#import "Player.h"
#import "BulletCache.h"

@interface InputLayer (PrivateMethods)
-(void) addButtons;
-(void) addJoystick;
@end

@implementation InputLayer
@synthesize totalTime;

static InputLayer* instanceOfInputLayer;

+(InputLayer *)sharedInputLayer
{
  NSAssert(instanceOfInputLayer != nil, @"GameScene instance not yet initialized!");
  return instanceOfInputLayer;
}

- (id)init
{
	if ((self = [super init]))
	{
    
      jumpButtonActiveCount = 0;
      [self addButtons];
      [self addJoystick];
      [self scheduleUpdate];

      playerAttacked = NO;
    
      instanceOfInputLayer = self;
    }
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)addButtons {
    float buttonRadius = 50.0;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    // Allocate and initialise the firebutton
    fireButton = [[[SneakyButton alloc] initWithRect:CGRectZero] autorelease];    
    fireButton.isHoldable = YES;
    
    SneakyButtonSkinnedBase *skinFireButton = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    skinFireButton.position = CGPointMake(screenSize.width - buttonRadius * 0.8f, buttonRadius * 1.0f);

    
    // Remember to load the sprite from the spritesheet
    skinFireButton.defaultSprite = [CCSprite spriteWithFile:@"fireButtonUnpressed.png"];
    skinFireButton.pressSprite = [CCSprite spriteWithFile:@"fireButtonPressed.png"];

    // Turn of anti-aliasing on the unpressed and pressed sprite
    [[skinFireButton.defaultSprite texture] setAliasTexParameters]; 
    [[skinFireButton.pressSprite texture] setAliasTexParameters];
    
    skinFireButton.defaultSprite.opacity = 128;
    
    skinFireButton.button = fireButton;
    
    [self addChild:skinFireButton];
    
    // Allocate and initialise the reloadbutton
    reloadButton = [[[SneakyButton alloc] initWithRect:CGRectZero] autorelease];    
    reloadButton.isHoldable = YES;
    
    SneakyButtonSkinnedBase *skinReloadButton = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    skinReloadButton.position = CGPointMake(screenSize.width - buttonRadius * 2.2f, buttonRadius * 1.0f);
    
    // Remember to load the sprite from the spritesheet
    skinReloadButton.defaultSprite = [CCSprite spriteWithFile:@"reloadButtonUnpressed.png"];
    skinReloadButton.pressSprite = [CCSprite spriteWithFile:@"reloadButtonPressed.png"];
    
    // Turn of anti-aliasing on the unpressed and pressed sprite
    [[skinReloadButton.defaultSprite texture] setAliasTexParameters]; 
    [[skinReloadButton.pressSprite texture] setAliasTexParameters];
    
    skinReloadButton.defaultSprite.opacity = 128;
    
    skinReloadButton.button = reloadButton;
    
    [self addChild:skinReloadButton];
  
  
  
    // Allocate and initialise the reloadbutton
    pauseButton = [[[SneakyButton alloc] initWithRect:CGRectZero] autorelease];    
    pauseButton.isHoldable = YES;
  
    SneakyButtonSkinnedBase *skinPauseButton = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    skinPauseButton.position = CGPointMake(screenSize.width - 30, screenSize.height - 15);
  
    // Remember to load the sprite from the spritesheet
    skinPauseButton.defaultSprite = [CCSprite spriteWithSpriteFrameName:@"PauseButton.png"];
    skinPauseButton.pressSprite = [CCSprite spriteWithSpriteFrameName:@"PauseButton.png"];
  
    skinPauseButton.defaultSprite.opacity = 160;
  
    skinPauseButton.button = pauseButton;
  
  
    [self addChild:skinPauseButton];
  
}

-(void) addJoystick {
    float stickRadius = 50;
    
    // Initialise the joystick
    joystick = [[[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, stickRadius, stickRadius)] autorelease];
    joystick.autoCenter = YES;
    joystick.isDPad = YES;
    joystick.numberOfDirections = 2;
    
    SneakyJoystickSkinnedBase *skinJoystick = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    skinJoystick.position = CGPointMake(80, stickRadius);
    skinJoystick.thumbSprite = [CCSprite spriteWithFile:@"Joystick.png"];
    skinJoystick.backgroundSprite.color = ccGRAY;
    [[skinJoystick.thumbSprite texture] setAliasTexParameters];
    
    
    // Set joystick attributes
    skinJoystick.thumbSprite.opacity = 128;
    skinJoystick.backgroundSprite.opacity = 128;
    skinJoystick.joystick = joystick;
    
    [self addChild:skinJoystick];
}

- (void)update:(ccTime)delta {   

    if (pauseButton.active) {
      [[GameLayer sharedGameLayer] pauseGame];
      return;
    }
    
    GameLayer *game = [GameLayer sharedGameLayer];
    Player *player = [game player];
    
    totalTime += delta;
        
    CGPoint velocity = ccpMult(joystick.velocity, 200);
    
    // Flip and change the direction when the joystick is moved
    // in that specific direction
    
    // Player movement in the x-axis
    [player move:velocity.x activeFireButton:fireButton.active];

    
    // Jumping action
    if (reloadButton.active && jumpButtonActiveCount < MAX_JUMP_COUNT) {
        jumpButtonActiveCount++;
        [player jump];
    } else if (!reloadButton.active && player.body->v.y == 0) {
        jumpButtonActiveCount = 0;
        [player land];
    }
        
    // Determine the player's shooting position and direction and the proper shot origin
    [player attack:fireButton.active nextShotTime:&nextShotTime totalTime:totalTime];
    
    //NSLog(@"velocity x: %f  y: %f", p.sprite.position.x, p.sprite.position.y);
    
    //[game release];
  
}

@end
