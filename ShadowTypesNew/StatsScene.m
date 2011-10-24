//
//  StatsScene.m
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 21/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StatsScene.h"

@implementation StatsScene

- (id)init {
  self = [super init];
  if (self != nil) {
    [self addChild:[StatsLayer node]];
  }
  
  return self;
}

- (void)dealloc {
  [super dealloc];
}

@end

@implementation StatsLayer

-(id) init {  
  if (self = [super init]) {
    self.isTouchEnabled = YES;
    
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    // Header Position
    CGPoint headerPos = CGPointMake((screenSize.width / 2), (screenSize.height - 30.0));
    CCLabelBMFont *header = [CCLabelBMFont labelWithString:@"GAME STATS" fntFile:@"weaponFeedbackLarge.fnt"];
    [[header texture] setAliasTexParameters];
    header.color = ccc3(66, 186, 222);
    [self addChild:header z:1 tag:1];
    header.position = headerPos;
    
    CGPoint unlockHeaderPos = CGPointMake((screenSize.width / 2), (screenSize.height / 2));
    CCLabelBMFont *unlockHeader = [CCLabelBMFont labelWithString:@"available weapons" fntFile:@"weaponFeedback.fnt"];
    [[unlockHeader texture] setAliasTexParameters];
    unlockHeader.color = ccc3(255,186,16);
    [self addChild:unlockHeader z:1 tag:1];
    unlockHeader.position = unlockHeaderPos;
    
    
    CGPoint shadowIconPos = CGPointMake(((screenSize.width/2) - 140), ((screenSize.height/2) + 80));
    CGPoint shadowKillsPos = CGPointMake(((screenSize.width/2) - 135), ((screenSize.height/2) + 45));
    
    CGPoint juggernautIconPos = CGPointMake((screenSize.width/2), ((screenSize.height/2) + 83));
    CGPoint juggernautKillsPos = CGPointMake(((screenSize.width/2) + 5), ((screenSize.height/2) + 45));
    
    CGPoint exploderIconPos = CGPointMake(((screenSize.width/2) + 140), ((screenSize.height/2) + 80));
    CGPoint exploderKillsPos = CGPointMake(((screenSize.width/2) + 145), ((screenSize.height/2) + 45));
    
    
    CCSprite *shadowIcon = [CCSprite spriteWithSpriteFrameName:@"EnemySmall2.png"];
    int enemySmallKilled = [[[AppDelegate get] gameStats] totalEnemyKilled:@"Shadow"];
    
    CCLabelBMFont *shadowKills = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", enemySmallKilled]  
                                                        fntFile:@"weaponFeedback.fnt"];
    shadowKills.position = shadowKillsPos;
    shadowIcon.position = shadowIconPos;
    [self addChild:shadowKills z:1 tag:4];
    [self addChild:shadowIcon z:1 tag: 2];
    
    
    CCSprite *juggernautIcon = [CCSprite spriteWithSpriteFrameName:@"Juggernaut2.png"];
    int enemyJuggernaughtKilled = [[[AppDelegate get] gameStats] totalEnemyKilled:@"Juggernaut"];
    
    CCLabelBMFont *juggernautKills = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", enemyJuggernaughtKilled]
                                                            fntFile:@"weaponFeedback.fnt"];
    juggernautKills.position = juggernautKillsPos;
    juggernautIcon.position = juggernautIconPos;
    [self addChild:juggernautKills z:1 tag:5];
    [self addChild:juggernautIcon z:1 tag: 3];
    
    
    CCSprite *exploderIcon = [CCSprite spriteWithSpriteFrameName:@"Exploder2.png"];
    int enemyExploderKilled = [[[AppDelegate get] gameStats] totalEnemyKilled:@"Exploder"];
    CCLabelBMFont *exploderKills = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", enemyExploderKilled]
                                                          fntFile:@"weaponFeedback.fnt"];
    exploderKills.position = exploderKillsPos;
    exploderIcon.position = exploderIconPos;
    [self addChild:exploderKills z:1 tag:6];
    [self addChild:exploderIcon z:1 tag: 4];
    
    
    NSMutableArray *unlockedWeapons = [[[AppDelegate get] gameStats] enabledWeaponsList];
    CCLabelBMFontMultiline *unlockedTxt;
    
    NSString *weaponsList = [NSString stringWithString:@""];
    for (int i = 0; i < ([unlockedWeapons count]); i++) {
      weaponsList = [NSString stringWithFormat:@"%@ %@.", weaponsList, [unlockedWeapons objectAtIndex:i]];
    }
      
    unlockedTxt = [CCLabelBMFontMultiline labelWithString:weaponsList                                                                                     
                                                  fntFile:@"weaponFeedbackSmall.fnt" 
                                                    width:420.0 
                                                alignment:LeftAlignment];
      
    
    unlockedTxt.position = CGPointMake((screenSize.width / 2), ((screenSize.height /2) - 60));
    [[unlockedTxt texture] setAliasTexParameters];
    [self addChild:unlockedTxt z:1];
    
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
