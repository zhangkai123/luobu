//
//  Waypoint.m
//  WizardsVsZombies
//
//  Created by Pablo Ruiz on 23/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Waypoint.h"


@implementation Waypoint

@synthesize myPosition,nextWaypoint;

+(id) nodeWithTheGame:(HelloWorldLayer*)_game location:(CGPoint)location
{
    return [[[self alloc] initWithTheGame:_game location:location] autorelease];
}

-(id) initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location
{
	if( (self=[super init])) {
		
		theGame = _game;
        
        [self setPosition:CGPointZero];
        myPosition = location;
		
        [theGame addChild:self];
        
	}
	
	return self;
}

-(void)draw
{
    glColor4f(0, 255, 0, 255);
    ccDrawCircle(myPosition, 6, 360, 30, false);
    ccDrawCircle(myPosition, 2, 360, 30, false);
    
    if(nextWaypoint)
        ccDrawLine(myPosition, nextWaypoint.myPosition);
    
    [super draw];   
}

-(void)dealloc
{
    [super dealloc];
}

@end
