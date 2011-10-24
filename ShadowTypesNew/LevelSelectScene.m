//
//  LevelSelectScene.m
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectScene.h"
#import "MainMenuScene.h"
#import "GameScene.h"
#import "AppDelegate.h"

@implementation LevelSelectScene

- (id) init {
  self = [super init];
  if (self != nil) {
    [self addChild:[LevelSelectLayer node]];
  }
  
  return self;
}

-(void)dealloc {
	[super dealloc];
}


@end

@interface LevelSelectLayer (Private)
  -(void)loadLevelPreviews;
  -(void) updateScoreLabel;
@end


@implementation LevelSelectLayer
- (id) init {
  if ((self = [super init])) {
    self.isTouchEnabled = YES;
    
    levelSelect = 1;
    
    CCLabelBMFont *forwardArrowLbl = [CCLabelBMFont labelWithString:@">" fntFile:@"weaponFeedbackLarge.fnt"];
    CCLabelBMFont *backArrowLbl = [CCLabelBMFont labelWithString:@"<" fntFile:@"weaponFeedbackLarge.fnt"];
    CCLabelBMFont * selectLabel = [CCLabelBMFont labelWithString:@"select" fntFile:@"weaponFeedback.fnt"];
    CCLabelBMFont * backLabel = [CCLabelBMFont labelWithString:@"back" fntFile:@"weaponFeedback.fnt"];
    
    topScoreLbl = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"top score: %d", 0] 
                                                        fntFile:@"weaponFeedback.fnt"];
    
    
    [forwardArrowLbl setColor:ccWHITE];
    [backArrowLbl setColor:ccWHITE];
		[selectLabel setColor:ccWHITE];
		[backLabel setColor:ccWHITE];
    
    [topScoreLbl setColor:ccWHITE];
    
    
    [[selectLabel texture] setAliasTexParameters];
    [[backLabel texture] setAliasTexParameters];
    [[backArrowLbl texture] setAliasTexParameters];
    [[forwardArrowLbl texture] setAliasTexParameters];
    [[topScoreLbl texture] setAliasTexParameters];
    
    CCMenuItemLabel * select = [CCMenuItemLabel itemWithLabel:selectLabel target:self selector:@selector(levelSelected:)];
		CCMenuItemLabel * back = [CCMenuItemLabel itemWithLabel:backLabel target:self selector:@selector(backToMenu:)];
    CCMenuItemLabel * forwardArrow = [CCMenuItemLabel itemWithLabel:forwardArrowLbl target:self selector:@selector(moveRight:)];
		CCMenuItemLabel * backArrow = [CCMenuItemLabel itemWithLabel:backArrowLbl target:self selector:@selector(moveLeft:)];

    
    CCMenu *menu  = [CCMenu menuWithItems:forwardArrow, backArrow, back, select, nil];
    [self addChild:menu z:0];
    [menu setPosition:ccp(240,160)];

    [backArrow setPosition:ccp(-200, 0)];
    [forwardArrow setPosition:ccp(200, 0)];
    [back setPosition:ccp(-160, -130)];
    [select setPosition:ccp(160, -130)];
    
    [self addChild:topScoreLbl z:4];
    [topScoreLbl setPosition:ccp(240,280)];
     
    CCSprite *lvl1 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"Level%dPreview.png", 1]];
    [[lvl1 texture] setAliasTexParameters];
    [self addChild:lvl1 z:2 tag:1];
    [[self getChildByTag:1] setPosition:ccp(240, 180)];
    
    CCSprite *lvl2 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"Level%dPreview.png", 2]];
    [[lvl2 texture] setAliasTexParameters];
    [self addChild:lvl2 z:2 tag:2];
    [[self getChildByTag:2] setPosition:ccp(240, 180)];
    [[self getChildByTag:2] setVisible:NO];


    [self updateScoreLabel];
   //[self loadLevelPreviews];
    
  }
  return self;
}

-(void)loadLevelPreviews {
 for (int i = 1; i < NUM_OF_LEVELS; i++) {
    [self addChild:[CCSprite spriteWithFile:[NSString stringWithFormat:@"Level%dPreview.png", i]] z:3 tag:i];
  } 
  
  //[[self getChildByTag:1] setVisible:YES];
}

-(void)moveRight:(id)sender {
  [[self getChildByTag:levelSelect] setVisible:NO];

  if (levelSelect <= NUM_OF_LEVELS)
    levelSelect++;
  
  if ((levelSelect > NUM_OF_LEVELS) || (levelSelect == 0))
    levelSelect = 1;
  
  [[self getChildByTag:levelSelect] setVisible:YES];
  [self updateScoreLabel];
}

-(void)moveLeft:(id)sender {
  [[self getChildByTag:levelSelect] setVisible:NO];

  if (levelSelect > 0)
    levelSelect--;
  
  if (levelSelect == 0)
    levelSelect = NUM_OF_LEVELS;
  
  [[self getChildByTag:levelSelect] setVisible:YES];
  [self updateScoreLabel];

}

-(void)backToMenu:(id)sender {
  [[CCDirector sharedDirector] replaceScene:[MainMenuScene node]];
}

-(void)levelSelected:(id)sender {
	[[CCDirector sharedDirector]replaceScene:[GameLayer scene:levelSelect]];
}

-(void) updateScoreLabel {
  GameStats *gs = [[AppDelegate get] gameStats];
  [topScoreLbl setString:[NSString stringWithFormat:@"top score: %d",[gs levelTopScore:levelSelect]]];
  NSLog(@"top score: %d", [gs levelTopScore:levelSelect]);
}

-(void)dealloc {
  [super dealloc];
}

@end
