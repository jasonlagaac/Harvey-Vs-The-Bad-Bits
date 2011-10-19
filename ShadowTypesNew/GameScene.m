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
#import "ExplosionCache.h"
#import "ProjectileCache.h"
#import "Bullet.h"
#import "Enemy.h"
#import "GameOverLayer.h"
#import "AppDelegate.h"


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


@interface GameLayer (private) 
- (void)updateScore;
- (void)spawnEnemy;
- (void)loadParticleEffects;
- (void)loadSound;
-(id) initWithLevel:(int)levelSelected;
@end

@implementation GameScene 
- (id) init {
  self = [super init];
  if (self != nil) {
		
    [self addChild:[GameLayer node]];
		
  }
  return self;
}

-(void)dealloc
{
	[super dealloc];
}
  
@end

@implementation GameLayer

@synthesize playerLevel;
@synthesize score;
@synthesize remainingTime;
@synthesize player;
@synthesize bulletCache;
@synthesize enemyCache;
@synthesize explosionCache;
@synthesize projectileCache;
@synthesize space;
@synthesize level;
@synthesize cartridge;

static GameLayer* instanceOfGameLayer;

#pragma mark -
#pragma mark Scene Instance

+(CCScene *) scene:(int)level
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [[[GameLayer alloc] initWithLevel:level] autorelease];
	
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
-(id) initWithLevel:(int)levelSelected
{
  // always call "super" init
  // Apple recommends to re-assign "self" with the "super" return value
  if ((self = [super init])) {
    
    // Need the screen window size for iPad and iPhone differentiation 
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    // Assign gamelayer instance
    instanceOfGameLayer = self;
        
    nextSpawnTime = 0;
    
    // Initialise Chipmunk
    cpInitChipmunk();
    
    // Define the space
    space = cpSpaceNew();
    cpSpaceResizeStaticHash(space, 400.0f, 40);
    cpSpaceResizeActiveHash(space, 100, 600);
    
    space->gravity = ccp(0, -600);
    
    // Load the background & level content
    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
    [self addChild:colorLayer z:0];
        
    CCSprite *levelLayer= [CCSprite spriteWithFile:[NSString stringWithFormat:@"Level%dLayer.png",levelSelected]];
    [self addChild:levelLayer z:6];
    
    levelLayer.position = CGPointMake(240, 160);
    [[levelLayer texture] setAliasTexParameters];
    
    // Load the level
    level = [[Level alloc] initWithLevel:levelSelected game:self];
    
    [self loadParticleEffects];
    [self loadSound];
    
    self.playerLevel = 0; // Assign the player game level
    self.remainingTime = 75; // remaining time in seconds
    
    // Initialise game statistics
    [[[AppDelegate get] gameStats] initCurrentGameStats:levelSelected];
    
    // Initialise the Score Label
    CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", 0] 
                                                       fntFile:@"scoreFeedback.fnt"];
    
    [self addChild:scoreLabel z:12 tag:K_ScoreLabel];
    [[scoreLabel texture] setAliasTexParameters];
    [scoreLabel setPosition:CGPointMake((screenSize.width / 2), (screenSize.height - 40))];
    [scoreLabel setAnchorPoint:ccp(0.5,0)];
    
    
    cartridge = [[Item alloc] initWithGame:self withType:kCartridge];
    player = [[Player alloc] initWithGame:self];
    
    NSMutableArray *spawnPos = [[NSMutableArray alloc] init];
    CGPoint pos = CGPointMake(240.0f, 340.0f);
    
    [spawnPos addObject:[NSData dataWithBytes:&pos length:sizeof(CGPoint)]];
    
    enemyCache = [[EnemyCache alloc] initWithGame:self];
    bulletCache = [[BulletCache alloc] initWithGame:self];
    explosionCache = [[ExplosionCache alloc] initWithGame:self];
    projectileCache = [[ProjectileCache alloc] initWithGame:self];
    
    
    
    [self schedule: @selector(step:)];
  }
  return self;
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc {	
	// don't forget to call "super dealloc"
  cpSpaceFree(space);
	[super dealloc];
}

- (void)onEnter {
	[super onEnter];
}


- (void)loadParticleEffects {
  /* Particle Effects */
  CCParticleSystem *effect;
  
  effect = [CCParticleSystemPoint particleWithFile:@"EnemyExplode.plist"];
  effect.autoRemoveOnFinish = YES;
  [effect setPosition:CGPointMake(-2000, -2000)];
  
  [self addChild:effect z:7];
  
  
  effect = [CCParticleSystemPoint particleWithFile:@"WeaponPickup.plist"];
  effect.autoRemoveOnFinish = YES;
  [effect setPosition:CGPointMake(-2000, -2000)];

  [self addChild:effect z:7];
}

-(void) loadSound {
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"Pistol.m4a"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"MachineGun.m4a"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"Phaser.m4a"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"Shotgun.m4a"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"Revolver.m4a"];

  [[SimpleAudioEngine sharedEngine] preloadEffect:@"ShotgunReload.m4a"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"PlayerJump.m4a"];
  [[SimpleAudioEngine sharedEngine] preloadEffect:@"Explosion.m4a"];
  
  [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.5];

}

- (void)updateScore {
  CCLabelBMFont *l = (CCLabelBMFont *)[self getChildByTag:K_ScoreLabel];
  int gameScore = [[[AppDelegate get] gameStats] currentGameScore];
  [l setString:[NSString stringWithFormat:@"%d", gameScore]];
}

- (void)spawnEnemy {
  if (arc4random() % 2) {
    [[self enemyCache] spawnEnemy];
  }
}

-(void) shakeScreen {
  float randx = ((arc4random() % 5) - 0.5);
  float randy = ((arc4random() % 5) - 0.5);
  
  self.position = CGPointMake(randx, randy);
  
}

-(void) restoreScreen {
  self.position = CGPointZero;
}


-(void) pauseGame {
  [InputLayer sharedInputLayer].visible = NO;
  
  PauseLayer *p = [[[PauseLayer alloc] init] autorelease];
  [self addChild:p z:40 tag:42];
  
  if (![[AppDelegate get] paused]) {
    [AppDelegate get].paused = YES;
    [[CCDirector sharedDirector] pause];
  }
}

-(void) gameOver {
  [InputLayer sharedInputLayer].visible = NO;
  [[[AppDelegate get] gameStats] gameOverActions];
  
  GameOverLayer *g = [[GameOverLayer alloc] init];
  [self addChild:g z:40 tag:42];
}

-(void) resume {
  [InputLayer sharedInputLayer].visible = YES;
  if (![AppDelegate get].paused) {
    return;
  }
  [AppDelegate get].paused = NO;
  [[CCDirector sharedDirector] resume];
  
}



#pragma mark -
#pragma mark Game Step Operation
- (void)step:(ccTime)delta
{
	int steps = 2;
	CGFloat dt = delta/(CGFloat)steps;
	
  nextSpawnTime += delta;
  
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	cpSpaceHashEach(space->staticShapes, &eachShape, nil);
  
  [[self enemyCache] runEnemyActions];
  [[self player] checkEnemyCollision];
  [[self cartridge] checkItemCollision];
  [[self projectileCache] runProjectileActions:delta];
    
  if (nextSpawnTime > 1.0f) {
    [self spawnEnemy];
    nextSpawnTime = 0.0f;
  }
}

@end
