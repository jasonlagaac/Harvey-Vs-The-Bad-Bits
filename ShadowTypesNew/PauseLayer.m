//
//  PauseLayer.m
//  ShadowTypesNew
//
//  Created by neurologik on 11/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  TODO: implement a touch area for the quit function in ccTouchesBegan


#import "PauseLayer.h"
#import "GameScene.h"


@implementation PauseLayer

- (id) init {
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  ccColor4B c = {0,0,0,200};
    
  if ((self = [super initWithColor:c])) {
    self.isTouchEnabled = YES;
    CCSprite *paused = [CCSprite spriteWithSpriteFrameName:@"Paused.png"];
    [paused setPosition:ccp(screenSize.width / 2, ((screenSize.height / 2) + 50))];
    [[paused texture] setAliasTexParameters];
    
    CCSprite *tapToResume = [CCSprite spriteWithSpriteFrameName:@"Resume.png"];
    resumeButtonPos = ccp(screenSize.width / 2, ((screenSize.height / 2) - 10));
    [tapToResume setPosition:ccp(screenSize.width / 2, ((screenSize.height / 2) - 10))];
    [[tapToResume texture] setAliasTexParameters];
    
    CCSprite *tapToQuit = [CCSprite spriteWithSpriteFrameName:@"Quit.png"];
    quitButtonPos = ccp(screenSize.width / 2, ((screenSize.height / 2) - 50));
    [tapToQuit setPosition:quitButtonPos];
    [[tapToQuit texture] setAliasTexParameters];
    
    [self addChild:paused];
    [self addChild:tapToResume];
    [self addChild:tapToQuit];
    
    //[tapToResume runAction:[CCRepeatForever actionWithAction:[CCBlink actionWithDuration:1 blinks:1]]];
  }
  
  return self;
}


-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"touched me");
  for (UITouch *touch in touches) {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    // Determine the location of the resume button touch
    // and run resume action when touched.
    if (location.x < (resumeButtonPos.x + 100) && location.x > (resumeButtonPos.x - 100) &&
        location.y < (resumeButtonPos.y + 10) && location.y > (resumeButtonPos.y - 10)) {
        GameLayer *game = [GameLayer sharedGameLayer];
        [game resume];
        [self.parent removeChild:self cleanup:YES];
    }
    
  }
}

-(void) dealloc {
  [super dealloc];
}

@end
