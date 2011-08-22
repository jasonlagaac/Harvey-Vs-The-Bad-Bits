//
//  GameSettings.m
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 1/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings

- (id)init
{
  self = [super init];
  if (self) {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
    gameSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
  }
  
  return self;
}

#pragma mark -
#pragma mark GameSettings Plist File Actions
-(void) saveGameSettings {
  NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameSettings" ofType:@"plist"];
  [gameSettings writeToFile:plistPath atomically:YES];
}

#pragma mark -
#pragma mark Game Control Functions
-(ControlSettings) changeControls {
  NSNumber *controlVal = [gameSettings objectForKey:@"Controls"];
  
  if ([controlVal intValue] == kGameControlDpad) {
    [gameSettings setValue:[NSNumber numberWithInt:kGameControlTilt] forKey:@"Controls"];
    return kGameControlTilt;
  } else { 
    [gameSettings setValue:[NSNumber numberWithInt:kGameControlDpad] forKey:@"Controls"];
    return kGameControlDpad;
  }
}

-(ControlSettings) currentGameControls {
  NSNumber *controlVal = [gameSettings objectForKey:@"Controls"];
  return [controlVal intValue];
}

#pragma mark -
#pragma mark Sound Control Functions
-(BOOL) toggleAudio {
  NSNumber *audioControl = [gameSettings objectForKey:@"Audio"];
  if ([audioControl boolValue])
    [gameSettings setValue:[NSNumber numberWithBool:NO] forKey:@"Audio"];
  else 
    [gameSettings setValue:[NSNumber numberWithBool:YES] forKey:@"Audio"];

  return [audioControl boolValue];
}

-(BOOL) currentAudio {
  NSNumber *audioControl = [gameSettings objectForKey:@"Audio"];
  return [audioControl boolValue];
}

@end
