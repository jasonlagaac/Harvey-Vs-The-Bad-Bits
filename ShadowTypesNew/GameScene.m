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
#import "EnemyCache.h"
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
@synthesize enemyCache;
@synthesize space;
@synthesize level;
@synthesize ammoBox;
@synthesize cartridge;

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
        
        // Need the screen window size for iPad and iPhone differentiation 
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        // Initialise Chipmunk
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
        
        // Initialise the Score Label
        CCLabelAtlas *scoreLabel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"ScoreNumbers.png" itemWidth:25 itemHeight:23 startCharMap:'.'];
        
        [self addChild:scoreLabel z:12 tag:K_ScoreLabel];
        [scoreLabel setPosition:CGPointMake((screenSize.width / 2), (screenSize.height - 30))];
        [scoreLabel setAnchorPoint:ccp(0.5,0)];


        cartridge = [[Item alloc] initWithGame:self withType:kCartridge];
        ammoBox = [[Item alloc] initWithGame:self withType:kAmmoPack];
        player = [[Player alloc] initWithGame:self];

        NSMutableArray *spawnPos = [[NSMutableArray alloc] init];
        CGPoint pos = CGPointMake(240.0f, 340.0f);
        
        [spawnPos addObject:[NSData dataWithBytes:&pos length:sizeof(CGPoint)]];
        
        enemyCache = [[EnemyCache alloc] initWithGame:self withLevel:1 withStartPoints:spawnPos];
        bulletCache = [[BulletCache alloc] initWithGame:self];
        
        [self schedule: @selector(step:)];
        [self schedule:@selector(update:) interval:1.0];
        
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

-(void) updateScore {
    CCLabelAtlas *l = (CCLabelAtlas *)[self getChildByTag:K_ScoreLabel];
    [l setString:[NSString stringWithFormat:@"%d", [player points]]];
}


#pragma mark -
#pragma mark Game Step Operation
-(void) step: (ccTime) delta
{
	int steps = 2;
	CGFloat dt = delta/(CGFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	cpSpaceHashEach(space->staticShapes, &eachShape, nil);
    
    [[self enemyCache] runEnemyActions];
    [[self player] playerEnemyCollision];
    [[self cartridge] checkItemCollision];
    [[self ammoBox] checkItemCollision];    
}

-(void) update: (ccTime) delta {
    if (arc4random() % 2) {
        [[self enemyCache] spawnEnemy];
    }
}

@end
