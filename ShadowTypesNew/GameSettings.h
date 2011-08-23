//
//  GameSettings.h
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 1/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
  kGameControlDpad = 0,
  kGameControlTilt
} ControlSettings;

@interface GameSettings : NSObject {
  NSMutableDictionary *gameSettings;
}

/** Save Game Settings
 */
-(void) saveGameSettings;

/** Change Game Controls
 */
-(ControlSettings) changeControls;

/** Get the current game controls
 */
-(ControlSettings) currentGameControls;

/** Change audio (On / Off)
 */
-(BOOL) toggleAudio;

/** Get the current audio state
 */
-(BOOL) currentAudio;


@end
