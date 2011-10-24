//
//  StatsScene.m
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 21/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CreditScene.h"

@implementation CreditScene

- (id)init {
  self = [super init];
  if (self != nil) {
    [self addChild:[CreditLayer node]];
  }
  
  return self;
}

- (void)dealloc {
  [super dealloc];
}

@end

@implementation CreditLayer

-(id) init {  
  if (self = [super init]) {
    self.isTouchEnabled = YES;
    
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    // Header Position
    CGPoint headerPos = CGPointMake((screenSize.width / 2), (screenSize.height - 30.0));
    CCLabelBMFont *header = [CCLabelBMFont labelWithString:@"CREDITS" fntFile:@"weaponFeedbackLarge.fnt"];
    [[header texture] setAliasTexParameters];
    header.color = ccc3(66, 186, 222);
    [self addChild:header z:1 tag:1];
    header.position = headerPos;
    
    CCLabelBMFont *created = [CCLabelBMFont labelWithString:@"created by" fntFile:@"weaponFeedback.fnt"];
    [[header texture] setAliasTexParameters];
    created.color = ccc3(255,186,16);
    [self addChild:created z:1 tag:1];
    created.position = CGPointMake((screenSize.width / 2), (screenSize.height - 90.0));
    
    CCLabelBMFont *creator = [CCLabelBMFont labelWithString:@"jason lagaac" fntFile:@"weaponFeedbackSmall.fnt"];
    [[creator texture] setAliasTexParameters];
    creator.color = ccWHITE;
    [self addChild:creator z:1 tag:1];
    creator.position = CGPointMake((screenSize.width / 2), (screenSize.height - 120.0));
    
    CCLabelBMFont *inspired = [CCLabelBMFont labelWithString:@"adapted from" fntFile:@"weaponFeedback.fnt"];
    [[inspired texture] setAliasTexParameters];
    inspired.color = ccc3(255,186,16);
    [self addChild:inspired z:1 tag:1];
    inspired.position = CGPointMake((screenSize.width / 2), (screenSize.height - 150.0));

    CCLabelBMFontMultiline *inspiration = [CCLabelBMFontMultiline labelWithString:@"Super Crate Box\n by\n Vlambeer" 
                                                                          fntFile:@"weaponFeedbackSmall.fnt"
                                                                            width:420.0 
                                                                        alignment:CenterAlignment];
    [[inspiration texture] setAliasTexParameters];
    inspiration.color = ccWHITE;
    [self addChild:inspiration z:1 tag:1];
    inspiration.position = CGPointMake((screenSize.width / 2), (screenSize.height - 200.0));
    
    
    CCLabelBMFont *backLabel = [CCLabelBMFont labelWithString:@"back" fntFile:@"weaponFeedback.fnt"];
    [backLabel setColor:ccWHITE];
    [[backLabel texture] setAliasTexParameters];
    CCMenuItemLabel *backButton = [CCMenuItemLabel itemWithLabel:backLabel target:self selector:@selector(backToMenu:)];
    
    CCMenu *menu = [CCMenu menuWithItems:backButton, nil];

    [self addChild:menu];
    [backButton setPosition:ccp(-160, -130)];
    
  }
  
  return self;
}

-(void) dealloc {
  [super dealloc];
}

-(void)backToMenu:(id)sender {
  [[[AppDelegate get] gameSettings] saveGameSettings];
  [[CCDirector sharedDirector] replaceScene:[MainMenuScene node]];
}

@end
