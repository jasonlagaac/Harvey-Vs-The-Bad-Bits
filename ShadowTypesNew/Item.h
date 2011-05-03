//
//  Item.h
//  ShadowTypes
//
//  Created by neurologik on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Entity.h"
#import "EntityActions.h"

typedef enum {
    kMedPack,
    kAmmoPack,
    kWeaponPistol,
    kWeaponShotgun,
    kWeaponSMG
} ItemType;

@interface Item : Entity <EntityActions> {
    ItemType item;
    bool collected;
    float timeRemove;
}

@property (nonatomic, readwrite) ItemType item;
@property (nonatomic, readwrite) bool collected;
@property (nonatomic, readwrite) float timeRemove;

@end
