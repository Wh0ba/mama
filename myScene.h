//myScene.h 
//copyright Wh0ba LLC 

#import "defs.h"


#import <SpriteKit/SpriteKit.h>
@interface myScene : SKScene <SKPhysicsContactDelegate>
	-(instancetype)initWithSize:(CGSize)size;
	
	@property (nonatomic) NSString *confPath;
	
	
	@property (nonatomic, strong) NSDictionary* lvlPlist;
	
	@property (nonatomic, strong) NSDictionary* lvl1;
	
	
	
	@property (nonatomic, strong) UIImage *spark;
	
	@property (nonatomic) SKEmitterNode *fire;
	
	@property (nonatomic) SKSpriteNode *player;
	
	@property (nonatomic, strong) SKLabelNode *scoreLabel;
	
	@property (nonatomic) NSTimeInterval lastSpawnTime;
	
	@property (nonatomic) NSTimeInterval lastUpdateTime;
	
		@property (nonatomic) NSTimeInterval lastEnemySpawn;
	
	@property (nonatomic) NSTimeInterval lastEnemyUpdateTime;
	
	@property (nonatomic, assign) BOOL shootable;
	
	
	@property (nonatomic, assign) BOOL audioState;
	
@end

