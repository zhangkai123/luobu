//
//  HomeLayer.m
//  TowerDefenseStarter
//
//  Created by zhang kai on 1/16/13.
//
//

#import "HomeLayer.h"

@implementation HomeLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HomeLayer *layer = [HomeLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        CCSpriteBatchNode *loadingBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"mainscene1"];
        [self addChild:loadingBatchNode z:2];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mainscene1.plist"];
        CCSprite *mainsene = [CCSprite spriteWithSpriteFrameName:@"mainbg.png"];
        mainsene.position = ccp(240, 160);
        [self addChild:mainsene];
	}
	return self;
}

@end
