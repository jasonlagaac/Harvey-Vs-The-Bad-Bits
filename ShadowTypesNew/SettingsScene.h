//
//  SettingsScene.h
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SettingsScene : CCScene {
  
  
}

@end

@interface SettingsLayer : CCLayer {
  CCMenuItemLabel * controlSetting;
  CCMenuItemLabel * soundSetting;
}
@end