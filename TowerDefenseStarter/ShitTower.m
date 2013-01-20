//
//  ShitTower.m
//  TowerDefenseStarter
//
//  Created by zhang kai on 1/20/13.
//
//

#import "ShitTower.h"

@implementation ShitTower

-(id) initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location
{
	if( (self=[super init])) {
		
		theGame = _game;
        attackRange = 70;
        damage = 10;
        fireRate = 1;
        
        mySprite = [CCSprite spriteWithFile:@"tower.png"];
		[self addChild:mySprite];
        
        [mySprite setPosition:location];
        
        [theGame addChild:self];
        
        [self scheduleUpdate];
	}
	
	return self;
}

@end
