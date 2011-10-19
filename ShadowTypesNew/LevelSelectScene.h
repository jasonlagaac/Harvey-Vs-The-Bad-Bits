//
//  LevelSelectScene.h
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define NUM_OF_LEVELS 2

@interface LevelSelectScene : CCScene {
  
}

@end

@interface LevelSelectLayer : CCLayer {
  int levelSelect;
  
  CCLabelBMFont *topScoreLbl;
}

@end
