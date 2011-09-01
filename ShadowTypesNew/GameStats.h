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
  
  NSMutableDictionary *weaponStats;
  NSMutableDictionary *enemyStats;
  NSMutableDictionary *scoreStats;
  
  int  currentLevel;
  int  currentGameScore;
  bool newTopScore;
  
  NSMutableDictionary *currentWeaponKills;
  NSMutableDictionary *currentEnemyKills;

}

@property (nonatomic, readwrite) NSInteger currentGameScore;


/** Initialise game stats
 */
-(void) initialiseCurrentGameStats:(int)level;

/** Save game statistics
 */
-(void) saveGameStats;

-(void) gameOverActions;

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
-(NSMutableArray *) unlockWeapons;

/** Add a kill point based on enemy type
 * @param Name of enemy type
 */
-(void) addEnemyKill:(NSString *)enemyType;


/** Get kill count for specifc enemy
 * @param Name of enemy type
 */
-(int) enemyKillCount:(NSString *)enemyType;

/** Add point to score
 */
-(void) addPoint;

/** Set top score for the completion of a level
 * @param Level number
 * @param Level Score
 */
-(BOOL) setTopScore:(int)level score:(int)score ;

/** Obtain top score for a level
 * @param Level number
 */
-(int) levelTopScore:(int)level;
@end


