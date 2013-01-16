//
//  Waypoint.h
//  WizardsVsZombies
//
//  Created by Pablo Ruiz on 23/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HelloWorldLayer.h"

@interface Waypoint : CCNode {
    
    HelloWorldLayer * theGame;
    Waypoint * nextWaypoint;
    CGPoint myPosition;
}

@property(nonatomic,readwrite)CGPoint myPosition;
@property(nonatomic,assign)Waypoint * nextWaypoint;

+(id) nodeWithTheGame:(HelloWorldLayer*)_game location:(CGPoint)location;
-(id) initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location;


@end
