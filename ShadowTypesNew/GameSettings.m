//
//  GameSettings.m
//  ShadowTypesNew
//
//  Created by Jason Lagaac on 1/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings

- (id)init
{
    self = [super init];
    if (self) {
      NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
      NSString *filePath = [path stringByAppendingString:@"gameSettings.dat"];
    }
    
    return self;
}

@end
