//
//  GameStats.m
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameStats.h"
#import "Player.h"

@implementation GameStats

@synthesize currentGameScore;
@synthesize newTopScore;
@synthesize recentUnlockedWeapons;

- (id)init
{
    if ((self = [super init])) {
      NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) 
                                 objectAtIndex:0];
      NSString* plistPath = [documentsPath stringByAppendingPathComponent:@"GameStats.plist"];
      
      // Initialization code here.
      if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameStats" ofType:@"plist"];
        gameStatDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
      } else {
        gameStatDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
      }
      
      weaponStats = [gameStatDict objectForKey:@"Weapon"];
      enemyStats = [gameStatDict objectForKey:@"Enemy"];
      scoreStats = [gameStatDict objectForKey:@"Score"];
      
      currentWeaponKills = [[NSMutableDictionary alloc] init];
      currentEnemyKills = [[NSMutableDictionary alloc] init];
      
      currentGameScore = 0;
      newTopScore = NO;
      
      [recentUnlockedWeapons release];
      recentUnlockedWeapons = nil;
    }
    
    return self;
}

#pragma mark -
#pragma mark Current Game Stat Actions
-(void) initCurrentGameStats:(int)level {
  
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
    [[weaponStats objectForKey: key] setValue:[NSNumber numberWithInt:([overallKills intValue] + [weaponKills intValue])] 
                                       forKey:@"Kills"];
  }
  
  for (id key in currentEnemyKills) {
    NSNumber *enemyKills = (NSNumber *)[currentEnemyKills objectForKey:key];
    NSNumber *overallEnemyKills = (NSNumber *)[enemyStats objectForKey:key];
    [enemyStats setValue:[NSNumber numberWithInt:([overallEnemyKills intValue] + [enemyKills intValue])] 
                  forKey:(NSString *)key];
  }
  
  [self calcScore];
  [self unlockWeapons];
  [self saveGameStats];
}



#pragma mark -
#pragma mark GameStats Plist File Actions
-(void) saveGameStats {
  NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSString* plistPath = [documentsPath stringByAppendingPathComponent:@"GameStats.plist"];  
  
  [gameStatDict setValue:weaponStats forKey:@"Weapon"];
  [gameStatDict setValue:enemyStats forKey:@"Enemy"];
  [gameStatDict setValue:scoreStats forKey:@"Score"];
  
  NSLog(@"%@", plistPath);
  
  [gameStatDict writeToFile:plistPath atomically:YES];
  
}

#pragma mark -
#pragma mark Weapon Stat Actions
-(void) addWeaponKill:(PlayerWeapon)weapon {
  // Add a kill with a weapon
  NSString *weaponName = nil;
  
  switch (weapon) {
    case kPlayerWeaponPistol:
      weaponName = [NSString stringWithString:@"Pistol"];
      break;
      
    case kPlayerWeaponShotgun:
      weaponName = [NSString stringWithString:@"Shotgun"];
      break;
      
    case kPlayerWeaponMachineGun:
      weaponName = [NSString stringWithString:@"Machine Gun"];
      break;
      
    case kPlayerWeaponRevolver:
      weaponName = [NSString stringWithString:@"Revolver"];
      break;
    
    case kPlayerWeaponPhaser:
      weaponName = [NSString stringWithString:@"Phaser"];
      break;
      
    case kPlayerWeaponLaser:
      weaponName = [NSString stringWithString:@"Laser Rifle"];
      break;
      
    case kPlayerWeaponGattlingGun:
      weaponName = [NSString stringWithString:@"Gattling Gun"];
      break;
      
    case kPlayerWeaponFlamethrower:
      weaponName = [NSString stringWithString:@"Flamethrower"];
      break;
      
    case kPlayerWeaponGrenadeLauncher:
      weaponName = [NSString stringWithString:@"Grenade Launcher"];
      break;
      
    case kPlayerWeaponRocket:
      weaponName = [NSString stringWithString:@"Rocket Launcher"];
      break;
      
    case kPlayerWeaponShurikin:
      weaponName = [NSString stringWithString:@"Shurikin"];
      break;
      
    default:
      break;
  }
  
  NSNumber *numKills = (NSNumber*)[currentWeaponKills objectForKey: weaponName];
  [currentWeaponKills setValue:[NSNumber numberWithInt:([numKills intValue] + 1)] forKey:weaponName];
  NSLog(@"%@",currentWeaponKills);
}

-(int) weaponKillCount:(NSString *)weapon {
  NSNumber *numKills = (NSNumber*)[currentWeaponKills objectForKey: weapon];
  return [numKills intValue];
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

-(int) totalEnemyKilled:(NSString *)enemyType {
  NSNumber *enemyKills = (NSNumber*)[enemyStats objectForKey: enemyType];
  return [enemyKills intValue];
}

#pragma mark -
#pragma mark Score Actions
-(void) addPoint {
  currentGameScore++;
}

-(BOOL) calcScore {
  NSNumber *currentTopScore = (NSNumber*)[scoreStats objectForKey:[NSString stringWithFormat:@"%d", currentLevel]];

  if (currentGameScore > [currentTopScore intValue]) {
    [scoreStats setValue:[NSNumber numberWithInt:currentGameScore] forKey:[NSString stringWithFormat:@"%d",currentLevel]];
    self.newTopScore = YES;

    return YES;
  }
  return NO;
}

-(int) levelTopScore:(int)level {
  NSNumber *currentTopScore = (NSNumber*)[scoreStats objectForKey:[NSString stringWithFormat:@"%d", level]];
  return [currentTopScore intValue];
}

#pragma mark -
#pragma mark Achievement actions

-(void) unlockWeapons {
  recentUnlockedWeapons= [[NSMutableArray alloc] init];
  
  for (id key in weaponStats) {
    int weaponKillCount = [[[weaponStats objectForKey:key] objectForKey:@"Kills"] intValue];
    
    if ( weaponKillCount > 100) {
      int weapon_id = [[[weaponStats objectForKey:key] objectForKey:@"id"] intValue];

      switch (weapon_id) {
        case kPlayerWeaponPistol:
            if (![[[weaponStats objectForKey:@"Revolver"] objectForKey:@"Enabled"] boolValue]) {
              [[weaponStats objectForKey:@"Revolver"] setValue:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
              [recentUnlockedWeapons addObject:[NSString stringWithString:@"Revolver"]];
            }
          break;
          
        case kPlayerWeaponShotgun:
          if (![[[weaponStats objectForKey:@"Machine Gun"] objectForKey:@"Enabled"] boolValue]) {
            [[weaponStats objectForKey:@"Machine Gun"] setValue:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
            [recentUnlockedWeapons addObject:[NSString stringWithString:@"Machine Gun"]];
          }
          break;
          
        case kPlayerWeaponMachineGun:
          if (![[weaponStats objectForKey:@"Phaser"] boolValue]) {
            [[weaponStats objectForKey:@"Phaser"] setValue:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
            [recentUnlockedWeapons addObject:[NSString stringWithString:@"Phaser"]];

          }
          break;
          
        case kPlayerWeaponRevolver:
          if (![[weaponStats objectForKey:@"Shurikin"] boolValue]) {
            [[weaponStats objectForKey:@"Shurikin"] setValue:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
            [recentUnlockedWeapons addObject:[NSString stringWithString:@"Shurikin"]];

          }
          break;
          
        case kPlayerWeaponPhaser:
          if (![[weaponStats objectForKey:@"Laser Rifle"] boolValue]) {
            [[weaponStats objectForKey:@"Laser Rifle"] setValue:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
            [recentUnlockedWeapons addObject:[NSString stringWithString:@"Laser Rifle"]];

          }
          break;
          
        case kPlayerWeaponShurikin:
          if (![[weaponStats objectForKey:@"Rocket Launcher"] boolValue]) {
            [[weaponStats objectForKey:@"Rocket Launcher"] setValue:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
            [recentUnlockedWeapons addObject:[NSString stringWithString:@"Rocket Launcher"]];

          }
          break;
          
        case kPlayerWeaponRocket:
          if (![[weaponStats objectForKey:@"Grenade Launcher"] boolValue]) {
            [[weaponStats objectForKey:@"Grenade Launcher"] setValue:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
            [recentUnlockedWeapons addObject:[NSString stringWithString:@"Grenade Launcher"]];

          }
          break;
          
        case kPlayerWeaponGrenadeLauncher:
          if (![[weaponStats objectForKey:@"Flamethrower"] boolValue]) {
            [[weaponStats objectForKey:@"Flamethrower"] setValue:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
            [recentUnlockedWeapons addObject:[NSString stringWithString:@"Flamethrower"]];
          }
          break;
          
        case kPlayerWeaponFlamethrower:
          if (![[weaponStats objectForKey:@"Gattling Gun"] boolValue]) {
            [[weaponStats objectForKey:@"Gattling Gun"] setValue:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
            [recentUnlockedWeapons addObject:[NSString stringWithString:@"Gattling Gun"]];
          }
          break;
          
        default:
          break;
      }
        
    }
  }
  
  NSLog(@"%@", weaponStats);
}

-(NSMutableArray *) enabledWeapons {
  NSMutableArray *unlockedWeaponList = [[[NSMutableArray alloc] init] autorelease];
  
  for (id key in weaponStats) {
    BOOL weaponEnabledStatus = [[[weaponStats objectForKey:key] objectForKey:@"Enabled"] boolValue];
    
    if (weaponEnabledStatus == YES) {
      int weapon_id = [[[weaponStats objectForKey:key] objectForKey:@"id"] intValue];
      NSLog(@"%@", key);
      
      [unlockedWeaponList addObject:[NSNumber numberWithInt:weapon_id]];
    }
  }
  
  return unlockedWeaponList;
}

-(NSMutableArray *) enabledWeaponsList {
  NSMutableArray *unlockedWeaponList = [[[NSMutableArray alloc] init] autorelease];
  
  for (id key in weaponStats) {
    BOOL weaponEnabledStatus = [[[weaponStats objectForKey:key] objectForKey:@"Enabled"] boolValue];
    
    if (weaponEnabledStatus == YES) {
      NSLog(@"%@", weaponEnabledStatus ? @"YES" : @"NO" );
      [unlockedWeaponList addObject:key];
    }
  }
  
  return unlockedWeaponList;
}

@end
