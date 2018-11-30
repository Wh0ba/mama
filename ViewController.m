#import "ViewController.h"
#import "myScene.h"
#import "menuScene.h"

#import <SpriteKit/SpriteKit.h>



@implementation ViewController {
	
}



- (void)viewDidAppear:(BOOL)animated { 
	[super viewDidAppear:animated];
	
	self.view = [[SKView alloc] initWithFrame:screenFrame];
	
	
	//show FPS (frames per second)
	((SKView*)self.view).showsFPS = YES;
	//show the node/object count
	((SKView*)self.view).showsNodeCount = YES;
	
	menuScene *FirstScene = [menuScene sceneWithSize:self.view.bounds.size];
	
	FirstScene.scaleMode = SKSceneScaleModeAspectFill;
	
	//Setting the scene
	
	[((SKView*)self.view) presentScene:FirstScene];
}

- (BOOL)prefersStatusBarHidden
{
	return true;
}

@end
