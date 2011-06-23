//
//  AppDelegate.h
//  ShadowTypes
//
//  Created by neurologik on 20/03/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
  bool paused;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, readwrite) bool paused;

+(AppDelegate *)get;

@end
