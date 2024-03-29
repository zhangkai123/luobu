//
//  BottleTower.m
//  TowerDefenseStarter
//
//  Created by zhang kai on 1/20/13.
//
//

#import "BottleTower.h"

@implementation BottleTower

-(id) initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location
{
	if( (self=[super init])) {
		
		theGame = _game;
        attackRange = 70;
        damage = 10;
        fireRate = 1;
        
        mySprite = [CCSprite spriteWithFile:@"Bottle11.png"];
		[self addChild:mySprite];
        
        [mySprite setPosition:location];
        
        [theGame addChild:self];
        
        [self scheduleUpdate];
	}
	
	return self;
}

@end
