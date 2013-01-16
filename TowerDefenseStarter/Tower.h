//
//  Hero.h
//  WizardsVsZombies
//
//  Created by Pablo Ruiz on 21/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "Enemy.h"

#define kTOWER_COST 300

@class HelloWorldLayer,Enemy;

@interface Tower : CCNode {
    
    HelloWorldLayer * theGame;
    CCSprite * mySprite;
    
    int attackRange;
    int damage;
    float fireRate;
    BOOL attacking;
    Enemy * chosenEnemy;
}

@property (nonatomic,assign)HelloWorldLayer * theGame;
@property (nonatomic,assign)CCSprite * mySprite;


+(id) nodeWithTheGame:(HelloWorldLayer*)_game location:(CGPoint)location;
-(id) initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location;

-(void)chosenEnemyForAttack:(Enemy *)enemy;
-(void)attackEnemy;
-(void)shootWeapon;
-(void)targetKilled;
-(void)lostSightOfEnemy;

@end