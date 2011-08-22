//
//  MainMenuScene.m
//  ShadowTypesNew
//
//  Created by neurologik on 26/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameScene.h"
#import "LevelSelectScene.h"
#import "SettingsScene.h"


@implementation MainMenuScene

- (id) init {
  self = [super init];
  if (self != nil) {
		
    [self addChild:[MainMenuLayer node]];
		
  }
  return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end

@interface MainMenuLayer (Private)
-(void)showLevelSelection;
@end

@implementation MainMenuLayer 
- (id) init {
  if ((self = [super init])) {
    
    //game = [[GameLayer scene] retain];
    // Load the items and images into the framecache
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ShadowTypes.plist"];
    
    self.isTouchEnabled = YES;
    
    
    CCSprite * background = [CCSprite spriteWithFile:@"menuBackground.png"];
    [background setPosition:ccp(250,160)];
    [[background texture] setAliasTexParameters];
    [self addChild:background];
    
    CCLabelBMFont * newgameLabel = [CCLabelBMFont labelWithString:@"new game" fntFile:@"weaponFeedback.fnt"];
    CCLabelBMFont * settingLabel = [CCLabelBMFont labelWithString:@"settings" fntFile:@"weaponFeedback.fnt"];
    CCLabelBMFont * creditsLabel = [CCLabelBMFont labelWithString:@"credits" fntFile:@"weaponFeedback.fnt"];
    CCLabelBMFont * achievementLabel = [CCLabelBMFont labelWithString:@"achievements" fntFile:@"weaponFeedback.fnt"];
    
    [newgameLabel setColor:ccWHITE];
    [settingLabel setColor:ccWHITE];
    [creditsLabel setColor:ccWHITE];
    [achievementLabel setColor:ccWHITE];
    
    [[newgameLabel texture] setAliasTexParameters];
    [[settingLabel texture] setAliasTexParameters];
    [[creditsLabel texture] setAliasTexParameters];
    [[achievementLabel texture] setAliasTexParameters];
		
    CCMenuItemLabel * newgame = [CCMenuItemLabel itemWithLabel:newgameLabel target:self selector:@selector(newGame:)];
    CCMenuItemLabel * options = [CCMenuItemLabel itemWithLabel:settingLabel target:self selector:@selector(settings:)];
    CCMenuItemLabel * credits = [CCMenuItemLabel itemWithLabel:creditsLabel target:self selector:@selector(credits:)];
    CCMenuItemLabel * achievements = [CCMenuItemLabel itemWithLabel:achievementLabel target:self selector:@selector(achievements:)];
		
    CCMenu * menu = [CCMenu menuWithItems:newgame,options,achievements,credits,nil];
    [menu alignItemsVerticallyWithPadding:10.0f];
    [self addChild:menu];
    [menu setPosition:ccp(250,100)];
    
		
    [newgame runAction:[CCSequence actions: [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(0,0)]  rate:2], nil]];
    [options runAction:[CCSequence actions: [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(0,0)]  rate:2], nil]];
    [credits runAction:[CCSequence actions: [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(0,0)]  rate:2], nil]];
    [achievements runAction:[CCSequence actions: [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(0,0)]  rate:2], nil]];
  }
  return self;
}

-(void)newGame:(id)sender {
	[self showLevelSelection];
}

-(void)showLevelSelection {
	[[CCDirector sharedDirector]replaceScene:[LevelSelectScene node]];
}

-(void)settings:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[SettingsScene node]];
}

-(void)topScores:(id)sender
{
	
}

-(void)credits:(id)sender
{
  
}

-(void)achievements:(id)sender
{
  
}

-(void)dealloc
{
	[super dealloc];
}
@end
