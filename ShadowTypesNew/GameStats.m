//
//  GameStats.m
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameStats.h"


@implementation GameStats

@synthesize currentGameScore;

- (id)init
{
    if ((self = [super init])) {
      // Initialization code here.
      NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameStats" ofType:@"plist"];
      gameStatDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
      
      weaponStats = [gameStatDict objectForKey:@"Weapon"];
      enemyStats = [gameStatDict objectForKey:@"Enemy"];
      scoreStats = [gameStatDict objectForKey:@"Score"];
      
      currentWeaponKills = [[NSMutableDictionary alloc] init];
      currentEnemyKills = [[NSMutableDictionary alloc] init];
      
      currentGameScore = 0;
      newTopScore = NO;

    }
    
    return self;
}

#pragma mark -
#pragma mark Current Game Stat Actions
-(void) initialiseCurrentGameStats:(int)level {
  
  // Reset the current weapon stats
  for (id key in weaponStats) {
    [currentWeaponKills setObject:[NSNumber numberWithInt:0] forKey:key];
  }
  
  NSLog(@"%@", currentWeaponKills);
  
  // Reset the current enemy stats
  for (id key in enemyStats) {
    [currentEnemyKills setObject:[NSNumber numberWithInt:0] forKey:key];
  }

  NSLog(@"%@", currentEnemyKills);
  

  currentLevel = level;
  currentGameScore = 0;
  newTopScore = NO;
}

-(void) gameOverActions {
  for (id key in currentWeaponKills) {
    NSNumber *weaponKills = (NSNumber *)[currentWeaponKills objectForKey:key];
    NSNumber *overallKills = (NSNumber *)[[weaponStats objectForKey:key] objectForKey:@"Kills"];
    [[weaponStats objectForKey: key] setValue:[NSNumber numberWithInt:([overallKills intValue] + [weaponKills intValue])] forKey:@"Kills"];
  }
  
  for (id key in currentEnemyKills) {
    NSNumber *enemyKills = (NSNumber *)[currentEnemyKills objectForKey:key];
    NSNumber *overallEnemyKills = (NSNumber *)[enemyStats objectForKey:key];
    //[[weaponStats objectForKey: key] setValue:[NSNumber numberWithInt:([overallKills intValue] + [currentGameKills intValue])] forKey:@"Kills"];
    [enemyStats setValue:[NSNumber numberWithInt:([overallEnemyKills intValue] + [enemyKills intValue])] forKey:(NSString *)key];
  }
  
  [self setTopScore:currentLevel score:currentGameScore];
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
  NSNumber *numKills = (NSNumber*)[currentWeaponKills objectForKey: weapon];
  [currentWeaponKills setValue:[NSNumber numberWithInt:([numKills intValue] + 1)] forKey:weapon];
  NSLog(@"%@",currentWeaponKills);

}

-(int) weaponKillCount:(NSString *)weapon {
  NSNumber *numKills = (NSNumber*)[currentWeaponKills objectForKey: weapon];
  return [numKills intValue];
}

-(NSMutableArray *) unlockWeapons {
  NSMutableArray *unlockedWeaponList = [[NSMutableArray alloc] init];
  
  for (id key in weaponStats) {
    int weaponKillCount = [[[weaponStats objectForKey:key] objectForKey:@"Kills"] intValue];
    bool weaponEnabledStatus = [[[weaponStats objectForKey:key] objectForKey:@"Enabled"] boolValue];
    
    if (( weaponKillCount > 100) && (weaponEnabledStatus == NO)) {
      [[weaponStats objectForKey:key] setValue:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
      [unlockedWeaponList addObject:key];
    }
  }
  
  return unlockedWeaponList;
}

#pragma mark -
#pragma mark Enemy Kill Actions
-(void) addEnemyKill:(NSString *)enemyType {
  // Add an kill point for specific enemy
  NSNumber *enemyKills = (NSNumber*)[currentEnemyKills objectForKey: enemyType];
  [currentEnemyKills setValue:[NSNumber numberWithInt:([enemyKills intValue] + 1)] forKey:enemyType];
  NSLog(@"%@",currentEnemyKills);
}

-(int) enemyKillCount:(NSString *)enemyType {
  NSNumber *enemyKills = (NSNumber*)[currentEnemyKills objectForKey: enemyType];
  return [enemyKills intValue];
}

#pragma mark -
#pragma mark Score Actions
-(void) addPoint {
  currentGameScore++;
  NSLog(@"%d", currentGameScore);
}

-(BOOL) setTopScore:(int)level score:(int)score {
  NSNumber *currentTopScore = (NSNumber*)[scoreStats objectForKey:[NSString stringWithFormat:@"%d", level]];

  if (score > [currentTopScore intValue]) {
    return YES;
    [scoreStats setValue:[NSNumber numberWithInt:score] forKey:[NSString stringWithFormat:@"%d",level]];
  }
  return NO;
}

-(int) levelTopScore:(int)level {
  NSNumber *currentTopScore = (NSNumber*)[scoreStats objectForKey:[NSString stringWithFormat:@"%d", level]];
  return [currentTopScore intValue];
}



@end
