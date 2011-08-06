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

@implementation LevelSelectScene

- (id) init {
  self = [super init];
  if (self != nil) {
    [self addChild:[LevelSelectLayer node]];
  }
  
  return self;
}

-(void)dealloc
{
	[super dealloc];
}


@end

@interface LevelSelectLayer (Private)
  -(void)loadLevelPreviews;
@end


@implementation LevelSelectLayer
- (id) init {
  if ((self = [super init])) {
    self.isTouchEnabled = YES;
    
    levelSelect = 1;
    
    CCSprite *leftButtonSprite = [CCSprite spriteWithSpriteFrameName:@"leftButton.png"];
    CCSprite *leftButtonPressedSprite = [CCSprite spriteWithSpriteFrameName:@"leftButtonPressed.png"];
    CCSprite *rightButtonSprite = [CCSprite spriteWithSpriteFrameName:@"rightButton.png"];
    CCSprite *rightButtonPressedSprite = [CCSprite spriteWithSpriteFrameName:@"rightButtonPressed.png"];

    [[leftButtonSprite texture] setAliasTexParameters];
    [[leftButtonPressedSprite texture] setAliasTexParameters];
    [[rightButtonSprite texture] setAliasTexParameters];
    [[rightButtonPressedSprite texture] setAliasTexParameters];
    
    CCMenuItemImage *leftButton = [CCMenuItemImage itemFromNormalSprite:leftButtonSprite
                                                         selectedSprite:leftButtonPressedSprite 
                                                                 target:self 
                                                               selector:@selector(moveLeft:)];
    
    CCMenuItemImage *rightButton = [CCMenuItemImage itemFromNormalSprite:rightButtonSprite 
                                                          selectedSprite:rightButtonPressedSprite 
                                                                  target:self 
                                                                selector:@selector(moveRight:)];
    
    CCLabelBMFont * selectLabel = [CCLabelBMFont labelWithString:@"select" fntFile:@"weaponFeedback.fnt"];
    CCLabelBMFont * backLabel = [CCLabelBMFont labelWithString:@"back" fntFile:@"weaponFeedback.fnt"];
    
    
		[selectLabel setColor:ccWHITE];
		[backLabel setColor:ccWHITE];
    
    [[selectLabel texture] setAliasTexParameters];
    [[backLabel texture] setAliasTexParameters];
    
    CCMenuItemLabel * select = [CCMenuItemLabel itemWithLabel:selectLabel target:self selector:@selector(levelSelected:)];
		CCMenuItemLabel * back = [CCMenuItemLabel itemWithLabel:backLabel target:self selector:@selector(backToMenu:)];
    
    
    
    CCMenu *menu  = [CCMenu menuWithItems:leftButton, rightButton, back, select, nil];
    [self addChild:menu z:0 tag:0];
    [menu setPosition:ccp(240,160)];

    [leftButton setPosition:ccp(-200, 0)];
    [rightButton setPosition:ccp(200, 0)];
    [back setPosition:ccp(-160, -120)];
    [select setPosition:ccp(160, -120)];
     
    
    [self addChild:[CCSprite spriteWithFile:[NSString stringWithFormat:@"Level%dPreview.png", 1]] z:2 tag:1];
    [[self getChildByTag:1] setPosition:ccp(240, 180)];
    
    [self addChild:[CCSprite spriteWithFile:[NSString stringWithFormat:@"Level%dPreview.png", 2]] z:2 tag:2];
    [[self getChildByTag:2] setPosition:ccp(240, 180)];
    [[self getChildByTag:2] setVisible:NO];

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
  NSLog(@"%d", levelSelect);

}

-(void)moveLeft:(id)sender {
  [[self getChildByTag:levelSelect] setVisible:NO];

  if (levelSelect > 0)
    levelSelect--;
  
  if (levelSelect == 0)
    levelSelect = NUM_OF_LEVELS;
  
  [[self getChildByTag:levelSelect] setVisible:YES];
  
  NSLog(@"%d", levelSelect);

}

-(void)backToMenu:(id)sender {
  [[CCDirector sharedDirector] replaceScene:[MainMenuScene node]];
}

-(void)levelSelected:(id)sender {
	[[CCDirector sharedDirector]replaceScene:[GameLayer scene:levelSelect]];
}

-(void)dealloc {
  [super dealloc];
}

@end
