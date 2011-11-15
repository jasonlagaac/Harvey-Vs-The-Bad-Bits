//
//  AppDelegate.m
//  ShadowTypes
//
//  Created by neurologik on 20/03/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "GameScene.h"
#import "MainMenuScene.h"
#import "RootViewController.h"

@interface AppDelegate (PrivateMethods)
- (void)loadAudio;
@end



@implementation AppDelegate

@synthesize window;
@synthesize paused;
@synthesize gameSettings;
@synthesize gameStats;

+(AppDelegate *)get {
  return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}


- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if(![CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
    [glView setMultipleTouchEnabled:YES];
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// Removes the startup flicker
	[self removeStartupFlicker];
  
  gameSettings = [[GameSettings alloc] init];
  gameStats = [[GameStats alloc] init];
  
  if ([gameSettings currentAudio] == YES)
    [self enableAudio];
  else
    [self disableAudio];
    
  [self loadAudio];
  
  //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ShadowTypesSimple.plist"];
   // [[CCSpriteFrameCache sharedSpriteFrameCache] retain];
    
	// Run the intro Scene
  [[CCDirector sharedDirector] runWithScene: [MainMenuScene node]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    if (![[GameLayer sharedGameLayer]player].playerDead) {
        if (!self.paused) {
            [[GameLayer sharedGameLayer] pauseGame];
            [[CCDirector sharedDirector] pause];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  if (!self.paused)
    [[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)enableAudio {
  [CDAudioManager sharedManager].mute = NO;
}

- (void)disableAudio {
  [CDAudioManager sharedManager].mute = YES;
}

-(void)loadAudio {
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Pistol.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"MachineGun.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Phaser.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Shotgun.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Revolver.m4a"];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"PlayerJump.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Explosion.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"LaserRifle.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Rocket.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"GrenadeLauncher.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Flamethrower.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Shurikin.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"death.m4a"];
    
    
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.5];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
