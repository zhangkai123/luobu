//
//  HelloWorldLayer.h
//  TowerDefenseStarter
//
//  Created by Pablo Ruiz on 27/06/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    NSMutableArray * towerBases;
    NSMutableArray * towers;
    NSMutableArray * waypoints;
    NSMutableArray * enemies;
    int wave;
    CCLabelBMFont * ui_wave_lbl;
    
    int playerHp;
    CCLabelBMFont * ui_hp_lbl;
    BOOL gameEnded;
    
    int playerGold;
    CCLabelBMFont * ui_gold_lbl;
    
    CCSprite * selSprite;
}

@property (nonatomic,retain)NSMutableArray * towers;
@property (nonatomic,retain)NSMutableArray * waypoints;
@property (nonatomic,retain)NSMutableArray * enemies;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(BOOL)loadWave;
-(void)enemyGotKilled;
-(void)addWaypoints;
-(void)loadTowerPositions;
-(BOOL)canBuyTower;
void ccFillPoly( CGPoint *poli, int points, BOOL closePolygon );
- (BOOL) circle:(CGPoint) circlePoint withRadius:(float) radius collisionWithCircle:(CGPoint) circlePointTwo collisionCircleRadius:(float) radiusTwo;
-(void)getHpDamage;
-(void)doGameOver;
-(void)awardGold:(int)gold;
@end
