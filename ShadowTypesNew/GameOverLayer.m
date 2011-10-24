//
//  GameOverLayer.m
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "MainMenuScene.h"
#import "AppDelegate.h"
#import "CCLabelBMFontMultiline.h"


#define NUM_OF_LAYERS 2

@interface GameOverLayer (Private)

-(void) backToMenu:(id)sender;
-(void) initScoreLayer;
-(void) initStatsLayer;

-(void) moveForward:(id)sender;
-(void) moveBackward:(id)sender;

@end

@implementation GameOverLayer

- (id)init {
  ccColor4B c = {0,0,0,200};
  selectedLayer = 0;
  
  if ((self = [super initWithColor:c])) {
    self.isTouchEnabled = YES;
    
    CCLabelBMFont * forwardArrow = [CCLabelBMFont labelWithString:@">" fntFile:@"weaponFeedbackLarge.fnt"];
    CCLabelBMFont * backArrow = [CCLabelBMFont labelWithString:@"<" fntFile:@"weaponFeedbackLarge.fnt"];
    CCLabelBMFont * menuLbl = [CCLabelBMFont labelWithString:@"menu" fntFile:@"weaponFeedback.fnt"];

    
    [[forwardArrow texture] setAliasTexParameters];
    [[backArrow texture] setAliasTexParameters];
    [[menuLbl texture] setAliasTexParameters];
    
    CCMenuItemLabel * forward = [CCMenuItemLabel itemWithLabel:forwardArrow target:self selector:@selector(moveForward:)];
		CCMenuItemLabel * back = [CCMenuItemLabel itemWithLabel:backArrow target:self selector:@selector(moveBackward:)];
    CCMenuItemLabel * menuButton = [CCMenuItemLabel itemWithLabel:menuLbl target:self selector:@selector(backToMenu:)];

    
    [back setPosition:ccp(-200, 0)];
    [forward setPosition:ccp(220, 0)];
    [menuButton setPosition:ccp(160, -120)];
    
    CCMenu * menu = [CCMenu menuWithItems:forward, back, menuButton, nil];
    
    [self addChild:menu z:1];
    
    [self initScoreLayer];
    [self initStatsLayer];
  }
    
  return self;
}

-(void) initScoreLayer {
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  scoreLayer = [[[CCLayer alloc] init] autorelease];
  GameStats *gameStats = [[AppDelegate get] gameStats];
  
  
  // Header Position
  CGPoint headerPos = CGPointMake((screenSize.width / 2), (screenSize.height - 30.0));
  CCLabelBMFont *header = [CCLabelBMFont labelWithString:@"GAME OVER" fntFile:@"weaponFeedbackLarge.fnt"];
  header.color = ccc3(216, 57, 93);
  [scoreLayer addChild:header z:1 tag:1];
  header.position = headerPos;
  
  // Score Position
  CGPoint scorePos = CGPointMake((screenSize.width / 2), (screenSize.height / 2));
  
  NSLog(@"Game Over: %d", [gameStats newTopScore] ? 1 : 0);

  if ([[[AppDelegate get] gameStats] newTopScore]) {
    CGPoint newTopScorePos = CGPointMake((screenSize.width / 2), ((screenSize.height / 2) + 50.0));
    
    CCLabelBMFont *newTopScore = [CCLabelBMFont labelWithString:@"NEW TOP SCORE" fntFile:@"weaponFeedback.fnt"];
    newTopScore.position = newTopScorePos;
    newTopScore.color = ccc3(255,186,16); 
    [scoreLayer addChild:newTopScore z:1 tag:2];
    
    [newTopScore runAction:[CCRepeatForever actionWithAction:[CCBlink actionWithDuration:2.0f blinks:5]]];
  }
  
  
  CCLabelBMFont *gameScore = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"score: %d", [gameStats currentGameScore]] 
                                                    fntFile:@"weaponFeedback.fnt"];
  gameScore.position = scorePos;
  [scoreLayer addChild:gameScore z:1 tag:3];
  
  [self addChild:scoreLayer z:0 tag:0];
}

-(void) initStatsLayer {
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  statsLayer = [[[CCLayer alloc] init] autorelease];
  
  // Header Position
  CGPoint headerPos = CGPointMake((screenSize.width / 2), (screenSize.height - 30.0));
  CCLabelBMFont *header = [CCLabelBMFont labelWithString:@"GAME STATS" fntFile:@"weaponFeedbackLarge.fnt"];
  header.color = ccc3(66, 186, 222);
  [statsLayer addChild:header z:1 tag:1];
  header.position = headerPos;
  
  CGPoint unlockHeaderPos = CGPointMake((screenSize.width / 2), (screenSize.height / 2));
  CCLabelBMFont *unlockHeader = [CCLabelBMFont labelWithString:@"unlocked" fntFile:@"weaponFeedback.fnt"];
  unlockHeader.color = ccc3(255,186,16);
  [statsLayer addChild:unlockHeader z:1 tag:1];
  unlockHeader.position = unlockHeaderPos;
  
  
  CGPoint shadowIconPos = CGPointMake(((screenSize.width/2) - 140), ((screenSize.height/2) + 80));
  CGPoint shadowKillsPos = CGPointMake(((screenSize.width/2) - 135), ((screenSize.height/2) + 45));
  
  CGPoint juggernautIconPos = CGPointMake((screenSize.width/2), ((screenSize.height/2) + 83));
  CGPoint juggernautKillsPos = CGPointMake(((screenSize.width/2) + 5), ((screenSize.height/2) + 45));
  
  CGPoint exploderIconPos = CGPointMake(((screenSize.width/2) + 140), ((screenSize.height/2) + 80));
  CGPoint exploderKillsPos = CGPointMake(((screenSize.width/2) + 145), ((screenSize.height/2) + 45));
  
  
  CCSprite *shadowIcon = [CCSprite spriteWithSpriteFrameName:@"EnemySmall2.png"];
  int enemySmallKilled = [[[AppDelegate get] gameStats] enemyKillCount:@"Shadow"];
  
  CCLabelBMFont *shadowKills = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", enemySmallKilled]  
                                                      fntFile:@"weaponFeedback.fnt"];
  shadowKills.position = shadowKillsPos;
  shadowIcon.position = shadowIconPos;
  [statsLayer addChild:shadowKills z:1 tag:4];
  [statsLayer addChild:shadowIcon z:1 tag: 2];
  
  CCSprite *juggernautIcon = [CCSprite spriteWithSpriteFrameName:@"Juggernaut2.png"];
  int enemyJuggernaughtKilled = [[[AppDelegate get] gameStats] enemyKillCount:@"Juggernaut"];

  CCLabelBMFont *juggernautKills = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", enemyJuggernaughtKilled]
                                                          fntFile:@"weaponFeedback.fnt"];
  juggernautKills.position = juggernautKillsPos;
  juggernautIcon.position = juggernautIconPos;
  [statsLayer addChild:juggernautKills z:1 tag:5];
  [statsLayer addChild:juggernautIcon z:1 tag: 3];
  
  
  CCSprite *exploderIcon = [CCSprite spriteWithSpriteFrameName:@"Exploder2.png"];
  int enemyExploderKilled = [[[AppDelegate get] gameStats] enemyKillCount:@"Exploder"];
  CCLabelBMFont *exploderKills = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", enemyExploderKilled]
                                                          fntFile:@"weaponFeedback.fnt"];
  exploderKills.position = exploderKillsPos;
  exploderIcon.position = exploderIconPos;
  [statsLayer addChild:exploderKills z:1 tag:6];
  [statsLayer addChild:exploderIcon z:1 tag: 4];
  
  
  NSMutableArray *unlockedWeapons = [[[AppDelegate get] gameStats] recentUnlockedWeapons];
  CCLabelBMFontMultiline *unlockedTxt;
  
  if ([unlockedWeapons count] > 0 ) {
    NSString *weaponsList = [NSString stringWithString:@""];
    for (int i = 0; i < ([unlockedWeapons count]); i++) {
      weaponsList = [NSString stringWithFormat:@"%@ %@.", weaponsList, [unlockedWeapons objectAtIndex:i]];
    }
    
    unlockedTxt = [CCLabelBMFontMultiline labelWithString:weaponsList                                                                                     
                                                                          fntFile:@"weaponFeedback.fnt" 
                                                                            width:420.0 
                                                                        alignment:LeftAlignment];
    
    
  } else {
     unlockedTxt = [CCLabelBMFontMultiline labelWithString:@"nothing unlocked."                                                                                     
                                                                          fntFile:@"weaponFeedback.fnt" 
                                                                            width:420.0 
                                                                        alignment:LeftAlignment];
  }
  
  [unlockedWeapons release];
  unlockedWeapons = nil;
  
  unlockedTxt.position = CGPointMake((screenSize.width / 2), ((screenSize.height /2) - 60));
  [statsLayer addChild:unlockedTxt z:1];
  
  [self addChild:statsLayer z:0 tag:1];
  [[self getChildByTag:1] setVisible: NO];
}

-(void) backToMenu:(id)sender {
    [AppDelegate get].paused = NO;
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene node]];
}

-(void) moveForward:(id)sender {
  [[self getChildByTag:selectedLayer] setVisible:NO];
  
  if (selectedLayer < NUM_OF_LAYERS)
    selectedLayer++;
  
  if ((selectedLayer > (NUM_OF_LAYERS - 1)))
    selectedLayer = 0;
  
  [[self getChildByTag:selectedLayer] setVisible:YES];
}

-(void) moveBackward:(id)sender {
  [[self getChildByTag:selectedLayer] setVisible:NO];
  
  if (selectedLayer > -1)
    selectedLayer--;
  
  if ((selectedLayer <= -1 ))
    selectedLayer = 1;
  
  [[self getChildByTag:selectedLayer] setVisible:YES];

}

@end
