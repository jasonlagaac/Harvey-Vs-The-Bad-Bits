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
#import "StatsScene.h"
#import "CreditScene.h"


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
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ShadowTypesSimple.plist"];
    
    self.isTouchEnabled = YES;
    
    
    CCSprite * background = [CCSprite spriteWithFile:@"menuBackground.png"];
    [background setPosition:ccp(250,160)];
    [[background texture] setAliasTexParameters];
    [self addChild:background];
    
    CCLabelBMFont * newgameLabel = [CCLabelBMFont labelWithString:@"new game" fntFile:@"weaponFeedback.fnt"];
    CCLabelBMFont * settingLabel = [CCLabelBMFont labelWithString:@"settings" fntFile:@"weaponFeedback.fnt"];
    CCLabelBMFont * creditsLabel = [CCLabelBMFont labelWithString:@"credits" fntFile:@"weaponFeedback.fnt"];
    CCLabelBMFont * statsLabel = [CCLabelBMFont labelWithString:@"stats" fntFile:@"weaponFeedback.fnt"];
    
    [newgameLabel setColor:ccWHITE];
    [settingLabel setColor:ccWHITE];
    [creditsLabel setColor:ccWHITE];
    [statsLabel setColor:ccWHITE];
    
    [[newgameLabel texture] setAliasTexParameters];
    [[settingLabel texture] setAliasTexParameters];
    [[creditsLabel texture] setAliasTexParameters];
    [[statsLabel texture] setAliasTexParameters];
		
    CCMenuItemLabel * newgame = [CCMenuItemLabel itemWithLabel:newgameLabel target:self selector:@selector(newGame:)];
    CCMenuItemLabel * options = [CCMenuItemLabel itemWithLabel:settingLabel target:self selector:@selector(settings:)];
    CCMenuItemLabel * credits = [CCMenuItemLabel itemWithLabel:creditsLabel target:self selector:@selector(credits:)];
    CCMenuItemLabel * stats = [CCMenuItemLabel itemWithLabel:statsLabel target:self selector:@selector(stats:)];
		
    CCMenu * menu = [CCMenu menuWithItems:newgame,options,stats,credits,nil];
    [menu alignItemsVerticallyWithPadding:10.0f];
    [self addChild:menu];
    [menu setPosition:ccp(250,120)];
    
    [newgame runAction:[CCSequence actions: [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(0,0)]  rate:2], nil]];
    [options runAction:[CCSequence actions: [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(0,0)]  rate:2], nil]];
    [credits runAction:[CCSequence actions: [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(0,0)]  rate:2], nil]];
    [stats runAction:[CCSequence actions: [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(0,0)]  rate:2], nil]];
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


-(void)credits:(id)sender
{
  [[CCDirector sharedDirector] replaceScene:[CreditScene node]];
}

-(void)stats:(id)sender {
  [[CCDirector sharedDirector] replaceScene:[StatsScene node]];
}

-(void)dealloc
{
	[super dealloc];
}

-(void)onEnter {
  [super onEnter];
  adView = [[ADBannerView alloc] init];
  [adView setDelegate:self];
  adView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifier480x32, nil];
  adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier480x32;
  [[[CCDirector sharedDirector] openGLView] addSubview:adView];

  CGSize windowSize = [[CCDirector sharedDirector] winSize];
  adView.backgroundColor = [UIColor blackColor];
  adView.transform = CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90));
  adView.center = CGPointMake(adView.frame.size.width / 2 , windowSize.height / 2 + 80);
  adView.hidden = NO;
}

-(void)onExit {
    adView.delegate = nil;
    [adView removeFromSuperview];
    [adView release];
    adView = nil;
    [super onExit];
}

# pragma mark - iAd Delegates
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    adView.hidden = NO;
}


-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}


@end
