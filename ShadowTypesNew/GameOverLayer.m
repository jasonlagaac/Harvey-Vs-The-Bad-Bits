//
//  GameOverLayer.m
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "AppDelegate.h"

@interface GameOverLayer (Private)
-(void) initScoreLayer;
-(void) initKillsLayer;

@end

@implementation GameOverLayer

- (id)init
{
    ccColor4B c = {0,0,0,200};
    
    if ((self = [super initWithColor:c])) {
      self.isTouchEnabled = YES;
      //[self initScoreLayer];
      [self initKillsLayer];
    }
    
    return self;
}

-(void) initScoreLayer {
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  scoreLayer = [[[CCLayer alloc] init] autorelease];
  
  // Header Position
  CGPoint headerPos = CGPointMake((screenSize.width / 2), (screenSize.height - 30.0));
  CCLabelBMFont *header = [CCLabelBMFont labelWithString:@"GAME OVER" fntFile:@"weaponFeedBackLarge.fnt"];
  header.color = ccc3(216, 57, 93);
  [scoreLayer addChild:header z:1 tag:1];
  header.position = headerPos;
  
  // Score Position
  CGPoint newTopScorePos = CGPointMake((screenSize.width / 2), ((screenSize.height / 2) + 50.0));
  CGPoint scorePos = CGPointMake((screenSize.width / 2), (screenSize.height / 2));
  
  CCLabelBMFont *newTopScore = [CCLabelBMFont labelWithString:@"NEW TOP SCORE" fntFile:@"weaponFeedback.fnt"];
  newTopScore.position = newTopScorePos;
  [scoreLayer addChild:newTopScore z:1 tag:2];
  [newTopScore runAction:[CCRepeatForever actionWithAction:[CCBlink actionWithDuration:2.0f blinks:5]]];
  
  CCLabelBMFont *gameScore = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"score: %d", 20] fntFile:@"weaponFeedback.fnt"];
  gameScore.position = scorePos;
  [scoreLayer addChild:gameScore z:1 tag:3];
  
  [self addChild:scoreLayer z:1 tag:1];
}

-(void) initKillsLayer {
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  killsLayer = [[[CCLayer alloc] init] autorelease];
  
  // Header Position
  CGPoint headerPos = CGPointMake((screenSize.width / 2), (screenSize.height - 30.0));
  CCLabelBMFont *header = [CCLabelBMFont labelWithString:@"ENEMY KILLS" fntFile:@"weaponFeedBackLarge.fnt"];
  header.color = ccc3(216, 57, 93);
  [killsLayer addChild:header z:1 tag:1];
  header.position = headerPos;
  
  CGPoint shadowIconPos = CGPointMake(((screenSize.width/2) - 140), ((screenSize.height/2) + 30));
  CGPoint shadowKillsPos = CGPointMake(((screenSize.width/2) - 135), ((screenSize.height/2) - 10));

  CGPoint juggernautIconPos = CGPointMake((screenSize.width/2), ((screenSize.height/2) + 33));
  CGPoint juggernautKillsPos = CGPointMake(((screenSize.width/2) + 5), ((screenSize.height/2) - 10));
  
  CGPoint exploderIconPos = CGPointMake(((screenSize.width/2) + 140), ((screenSize.height/2) + 30));
  CGPoint exploderKillsPos = CGPointMake(((screenSize.width/2) + 145), ((screenSize.height/2) - 10));

  
  CCSprite *shadowIcon = [CCSprite spriteWithSpriteFrameName:@"EnemySmall2.png"];
  CCLabelBMFont *shadowKills = [CCLabelBMFont labelWithString:@"10" fntFile:@"weaponFeedBackLarge.fnt"];
  shadowKills.position = shadowKillsPos;
  shadowIcon.position = shadowIconPos;
  [killsLayer addChild:shadowKills z:1 tag:4];
  [killsLayer addChild:shadowIcon z:1 tag: 2];
  
  CCSprite *juggernautIcon = [CCSprite spriteWithSpriteFrameName:@"Juggernaut2.png"];
  CCLabelBMFont *juggernautKills = [CCLabelBMFont labelWithString:@"100" fntFile:@"weaponFeedBackLarge.fnt"];
  juggernautKills.position = juggernautKillsPos;
  juggernautIcon.position = juggernautIconPos;
  [killsLayer addChild:juggernautKills z:1 tag:5];
  [killsLayer addChild:juggernautIcon z:1 tag: 3];

  
  CCSprite *exploderIcon = [CCSprite spriteWithSpriteFrameName:@"Exploder2.png"];
  CCLabelBMFont *exploderKills = [CCLabelBMFont labelWithString:@"100" fntFile:@"weaponFeedBackLarge.fnt"];
  exploderKills.position = exploderKillsPos;
  exploderIcon.position = exploderIconPos;
  [killsLayer addChild:exploderKills z:1 tag:6];
  [killsLayer addChild:exploderIcon z:1 tag: 4];
  
  [self addChild:killsLayer z:1 tag:2];
}
@end
