//
//  GameStats.m
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameStats.h"

@implementation GameStats

- (id)init
{
    self = [super init];
    if (self) {
      // Initialization code here.
      NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameStats" ofType:@"plist"];
      gameStatDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
      
      weaponStats = [gameStatDict objectForKey:@"Weapon"];
      enemyStats = [gameStatDict objectForKey:@"Enemy"];
      scoreStats = [gameStatDict objectForKey:@"Score"];
      
    }
    
    return self;
}

#pragma mark -
#pragma mark GameStats Plist File Actions
-(void) saveGameStats {
  NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameStats" ofType:@"plist"];
  [gameStatDict setValue:weaponStats forKey:@"Weapon"];
  [gameStatDict setValue:enemyStats forKey:@"Enemy"];
  [gameStatDict setValue:scoreStats forKey:@"Score"];
  
  [gameStatDict writeToFile:plistPath atomically:YES];
}

#pragma mark -
#pragma mark Weapon Stat Actions

-(void) addWeaponKill:(NSString *)weapon {
  // Add a kill with a weapon
  NSNumber *numKills = (NSNumber*)[[weaponStats objectForKey: weapon] objectForKey:@"Kills"];
  [[weaponStats objectForKey: weapon] setValue:[NSNumber numberWithInt:([numKills intValue] + 1)] forKey:@"Kills"];
}

-(int) weaponKillCount:(NSString *)weapon {
  NSNumber *numKills = (NSNumber*)[[weaponStats objectForKey: weapon] objectForKey:@"Kills"];
  return [numKills intValue];
}

-(void) unlockWeapon:(NSString *)weapon {
  // Unlock a weapon for selection
  [[weaponStats objectForKey:weapon] setValue:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
}

-(NSMutableArray *)unlockedWeaponList {
  NSMutableArray *weaponsList = [[weaponStats allKeys] mutableCopy];
  
  for (NSString *weaponKey in weaponsList) {
    if (![[weaponStats objectForKey:weaponKey] objectForKey:@"Enabled"]) {
      [weaponsList removeObject:weaponKey];
    }
  }
  
  return weaponsList;
}

#pragma mark -
#pragma mark Enemy Kill Actions
-(void) addEnemyKill:(NSString *)enemyType {
  // Add an kill point for specific enemy
  NSNumber *enemyKills = (NSNumber*)[enemyStats objectForKey: enemyType];
  [enemyStats setValue:[NSNumber numberWithInt:([enemyKills intValue] + 1)] forKey:enemyType];
}

-(int) enemyKillCount:(NSString *)enemyType {
  NSNumber *enemyKills = (NSNumber*)[enemyStats objectForKey: enemyType];
  return [enemyKills intValue];
}

#pragma mark -
#pragma mark Score Actions
-(void) addTopScore:(int)level score:(int)score {
  NSNumber *currentTopScore = (NSNumber*)[scoreStats objectForKey:[NSString stringWithFormat:@"%d", level]];

  if (score > [currentTopScore intValue]) {
    [scoreStats setValue:[NSNumber numberWithInt:score] forKey:[NSString stringWithFormat:@"%d",level]];
  }
}

-(int) levelTopScore:(int)level {
  NSNumber *currentTopScore = (NSNumber*)[scoreStats objectForKey:[NSString stringWithFormat:@"%d", level]];
  return [currentTopScore intValue];
}



@end
