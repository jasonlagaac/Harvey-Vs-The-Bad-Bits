//
//  AppDelegate.h
//  ShadowTypes
//
//  Created by neurologik on 20/03/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameSettings.h"
#import "GameStats.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
  
  bool paused;
  
  GameSettings *gameSettings;
  GameStats *gameStats;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, readwrite) bool paused;
@property (nonatomic, retain) GameSettings *gameSettings;
@property (nonatomic, retain) GameStats *gameStats;

+ (AppDelegate *)get;
- (void)enableAudio;
- (void)disableAudio;

@end
