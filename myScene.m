//arc4random_uniform()
#include <stdlib.h>
#import "myScene.h"





//statics 



static const uint32_t bulletCategory     =  0x1 << 0;
static const uint32_t enemyCategory        =  0x1 << 1;


@interface myScene ()

@property (nonatomic, strong) SKSpriteNode *pauseBtn;

	
	
	@property (nonatomic) SKEmitterNode *fire;
	
	@property (nonatomic) SKSpriteNode *player;
	
	@property (nonatomic, strong) SKLabelNode *scoreLabel;


@end



@implementation myScene {
	
	int score;
	float speed;
	float spawnSpd;
	NSDictionary* lvlPlist;
	NSDictionary* lvl1;
	NSString *confPath;
}


@synthesize pauseBtn;

-(id)initWithSize:(CGSize)size {
	
	if (self = [super initWithSize:size]) {
		
		[self setupScene];
		
		confPath = [[NSBundle mainBundle] pathForResource:@"lvl1" 
                                                     ofType:@"plist"];
		
		lvlPlist = [NSDictionary dictionaryWithContentsOfFile:confPath];
		
		
		
		[self addCo2];
	}
	
	return self;
	
	
}


-(void) setupScene{
	
	score = 0;
	
	speed = 0.5;
	
	spawnSpd = 0.8;
	
	
	self.backgroundColor = [SKColor colorWithRed:0.11 green:0.13 blue:0.20 alpha:1.00];
	
	// the stars
	
	
	NSString *starsPath = [[NSBundle mainBundle] pathForResource:@"assets/stars" ofType:@"sks"];
	
    SKEmitterNode *stars = [NSKeyedUnarchiver unarchiveObjectWithFile:starsPath];
	
	stars.position = CGPointMake(0, self.frame.size.height);
	
	[stars advanceSimulationTime:10];
	
	[self addChild:stars];
	
	stars.zPosition = -1;
	
	
	// end stars
	
	
	
	[self createScoreLabel];
	
	// the label 
	
	
	self.player = [SKSpriteNode spriteNodeWithImageNamed:ship];
	
	#pragma mark - playerSec
	self.player.position = CGPointMake(200,80);
	
	
	self.player.xScale = 0.7;
	self.player.yScale = 0.7;
	
	
	
	self.player.zPosition = 5;
	
	[self addChild:self.player];
	
	
	// physics world
	
	
	self.physicsWorld.gravity = CGVectorMake(0,0);
	
	
	
	//_fire.position = CGPointMake(self.player.position.x, self.player.position.y - 30);
	self.physicsWorld.contactDelegate = self;
	
	
	
	self.audioState = [[[NSUserDefaults standardUserDefaults] objectForKey:@"audioState"] boolValue] ?: false;
	
	
	
	SKTexture * atext = [SKTexture textureWithImageNamed:pauseImg];
	
	pauseBtn = [SKSpriteNode spriteNodeWithTexture:atext];
	pauseBtn.size = CGSizeMake(40,40);
	pauseBtn.name = @"pauseButton";
	
	CGFloat yPos =[UIScreen mainScreen].bounds.size.height - 50;
	CGFloat xPos = [UIScreen mainScreen].bounds.size.width - 50;
	pauseBtn.position = CGPointMake(xPos, yPos);
	
	[self addChild:pauseBtn];
	
}

- (void)createScoreLabel {
	
	
	
	_scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
	
	//_scoreLabel.text = [_lvl1 valueForKeyPath:@"score"];
	_scoreLabel.text = [NSString stringWithFormat:@"%d", score];
	_scoreLabel.fontColor = [UIColor colorWithRed:0.4 green:1 blue:1 alpha:1];
	_scoreLabel.position = CGPointMake(20 , self.frame.size.height - 40);
	_scoreLabel.fontSize = 26;
	_scoreLabel.zPosition = 1;
	_scoreLabel.horizontalAlignmentMode = 1;
	
	[self addChild:_scoreLabel];
	/*
	     
	SKEffectNode *effectNode =  [[SKEffectNode alloc] init];
	[effectNode addChild:_scoreLabel];
	effectNode.position = CGPointMake(20 , self.frame.size.height - 40);
	effectNode.zPosition = 1;
	
	#pragma mark -
	#pragma mark Vertex
	     
	vector_float2  vecs[] = {
	    //first row 
	    {0, 1}, {0.47, 1}, {0.95, 1},
	    //second row
	    {0, 0.5}, {0.45, 0.5}, {0.8, 0.6},
	    //third row
	    {0, 0}, {0.4, 0.2}, {0.7, 0.3} };
	     
	SKWarpGeometryGrid* warpGeometryGrid = [SKWarpGeometryGrid gridWithColumns: 2 rows: 2];
	
	vector_float2 * destp = vecs;
	     
	effectNode.warpGeometry = [warpGeometryGrid gridByReplacingDestPositions: destp];
	
	[self addChild:effectNode];
	*/
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	
	
	for (UITouch *touch in touches) {
		
		CGPoint locc = [touch locationInNode:self];
		
    //if start button touched, bring the rain
		SKNode *node = [self nodeAtPoint:locc];
		
		if ([node.name isEqualToString:@"pauseButton"]) {
			self.paused = !self.paused;
		}
		
		if (!self.paused) {
			[self movePlayerWithX:locc.x];
		}
		
		//[self shoot];
	}
	
	
}// The end of this function


- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
		for (UITouch *touch in touches) {
		
		CGPoint loca = [touch locationInNode:self];
		
		if (!self.paused) {
			[self movePlayerWithX:loca.x];
		}
		
		//[self shoot];
		
	}
}




- (void)update:(NSTimeInterval)currentTime {
    // this function get called before every Frame

    
    _scoreLabel.text = [NSString stringWithFormat:@"%d", score];

    // controlliNg  speed
    
    
    [self contSpd];
    
    
    
    
    //enemies spawning time
    CFTimeInterval timeSinceLastEnemy = currentTime - self.lastEnemyUpdateTime;
    self.lastEnemyUpdateTime = currentTime;
    if (timeSinceLastEnemy > 1) { // more than a second since last update
        timeSinceLastEnemy = 1.0 / 60.0;
        self.lastEnemyUpdateTime = currentTime;
    }
    
    [self spawnEnemyWithTime:timeSinceLastEnemy];
    
    
    
    
    
    
    
    
    // timing for bullets
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTime;
    self.lastUpdateTime = currentTime;
    if (timeSinceLast > 0.3) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTime = currentTime;
    }
    
    [self addBulletForTimeSinceLast:timeSinceLast];
    
}

// setting the timing method for spawning bullets

- (void)addBulletForTimeSinceLast:(CFTimeInterval)timeSinceLast {

    self.lastSpawnTime += timeSinceLast;
    if (self.lastSpawnTime > 0.15) {
        self.lastSpawnTime = 0;
       [self addBullet:fireball];
    }
}


// moving the player

-(void) movePlayerWithX:(CGFloat)newX
{
		
		self.player.position = CGPointMake(newX, 80);
		
		float playX = _player.position.x;
			
			if (playX < 40) 
			{
				self.player.position = CGPointMake(40, 80);
			}else if (playX > ([UIScreen mainScreen].bounds.size.width - 40)) 
			{
				self.player.position = CGPointMake([UIScreen mainScreen].bounds.size.width - 40, 80);
			}
			
			_fire.position = CGPointMake(_player.position.x,_player.position.y - 10);
}




//bullets


-(void) addBullet:(NSString *)SPName
{
	
	// creating the sprite with an image
	SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:SPName];
	// setting the sprite location
	
	bullet.position = CGPointMake(self.player.position.x, self.player.position.y + 5);
	bullet.xScale = 0.7;
	bullet.yScale = 0.7;
	bullet.zPosition = 4;
	
	
	
	//collison detection & actions
	
	bullet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bullet.size.width/2];
	
	
	bullet.physicsBody.dynamic = YES;
	
	
	bullet.physicsBody.categoryBitMask = bulletCategory;
	
	bullet.physicsBody.contactTestBitMask = enemyCategory;
	
	bullet.physicsBody.collisionBitMask = 0;
	
	bullet.physicsBody.usesPreciseCollisionDetection = YES;
	
	
	
	// making the rotation action
	//SKAction *wee = [SKAction rotateByAngle:(M_PI * 2) duration:0.5];
	
	//moving the object vertically
	SKAction *pew = [SKAction moveToY:(self.view.bounds.size.height) duration:0.8];
	// making the deleting action
	SKAction *boo = [SKAction removeFromParent];
	// creating an action sequence that plays the actions one after another
	//[bullet runAction:[SKAction repeatActionForever:wee]];
	
	SKAction *actionSeq = [SKAction sequence:@[pew,boo]];
	// running the action 
	[bullet runAction:actionSeq];
	
	if (self.audioState) {
		[self runAction:[SKAction playSoundFileNamed:FireAudio waitForCompletion:false]];
	}
	
	
	
	[self addChild:bullet];
	
	
}

// bullets collision action

-(void) bullet:(SKSpriteNode *)bullet hitEnemy:(SKSpriteNode *)enemy
{
	
	[self newExplosionOnX:enemy.position.x andY:enemy.position.y];
	
	[bullet removeFromParent];
	[enemy removeFromParent];
	
	score += 10;
	
}

// Enemy part 




- (void)spawnEnemyWithTime:(CFTimeInterval)timeSinceLast {

    self.lastEnemySpawn += timeSinceLast;
    if (self.lastEnemySpawn > spawnSpd) {
        self.lastEnemySpawn = 0;
        [self spawnEnemy];
    }
}



-(void) spawnEnemy
{
	
	NSArray<NSString*> *UFOs = @[ufoR,ufoB,ufoG,ufoY]; 
	
	
	SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:ufoR]];
	
	
	enemy.texture = [SKTexture textureWithImageNamed: UFOs[arc4random_uniform(4)]];
	
	
	
	
	int minX = 20;
 	int maxX = ([UIScreen mainScreen].bounds.size.width - 20);
	int rangeX = maxX - minX;
	int actualX = (arc4random_uniform(rangeX)) + minX;
    
    // Create the enemy slightly off-screen along the upper edge,
    
    
	
	
	enemy.speed = speed;
	
	enemy.physicsBody = [SKPhysicsBody bodyWithTexture:enemy.texture size:CGSizeMake(enemy.size.width,enemy.size.height)];
	
	
	//bodyWithRectangleOfSize:CGSizeMake(enemy.size.height - 10 , enemy.size.width)]; 
	enemy.physicsBody.dynamic = YES;
	enemy.physicsBody.categoryBitMask = enemyCategory; 
	enemy.physicsBody.contactTestBitMask = bulletCategory; 
	enemy.physicsBody.collisionBitMask = 0; 
	
	
	
	
	
    // and along a random position along the X axis as calculated above
			enemy.position = CGPointMake(actualX, [UIScreen mainScreen].bounds.size.height + enemy.size.height);
			[self addChild:enemy];
			enemy.xScale = 0.5;
			enemy.yScale = 0.5;
			enemy.zPosition = 4;
	
	
	
    // Create the actions
			SKAction * actionMove = [SKAction moveToY:(0 - enemy.size.height) duration:2];
			SKAction * actionMoveDone = [SKAction removeFromParent];
			SKAction *dec = [SKAction runBlock:^{ score -= 25; }];
			[enemy runAction:[SKAction sequence:@[actionMove, actionMoveDone, dec]]];
	
	
}



// controll speed

-(void) contSpd{
	
	
	if (score >= 0 && score < 200) {
		speed = 0.5;
	}else if (score >= 200 && score < 350) {
		speed = 1.0;
	}else if (score >= 350 && score < 450) {
		speed = 1.3;
		spawnSpd = 0.6;
	}else if (score >= 450 && score < 550) {
		speed = 1.6;
		spawnSpd = 0.4;
	}else if (score >= 550 && score < 650) {
		speed = 2.0;
		spawnSpd = 0.3;
	}else if (score >= 650 && score < 800) {
		speed = 2.5;
	}else if (score >= 800 && score < 1000) {
		speed = 3.0;
		spawnSpd = 0.2;
	}else if (score >= 1500) {
		speed = 4.0;
	}
	
	
}


//collide delegate 






- (void)didBeginContact:(SKPhysicsContact *)contact
{
    
    SKPhysicsBody *firstBody, *secondBody;
 
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // check if the bodies that got contacted are the ones we need 
    if ((firstBody.categoryBitMask & bulletCategory) != 0 &&
        (secondBody.categoryBitMask & enemyCategory) != 0)
    {
[self bullet:(SKSpriteNode *) firstBody.node hitEnemy:(SKSpriteNode *) secondBody.node];
        
    }
}

// Explotions 


- (void)newExplosionOnX:(CGFloat)x andY:(CGFloat)y {
    
    //instantiate explosion emitter
    SKEmitterNode *explosion = [[SKEmitterNode alloc] init];
    
    //[explosion setParticleTexture:[SKTexturetext:@"asteroid1"]];
	//CGFloat xx,yy;
	if (x == 0) {
		x = 500;
	}
	if (y == 0) {
		y = 500;
	}

explosion.position = CGPointMake(x, y);


[explosion setParticleTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"spark.png"]]];
    
[explosion setParticleColor:[UIColor colorWithRed:1.00 green:0.34 blue:0.11 alpha:1.00]];
    
[explosion setNumParticlesToEmit:50];
    
[explosion setParticleBirthRate:2000];
    
[explosion setParticleLifetime:0.4];
    
[explosion setEmissionAngleRange:360];
    
[explosion setParticleSpeed:100];
    
[explosion setParticleSpeedRange:60];
    
[explosion setXAcceleration:0];
    
[explosion setYAcceleration:0];
    
[explosion setParticleAlpha:0.8];
    
[explosion setParticleAlphaRange:0.2];
    
[explosion setParticleAlphaSpeed:-0.5];
    
[explosion setParticleScale:0.5];
    
[explosion setParticleScaleRange:0.1];
    
[explosion setParticleScaleSpeed:1];
    
[explosion setParticleRotation:0];
    
[explosion setParticleRotationRange:0];
    
[explosion setParticleRotationSpeed:0];
    
[explosion setParticleColorBlendFactor:1];
    
[explosion setParticleColorBlendFactorRange:0];
    
[explosion setParticleColorBlendFactorSpeed:0];
    
//[explosion setParticleBlendMode:SKBlendModeAdd];
    
    // actions to add , wait then remove 
    SKAction *addX = [SKAction runBlock:^{
    
    [self addChild:explosion];
    
    }];
    
    SKAction *wait = [SKAction waitForDuration:0.4];
    
    SKAction *fade = [SKAction fadeOutWithDuration:0.4];
    
    SKAction *fadeMe = [SKAction runBlock:^{
    [explosion runAction:fade];
    }];
    
    SKAction *del = [SKAction runBlock:^{
    [explosion removeFromParent];
    }];
    
    SKAction *spanSeq = [SKAction sequence:@[addX, fadeMe, wait, del]];
	
	if (self.audioState) {
		[self runAction:[SKAction playSoundFileNamed:ExpAudio waitForCompletion:false]];
	}
	[self runAction:spanSeq];
     
}

// end explotions
// ship fuel trail

- (void)addCo2 {
    
    //instantiate explosion emitter
    _fire = [[SKEmitterNode alloc] init];
    
    //[explosion setParticleTexture:[SKTexturetext:@"asteroid1"]];
    



[_fire setParticleTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"spark.png"]]];
    
[_fire setParticleColor:[SKColor colorWithRed:0.36 green:0.48 blue:1.00 alpha:1.00]];
    
//[_fire setNumParticlesToEmit:0];
    
[_fire setParticleBirthRate:120];

    
[_fire setParticleLifetime:0.2];

[_fire setEmissionAngle:dgrToRad(-90)];

[_fire setEmissionAngleRange:dgrToRad(30)];
    
[_fire setParticleSpeed:500];
    
[_fire setParticleSpeedRange:40];
    
[_fire setXAcceleration:0];
    
[_fire setYAcceleration:0];
    
[_fire setParticleAlpha:0.8];
    
[_fire setParticleAlphaRange:0.2];
    
[_fire setParticleAlphaSpeed:-0.1];
    
[_fire setParticleScale:0.3];
    
[_fire setParticleScaleRange:0.2];
    
[_fire setParticleScaleSpeed:0.5];
    
    
[_fire setParticleColorBlendFactor:1];
    
[_fire setParticleColorBlendFactorRange:0];
    
[_fire setParticleColorBlendFactorSpeed:0];
    
  
//_fire.targetNode = _player;

//_fire.position = CGPointMake(_player.position.x,_player.position.y - (_player.frame.size.height -5));

_fire.position = CGPointMake(_player.position.x,_player.position.y - 10);
    
    // actions to add , wait then remove 
   
    [self addChild:_fire];
     
}


@end
