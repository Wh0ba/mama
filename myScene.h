//myScene.h 
//copyright Wh0ba LLC 

#import "defs.h"


#import <SpriteKit/SpriteKit.h>
@interface myScene : SKScene <SKPhysicsContactDelegate>
	-(instancetype)initWithSize:(CGSize)size;
	
	@property (nonatomic) NSTimeInterval lastSpawnTime;
	
	@property (nonatomic) NSTimeInterval lastUpdateTime;
	
		@property (nonatomic) NSTimeInterval lastEnemySpawn;
	
	@property (nonatomic) NSTimeInterval lastEnemyUpdateTime;
	
	@property (nonatomic, assign) BOOL shootable;
	
	
	@property (nonatomic, assign) BOOL audioState;
	
@end

