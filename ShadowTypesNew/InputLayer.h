//
//  InputLayer.h
//  ShadowTypes
//
//  Created by neurologik on 5/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"


// SneakyInput Headers
#import "ColoredCircleSprite.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"

#define MAX_JUMP_COUNT 4

@class GameLayer;
@class Player;

@interface InputLayer : CCLayer {
  // Button definitions
  SneakyButton *fireButton;
  SneakyButton *reloadButton;
  
  // Gotta make a dpad for this game
  SneakyJoystick *joystick;
  
  // Control variables
  BOOL playerAttacked;
  int jumpButtonActiveCount;
  
  // Weapon firing rate control time variables
  ccTime totalTime;
	ccTime nextShotTime;
}

@end
