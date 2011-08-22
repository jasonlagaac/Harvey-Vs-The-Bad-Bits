//
//  GameStats.h
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameStats : NSObject {
  NSMutableDictionary *gameStatDict;
  
  NSDictionary *weaponStats;
  NSDictionary *enemyStats;
  NSDictionary *scoreStats;
}

/** Save game statistics
 */
-(void) saveGameStats;

/** Add a kill point to a specific weapon
 *  @param Name of the weapon
 */
-(void) addWeaponKill:(NSString *)weapon;

/** Get the number of kills from a specific weapon
 *  @param Name of the weapon
 */
-(int) weaponKillCount:(NSString *)weapon;

/** Enable a weapon for usage in-game
 *  @param Name of the weapon
 */
-(void) unlockWeapon:(NSString *)weapon;

/** Obtain a list of weapons
 */
-(NSMutableArray *) unlockedWeaponList;

/** Add a kill point based on enemy type
 * @param Name of enemy type
 */
-(void) addEnemyKill:(NSString *)enemyType;


/** Get kill count for specifc enemy
 * @param Name of enemy type
 */
-(int) enemyKillCount:(NSString *)enemyType;

/** Add top score for the completion of a level
 * @param Level number
 * @param Level Score
 */
-(void) addTopScore:(int)level score:(int)score;

/** Obtain top score for a level
 * @param Level number
 */
-(int) levelTopScore:(int)level;
@end


