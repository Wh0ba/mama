#import "menuScene.h"
#import "myScene.h"


// assets





#define btn1 @"assets/ui/btn1.png"




void refreshAudioBtn();

@interface menuScene ()

@property (nonatomic, assign) BOOL audioState;
@property (nonatomic, strong) SKSpriteNode *audioBtn;

@end



@implementation menuScene {
}

@synthesize audioBtn, audioState;

-(id)initWithSize:(CGSize)size {
	
	if (self = [super initWithSize:size]) {
		
		[self setupScene];
	}
	
	return self;
	
	
}


-(void) setupScene{
	
	self.backgroundColor = [SKColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1.00];
	
	
	
	 // start title
	_title = [SKLabelNode labelNodeWithFontNamed:@"Copperplate-Bold"];
	
	_title.text = [NSString stringWithFormat:@"ΦTERS"];
	_title.fontColor = [SKColor redColor];
	_title.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 150);
	_title.verticalAlignmentMode = 1;
	[self addChild:_title];
	
	// title end
	
	// start button 
	_startBtn = [SKSpriteNode spriteNodeWithImageNamed:btn1];
    _startBtn.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height / 3);
    _startBtn.xScale = 0.5;
    _startBtn.yScale = 0.5;
    _startBtn.name = @"startButton";
    _startBtn.alpha = 0.01;
    SKAction *fade1 = [SKAction fadeInWithDuration:1];
    
    SKAction *fadeIn = [SKAction runBlock:^{
    [_startBtn runAction:fade1];
		}];
		
     [self addChild:_startBtn];
		
		
		
		[self runAction:fadeIn];
	//end button
	
	audioState = [[[NSUserDefaults standardUserDefaults] objectForKey:@"audioState"] boolValue] ?: false;
	
	SKTexture * atext = [SKTexture textureWithImageNamed:audioState?soundOn : soundOff];
	
	audioBtn = [SKSpriteNode spriteNodeWithTexture:atext];
	audioBtn.size = CGSizeMake(40,40);
	audioBtn.name = @"audioButton";
	audioBtn.position = CGPointMake(40, self.frame.size.height / 3);
	audioBtn.anchorPoint =  CGPointMake(0.0,0.0);
	
	[self addChild:audioBtn];
	
	
}



//touches began 
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInNode:self];
   
    

    //if start button touched, bring the rain
    SKNode *node = [self nodeAtPoint:location];
    
    // if next button touched, start transition to next scene
	
	if ([node.name isEqualToString:@"startButton"]) {
		myScene *playScene = [[myScene alloc] initWithSize:self.view.bounds.size];
		playScene.scaleMode = SKSceneScaleModeAspectFill;
		[self.view presentScene:playScene];
	}
	if ([node.name isEqualToString:@"audioButton"]) {
		
		audioState = !audioState;
		
		[[NSUserDefaults standardUserDefaults] setObject:@(audioState) forKey:@"audioState"];
		
		
		audioBtn.texture = [SKTexture textureWithImageNamed:audioState?soundOn :soundOff];
		
	}
}




@end
