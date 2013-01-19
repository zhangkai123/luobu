//
//  HelloWorldLayer.m
//  TowerDefenseStarter
//
//  Created by Pablo Ruiz on 27/06/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Waypoint.h"
#import "Tower.h"
#import "SimpleAudioEngine.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize towers,waypoints,enemies;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init])) {
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"8bitDungeonLevel.mp3" loop:YES];
        
		self.isTouchEnabled = YES;
        CGSize wins = [CCDirector sharedDirector].winSize;
        
        CCSprite * background = [CCSprite spriteWithFile:@"Bg.png"];
        [self addChild:background];
        [background setPosition:ccp(wins.width/2,wins.height/2)];
        
        [self loadTowerPositions];
        [self addWaypoints];
        
        enemies = [[NSMutableArray alloc] init];
        
        [self loadWave];
        
        ui_wave_lbl = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"WAVE: %d",wave] fntFile:@"font_red_14.fnt"];
        [self addChild:ui_wave_lbl z:10];
        [ui_wave_lbl setPosition:ccp(400,wins.height-12)];
        [ui_wave_lbl setAnchorPoint:ccp(0,0.5)];
        
        playerHp = 5;
        
        ui_hp_lbl = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"HP: %d",playerHp] fntFile:@"font_red_14.fnt"];
        [self addChild:ui_hp_lbl z:10];
        [ui_hp_lbl setPosition:ccp(35,wins.height-12)];
        
        playerGold = 1000;
        
        ui_gold_lbl = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"GOLD: %d",playerGold] fntFile:@"font_red_14.fnt"];
        [self addChild:ui_gold_lbl z:10];
        [ui_gold_lbl setPosition:ccp(135,wins.height-12)];
        [ui_gold_lbl setAnchorPoint:ccp(0,0.5)];
        
        towers = [[NSMutableArray alloc]init];
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}

-(BOOL)loadWave
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Waves" ofType:@"plist"];
    NSArray * waveData = [NSArray arrayWithContentsOfFile:plistPath];
    
    if(wave >= [waveData count])
    {
        return NO;
    }
    
    NSArray * currentWaveData =[NSArray arrayWithArray:[waveData objectAtIndex:wave]];
    
    for(NSDictionary * enemyData in currentWaveData)
    {
        Enemy * enemy = [Enemy nodeWithTheGame:self];
        [enemies addObject:enemy];
        [enemy schedule:@selector(doActivate) interval:[[enemyData objectForKey:@"spawnTime"]floatValue]];
    }
    
    wave++;
    [ui_wave_lbl setString:[NSString stringWithFormat:@"WAVE: %d",wave]];
    
    return YES;
    
}

-(void)enemyGotKilled
{
    if([enemies count]<=0) //If there are no more enemies.
    {
        if(![self loadWave])
        {
            NSLog(@"You win!");
            [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitCols transitionWithDuration:1 scene:[HelloWorldLayer scene]]];
        }
    }
}

-(void)addWaypoints
{
    waypoints = [[NSMutableArray alloc] init];
    
    Waypoint * waypoint1 = [Waypoint nodeWithTheGame:self location:ccp(420,35)];
    [waypoints addObject:waypoint1];
    
    Waypoint * waypoint2 = [Waypoint nodeWithTheGame:self location:ccp(35,35)];
    [waypoints addObject:waypoint2];
    waypoint2.nextWaypoint =waypoint1;
    
    Waypoint * waypoint3 = [Waypoint nodeWithTheGame:self location:ccp(35,130)];
    [waypoints addObject:waypoint3];
    waypoint3.nextWaypoint =waypoint2;
    
    Waypoint * waypoint4 = [Waypoint nodeWithTheGame:self location:ccp(445,130)];
    [waypoints addObject:waypoint4];
    waypoint4.nextWaypoint =waypoint3;
    
    Waypoint * waypoint5 = [Waypoint nodeWithTheGame:self location:ccp(445,220)];
    [waypoints addObject:waypoint5];
     waypoint5.nextWaypoint =waypoint4;
    
    Waypoint * waypoint6 = [Waypoint nodeWithTheGame:self location:ccp(-40,220)];
    [waypoints addObject:waypoint6];
     waypoint6.nextWaypoint =waypoint5;
    
}

-(void)loadTowerPositions
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"TowersPosition" ofType:@"plist"];
    NSArray * towerPositions = [NSArray arrayWithContentsOfFile:plistPath];
    towerBases = [[NSMutableArray alloc] initWithCapacity:10];
    
    for(NSDictionary * towerPos in towerPositions)
    {
        CCSprite * towerBase = [CCSprite spriteWithFile:@"open_spot.png"];
        [self addChild:towerBase];
        [towerBase setPosition:ccp([[towerPos objectForKey:@"x"] intValue],[[towerPos objectForKey:@"y"] intValue])];
        [towerBases addObject:towerBase];
    }
    
}

- (BOOL)selectSpriteForTouch:(CGPoint)touchLocation {
    Tower * newTower = nil;
    for (Tower *tower in towers) {
        if (CGRectContainsPoint(tower.mySprite.boundingBox, touchLocation)) {
            newTower = tower;
            break;
        }
    }
    if (newTower == nil) {
        return NO;
    }
    if (newTower != selTower) {
        selTower = newTower;
        oldPosition = newTower.mySprite.position;
    }
    return YES;
}
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView: [touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL: location];

    if ([self selectSpriteForTouch:location]) {
        return YES;
    }

    for(CCSprite * tb in towerBases)
    {
        if([self canBuyTower] && CGRectContainsPoint([tb boundingBox],location) && !tb.userData)
        {
            //We will spend our gold later.
            playerGold -= kTOWER_COST;
            [ui_gold_lbl setString:[NSString stringWithFormat:@"GOLD: %d",playerGold]];
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"tower_place.wav"];
            
            Tower * tower = [Tower nodeWithTheGame:self location:tb.position];
            [towers addObject:tower];
            tb.userData = tower;
        }
    }
    return NO;
}
- (void)panForTranslation:(CGPoint)translation {
    if (selTower) {
        CGPoint newPos = ccpAdd(selTower.mySprite.position, translation);
        selTower.mySprite.position = newPos;
    }
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL movable = NO;
    CGPoint towerPositon;

    CCSprite *oldTb;
    for(CCSprite * tb in towerBases)
    {
        if (tb.userData == selTower) {
            oldTb = tb;
        }
    }
    for(CCSprite * tb in towerBases)
    {
        if(CGRectIntersectsRect([tb boundingBox], [selTower.mySprite boundingBox]) && !tb.userData)
        {
            towerPositon = tb.position;
            tb.userData = selTower;
            movable = YES;
            break;
        }
    }
    if (!movable) {
        
        selTower.mySprite.position = oldPosition;
    }else{
        
        oldTb.userData = nil;
        selTower.mySprite.position = towerPositon;
    }
}

-(BOOL)canBuyTower
{
    if(playerGold - kTOWER_COST >=0)
        return YES;
    
    return NO;
}

void ccFillPoly( CGPoint *poli, int points, BOOL closePolygon )
{
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    glVertexPointer(2, GL_FLOAT, 0, poli);
    if( closePolygon )
        glDrawArrays(GL_TRIANGLE_FAN, 0, points);
    else
        glDrawArrays(GL_LINE_STRIP, 0, points);
    
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
}

- (BOOL) circle:(CGPoint) circlePoint withRadius:(float) radius collisionWithCircle:(CGPoint) circlePointTwo collisionCircleRadius:(float) radiusTwo
{
    float xdif = circlePoint.x - circlePointTwo.x;
    float ydif = circlePoint.y - circlePointTwo.y;
    
    float distance = sqrt(xdif*xdif+ydif*ydif);
    
    if(distance <= radius+radiusTwo) 
        return YES;
    
    return NO;
}

-(void)getHpDamage
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"life_lose.wav"];
    playerHp--;
    [ui_hp_lbl setString:[NSString stringWithFormat:@"HP: %d",playerHp]];
    
    if(playerHp <=0)
    {
        [self doGameOver];
    }
}

-(void)doGameOver
{
    if(!gameEnded)
    {
        gameEnded = YES;
        [[CCDirector sharedDirector] replaceScene:[CCTransitionRotoZoom transitionWithDuration:1 scene:[HelloWorldLayer scene]]];
    }
}

-(void)awardGold:(int)gold
{
    playerGold += gold;
    [ui_gold_lbl setString:[NSString stringWithFormat:@"GOLD: %d",playerGold]];
    
}

- (void) dealloc
{
    [enemies release];
    [towers release];
    [towerBases release];
    [waypoints release];
	[super dealloc];
}
@end
