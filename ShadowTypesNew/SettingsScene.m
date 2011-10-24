//
//  SettingsScene.m
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsScene.h"
#import "MainMenuScene.h"
#import "AppDelegate.h"

@implementation SettingsScene

- (id)init {
    self = [super init];
    if (self != nil) {
      [self addChild:[SettingsLayer node]];
    }
    
    return self;
}

- (void)dealloc {
  [super dealloc];
}

@end

@implementation SettingsLayer
- (id)init {
  if (self = [super init]) {
    self.isTouchEnabled = YES;
    
    CCSprite * background = [CCSprite spriteWithFile:@"settingsBackground.png"];
    [background setPosition:ccp(250,160)];
    [[background texture] setAliasTexParameters];
    [self addChild:background];
    
    CCLabelBMFont *controlLabel = nil;
    if ([[[AppDelegate get] gameSettings] currentGameControls])
      controlLabel = [CCLabelBMFont labelWithString:@"control: tilt" fntFile:@"weaponFeedback.fnt"];
    else 
      controlLabel = [CCLabelBMFont labelWithString:@"control: dpad" fntFile:@"weaponFeedback.fnt"];

    
    CCLabelBMFont *soundLabel = nil;
    
    
    if ([[[AppDelegate get] gameSettings] currentAudio])
      soundLabel = [CCLabelBMFont labelWithString:@"sound: on" fntFile:@"weaponFeedback.fnt"];
    else
      soundLabel = [CCLabelBMFont labelWithString:@"sound: off" fntFile:@"weaponFeedback.fnt"];

    
    CCLabelBMFont *backLabel = [CCLabelBMFont labelWithString:@"back" fntFile:@"weaponFeedback.fnt"];

    
    [controlLabel setColor:ccWHITE];
    [soundLabel setColor:ccWHITE];
    [backLabel setColor:ccWHITE];
    
    [[controlLabel texture] setAliasTexParameters];
    [[soundLabel texture] setAliasTexParameters];
    [[backLabel texture] setAliasTexParameters];

    
    controlSetting = [CCMenuItemLabel itemWithLabel:controlLabel target:self selector:@selector(toggleControls:)];
    soundSetting = [CCMenuItemLabel itemWithLabel:soundLabel target:self selector:@selector(toggleAudio:)];
    
    CCMenuItemLabel *backButton = [CCMenuItemLabel itemWithLabel:backLabel target:self selector:@selector(backToMenu:)];
    
    CCMenu *menu = [CCMenu menuWithItems: controlSetting, soundSetting, backButton, nil];
    [menu alignItemsVerticallyWithPadding:10.0f];
    [self addChild:menu];
    [menu setPosition:ccp(250,120)];
    [backButton setPosition:ccp(-160, -90)];

    
    [controlSetting runAction:[CCSequence actions: [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(0,0)]  rate:2], nil]];
    [soundSetting runAction:[CCSequence actions: [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(0,0)]  rate:2], nil]];

  }
  
  return self;
}


- (void)toggleControls:(id)sender {
  [[[AppDelegate get] gameSettings] changeControls];
  
  CCLabelBMFont *controlLabel = nil;
    
  if ([[[AppDelegate get] gameSettings] currentGameControls]) 

    controlLabel = [CCLabelBMFont labelWithString:@"control: tilt" fntFile:@"weaponFeedback.fnt"];
  else 
    controlLabel = [CCLabelBMFont labelWithString:@"control: dpad" fntFile:@"weaponFeedback.fnt"];

  [[controlLabel texture] setAliasTexParameters];
  [controlSetting setLabel:controlLabel];
  
}

- (void)toggleAudio:(id)sender {
  [[[AppDelegate get] gameSettings] toggleAudio];
  
  CCLabelBMFont *soundLabel = nil;
    
  if ([[[AppDelegate get] gameSettings] currentAudio]) {
    [[AppDelegate get] enableAudio];
    soundLabel = [CCLabelBMFont labelWithString:@"sound: on" fntFile:@"weaponFeedback.fnt"];
  } else {
    [[AppDelegate get] disableAudio];    
    soundLabel = [CCLabelBMFont labelWithString:@"sound: off" fntFile:@"weaponFeedback.fnt"];
  }
  
  [[soundLabel texture] setAliasTexParameters];
  [soundSetting setLabel:soundLabel];
}

-(void)backToMenu:(id)sender {
  [[[AppDelegate get] gameSettings] saveGameSettings];
  [[CCDirector sharedDirector] replaceScene:[MainMenuScene node]];
}

@end
