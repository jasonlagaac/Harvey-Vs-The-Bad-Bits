//
//  PauseLayer.m
//  ShadowTypesNew
//
//  Created by neurologik on 11/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PauseLayer.h"
#import "GameScene.h"


@implementation PauseLayer

- (id) initWithColor:(ccColor4B)color {
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  
  if ((self = [super initWithColor:color])) {
    self.isTouchEnabled = YES;
    CCSprite *paused = [CCSprite spriteWithSpriteFrameName:@"Paused.png"];
    [paused setPosition:ccp(screenSize.width / 2, ((screenSize.height / 2) + 20))];
    [[paused texture] setAliasTexParameters];
    
    CCSprite *tapToResume = [CCSprite spriteWithSpriteFrameName:@"TapToResume.png"];
    [tapToResume setPosition:ccp(screenSize.width / 2, ((screenSize.height / 2) - 10))];
    [[tapToResume texture] setAliasTexParameters];
    
    [self addChild:paused];
    [self addChild:tapToResume];
    
    //[tapToResume runAction:[CCRepeatForever actionWithAction:[CCBlink actionWithDuration:1 blinks:1]]];
  }
  
  return self;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"touched me");
  for (UITouch *touch in touches) {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    GameLayer *game = [GameLayer sharedGameLayer];
    [game resume];
    [self.parent removeChild:self cleanup:YES];
  }
}

-(void) dealloc {
  [super dealloc];
}

@end
