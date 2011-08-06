//
//  GameSettings.h
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 1/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  dpad,
  tilt
} controlSettings;

@interface GameSettings : NSObject {
  BOOL soundOn;
  controlSettings controls;
}




@end
