//
//  HelloWorldLayer.m
//  ShadowTypes
//
//  Created by neurologik on 20/03/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "GameScene.h"
#import "Item.h"
#import "Player.h"
#import "BulletCache.h"
#import "Bullet.h"
#import "Enemy.h"


static void
eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	CCSprite *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		
		// TIP: cocos2d and chipmunk uses the same struct to store it's position
		// chipmunk uses: cpVect, and cocos2d uses CGPoint but in reality the are the same
		// since v0.7.1 you can mix them if you want.		
		[sprite setPosition: body->p];
		
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}

/***************************************
 
    GameLayer implementation
 
****************************************/
 @implementation GameLayer

@synthesize playerLevel;
@synthesize score;
@synthesize remainingTime;
@synthesize player;
@synthesize bulletCache;
@synthesize space;
@synthesize level;

static GameLayer* instanceOfGameLayer;

#pragma mark -
#pragma mark Scene Instance

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer z:0 tag:GameSceneLayerTagGame];
    
    InputLayer* inputLayer = [InputLayer node];
	[scene addChild:inputLayer z:1 tag:GameSceneLayerTagInput];
	
	// return the scene
	return scene;
}

// Return the instance of the gamelayer
+(GameLayer *)sharedGameLayer
{
	NSAssert(instanceOfGameLayer != nil, @"GameScene instance not yet initialized!");
	return instanceOfGameLayer;
}

#pragma mark -
#pragma mark Alloc / Dealloc

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super initWithColor:ccc4(255,255,255,255)] )) {
        
        // Initialise Chipmunk
		CGSize wins = [[CCDirector sharedDirector] winSize];
		cpInitChipmunk();
		
        // Define the space
		space = cpSpaceNew();
		cpSpaceResizeStaticHash(space, 400.0f, 40);
		cpSpaceResizeActiveHash(space, 100, 600);
		
		space->gravity = ccp(0, -600);
        
        // Load the level
        level = [[Level alloc] initWithLevel:1 game:self];
        
        // Assign gamelayer instance
        instanceOfGameLayer = self;
        
        self.playerLevel = 0; // Assign the player game level
        self.remainingTime = 75; // remaining time in seconds
        
        // Load the items and images into the framecache
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ShadowTypes.plist"];

        // Initialise items
        /*
        for (int i = 0; i < MAX_ITEMS; i++) {
            items[i] = [[Item alloc] initWithGame:self];
            [items[i] loadObj:3 spawnTime:60 removeTime:-1];
        }
        */
        
        player = [[Player alloc] initWithGame:self];
        enemy = [[Enemy alloc] initWithGame:self withEnemyType:kEnemySmall];
        
        bulletCache = [[BulletCache alloc] initWithGame:self];
        
        [self schedule: @selector(step:)];
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{	
	// don't forget to call "super dealloc"
    cpSpaceFree(space);
	[super dealloc];
}

-(void) onEnter
{
	[super onEnter];
}

#pragma mark -
#pragma mark Item Spawn Operation
-(void) checkItemSpawnTime {
    for (int i = 0; i < MAX_ITEMS; i++) {
        if ([items[i] timeToSpawn] == remainingTime) {
            [items[i] loadIntoLayer];
        } else if ([items[i] timeRemove] == remainingTime) {
            [items[i] removeFromLayer];
        }        
    }
    
    remainingTime--;
}

#pragma mark -
#pragma mark Physics Step Operation
-(void) step: (ccTime) delta
{
	int steps = 2;
	CGFloat dt = delta/(CGFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	cpSpaceHashEach(space->staticShapes, &eachShape, nil);
}

@end
