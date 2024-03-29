//
//  Hero.m
//  WizardsVsZombies
//
//  Created by Pablo Ruiz on 21/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Tower.h"

@implementation Tower

@synthesize mySprite,theGame;

+(id) nodeWithTheGame:(HelloWorldLayer*)_game location:(CGPoint)location
{
    return [[[self alloc] initWithTheGame:_game location:location] autorelease];
}

-(id) initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location
{
	if( (self=[super init])) {
		
		theGame = _game;
        attackRange = 70;
        damage = 10;
        fireRate = 1;
        
        mySprite = [CCSprite spriteWithSpriteFrameName:@"Shit21.png"];
		[self addChild:mySprite];
        
        [mySprite setPosition:location];
    
        [theGame addChild:self];
        
        [self scheduleUpdate];
	}
	
	return self;
}

-(void)update:(ccTime)dt
{
    if(chosenEnemy){
        
        //We make it turn to target the enemy chosen
        CGPoint normalized = ccpNormalize(ccp(chosenEnemy.mySprite.position.x-mySprite.position.x,chosenEnemy.mySprite.position.y-mySprite.position.y));
        mySprite.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y,-normalized.x))+90;
        
        if(![theGame circle:mySprite.position withRadius:attackRange collisionWithCircle:chosenEnemy.mySprite.position collisionCircleRadius:1])
        {
            [self lostSightOfEnemy];
        }
    }else
    {
        for(Enemy * enemy in theGame.enemies)
        {
            if([theGame circle:mySprite.position withRadius:attackRange collisionWithCircle:enemy.mySprite.position collisionCircleRadius:1])
            {
                [self chosenEnemyForAttack:enemy];
                break;
            }
        }
    }
}


-(void)chosenEnemyForAttack:(Enemy *)enemy
{
    chosenEnemy = nil;
    chosenEnemy = enemy;
    [self attackEnemy];
    [enemy getAttacked:self];
}

-(void)attackEnemy
{
    [self schedule:@selector(shootWeapon) interval:fireRate];
}

-(void)shootWeapon
{
    CCSprite * bullet = [CCSprite spriteWithFile:@"bullet.png"];
    [theGame addChild:bullet];
    [bullet setPosition:mySprite.position];
    [bullet runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:chosenEnemy.mySprite.position],[CCCallFunc actionWithTarget:self selector:@selector(damageEnemy)],[CCCallFuncN actionWithTarget:self selector:@selector(removeBullet:)], nil]];
    
    
}

-(void)removeBullet:(CCSprite *)bullet
{
    [bullet.parent removeChild:bullet cleanup:YES];
}

-(void)damageEnemy
{
    [chosenEnemy getDamaged:damage];
}

-(void)targetKilled
{
    if(chosenEnemy)
        chosenEnemy =nil;
    
    [self unschedule:@selector(shootWeapon)];
}

-(void)lostSightOfEnemy
{
    [chosenEnemy gotLostSight:self];
    if(chosenEnemy)
        chosenEnemy =nil; 
    
    [self unschedule:@selector(shootWeapon)];
}


-(void)draw
{
    glColor4f(255, 255, 255, 255);
    ccDrawCircle(mySprite.position, attackRange, 360, 30, false);
    [super draw];
}

-(void)dealloc
{
	[super dealloc];
}


@end
