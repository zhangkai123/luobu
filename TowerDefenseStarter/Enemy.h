//
//  Enemy.h
//  WizardsVsZombies
//
//  Created by Pablo Ruiz on 17/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "GameConfig.h"

@class HelloWorldLayer,Waypoint,Tower;

@interface Enemy : CCNode {
    
    HelloWorldLayer * theGame;
    CCSprite * mySprite;
    CGPoint myPosition;
    int maxHp;
    int currentHp;
    float walkingSpeed;
    Waypoint * destinationWaypoint;
    BOOL active;
    
    NSMutableArray * attackedBy;
}

@property (nonatomic,assign)HelloWorldLayer * theGame;
@property (nonatomic,assign)CCSprite * mySprite;


+(id) nodeWithTheGame:(HelloWorldLayer*)_game;
-(id) initWithTheGame:(HelloWorldLayer *)_game;
-(void)doActivate;
-(void)getAttacked:(Tower *)attacker;
-(void)gotLostSight:(Tower *)attacker;
-(void)getDamaged:(int)damage;
-(void)getRemoved;


@end
