//
//  Enemy.m
//  WizardsVsZombies
//
//  Created by Pablo Ruiz on 17/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "Tower.h"
#import "Waypoint.h"
#import "SimpleAudioEngine.h"

#define HEALTH_BAR_WIDTH 20
#define HEALTH_BAR_ORIGIN -10

@implementation Enemy

@synthesize mySprite,theGame;

+(id) nodeWithTheGame:(HelloWorldLayer*)_game
{
    return [[[self alloc] initWithTheGame:_game] autorelease];
}

-(id) initWithTheGame:(HelloWorldLayer *)_game
{
	if( (self=[super init])) {
		
        attackedBy = [[NSMutableArray alloc] initWithCapacity:5];
		theGame = _game;
        maxHp = 40;
        currentHp = maxHp;
        
        active = NO;
        
        walkingSpeed = 0.5;
        
        mySprite = [CCSprite spriteWithFile:@"enemy.png"];
		[self addChild:mySprite];

        Waypoint * waypoint = (Waypoint *)[theGame.waypoints objectAtIndex:([theGame.waypoints count]-1)];
        
        destinationWaypoint = waypoint.nextWaypoint;
        
        CGPoint pos = waypoint.myPosition;
        myPosition = pos;
        
        [mySprite setPosition:pos];
		
        [theGame addChild:self];
        
        [self scheduleUpdate];
        
	}
	
	return self;
}

-(void)doActivate
{
    active = YES;
}

-(void)update:(ccTime)dt
{
    if(!active)return;
    
    if([theGame circle:myPosition withRadius:1 collisionWithCircle:destinationWaypoint.myPosition collisionCircleRadius:1])
    {
        if(destinationWaypoint.nextWaypoint)
        {
            destinationWaypoint = destinationWaypoint.nextWaypoint;
        }else
        {
            //Reached the end of the road. Damage the player
            [theGame getHpDamage];
            [self getRemoved];
        }
    }
    
    CGPoint targetPoint = destinationWaypoint.myPosition;
    float movementSpeed = walkingSpeed;
    
    CGPoint normalized = ccpNormalize(ccp(targetPoint.x-myPosition.x,targetPoint.y-myPosition.y));
    mySprite.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y,-normalized.x));
    
    myPosition = ccp(myPosition.x+normalized.x * movementSpeed,myPosition.y+normalized.y * movementSpeed);
    
   [mySprite setPosition:myPosition];
    
    
}

-(void)getAttacked:(Tower *)attacker
{
    [attackedBy addObject:attacker];
}

-(void)gotLostSight:(Tower *)attacker
{
    [attackedBy removeObject:attacker];
}

-(void)getDamaged:(int)damage
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"laser_shoot.wav"];
    currentHp -=damage;
    if(currentHp <=0)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"enemy_destroy_2.wav"];
        [theGame awardGold:200];
        [self getRemoved];
    }
}


-(void)getRemoved
{
    for(Tower * attacker in attackedBy)
    {
        [attacker targetKilled];
    }
    
    [self.parent removeChild:self cleanup:YES];
    [theGame.enemies removeObject:self];
    
    //Notify the game that we killed an enemy so we can check if we can send another wave
    [theGame enemyGotKilled];
}

-(void)draw
{
    glColor4f(255, 0, 0, 255);
    CGPoint healthBarBack[] = {ccp(mySprite.position.x -10,mySprite.position.y+16),ccp(mySprite.position.x+10,mySprite.position.y+16),ccp(mySprite.position.x+10,mySprite.position.y+14),ccp(mySprite.position.x-10,mySprite.position.y+14)};
    ccFillPoly(healthBarBack, 4, YES);
    
    glColor4f(0, 255, 0, 255);
    CGPoint healthBar[] = {ccp(mySprite.position.x + HEALTH_BAR_ORIGIN,mySprite.position.y+16),ccp(mySprite.position.x+HEALTH_BAR_ORIGIN+(float)(currentHp * HEALTH_BAR_WIDTH) / maxHp,mySprite.position.y+16),ccp(mySprite.position.x+HEALTH_BAR_ORIGIN+(float)(currentHp * HEALTH_BAR_WIDTH) / maxHp,mySprite.position.y+14),ccp(mySprite.position.x+HEALTH_BAR_ORIGIN,mySprite.position.y+14)};
    ccFillPoly(healthBar, 4, YES);
}



-(void)dealloc
{
	[super dealloc];
}


@end

