//
//  BehaviorLayer.m
//  BasicCocos2D
//
//  Created by Ian Fan on 14/10/12.
//
//

#import "BehaviorLayer.h"

@implementation BehaviorLayer

@synthesize behaviorStatus;

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	BehaviorLayer *layer = [BehaviorLayer node];
	[scene addChild: layer];
  
	return scene;
}

#pragma mark - Update

-(void)update:(ccTime)delta {
  for (id idOj in updateArray) {
    if ([idOj isKindOfClass:[Wander class]] == YES) [(Wander*)idOj update];
    else if ([idOj isKindOfClass:[Seek class]] == YES) [(Seek*)idOj update];
    else if ([idOj isKindOfClass:[Flee class]] == YES) [(Flee*)idOj update];
    else if ([idOj isKindOfClass:[Pursuit class]] == YES) [(Pursuit*)idOj update];
    else if ([idOj isKindOfClass:[TargetSingleton class]] == YES) [(TargetSingleton*)idOj update];
    else if ([idOj isKindOfClass:[Evade class]] == YES) [(Evade*)idOj update];
    else if ([idOj isKindOfClass:[Arrival class]] == YES) [(Arrival*)idOj update];
    else if ([idOj isKindOfClass:[Waypoint class]] == YES) [(Waypoint*)idOj update];
    else if ([idOj isKindOfClass:[ObstacleAvoidanceSingleton class]] == YES) [(ObstacleAvoidanceSingleton*)idOj update];
    else if ([idOj isKindOfClass:[ObstacleMainSingleton class]] == YES) [(ObstacleMainSingleton*)idOj update];
    else if ([idOj isKindOfClass:[UnalignedCollisionAvoidanceSingleton class]] == YES) [(UnalignedCollisionAvoidanceSingleton*)idOj update];
    else if ([idOj isKindOfClass:[FlockingSingleton class]] == YES) [(FlockingSingleton*)idOj update];
    else if ([idOj isKindOfClass:[FlowFieldFollowingSingleton class]] == YES) [(FlowFieldFollowingSingleton*)idOj update];
  }
}

#pragma mark - TouchEvent

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  for(UITouch *touch in touches){
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector]convertToGL:point];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    switch (self.behaviorStatus) {
      case Behavior_Wander:{
        Wander *oj = [[Wander alloc]initWithMainPosition:point mainRoration:360*CCRANDOM_0_1() maxSpeed:0.5+3.5*CCRANDOM_0_1()  mainToCircleDistance:100.0 circleRaduis:50.0 circleDegreeNoise:5+15*CCRANDOM_0_1()];
        [oj addVisibilityToParent:self];
        [updateArray addObject:oj];
      }break;
        
      case Behavior_Seek:{
        Seek *oj = [[Seek alloc]initWithMainPosition:point mainRotation:360*CCRANDOM_0_1() maxSpeed:1.0+3.0*CCRANDOM_0_1() targetPosition:ccp(winSize.width/2, winSize.height/2)];
        [oj addVisibilityToParent:self];
        [updateArray addObject:oj];
      }break;
        
      case Behavior_Flee:{
        Flee *oj = [[Flee alloc]initWithMainPosition:point mainRotation:360*CCRANDOM_0_1() maxSpeed:1.0+3.0*CCRANDOM_0_1() targetPosition:ccp(winSize.width/2, winSize.height/2)];
        [oj addVisibilityToParent:self];
        [updateArray addObject:oj];
      }break;
        
      case Behavior_Pursuit:{
        Pursuit *oj = [[Pursuit alloc]initWithMainPosition:point mainRotation:360*CCRANDOM_0_1() mainMaxSpeed:2.0+3.0*CCRANDOM_0_1()];
        [oj addVisibilityToParent:self];
        [updateArray addObject:oj];
      }break;
        
      case Behavior_Evade:{
        Evade *oj = [[Evade alloc]initWithMainPosition:point mainRotation:360*CCRANDOM_0_1() mainMaxSpeed:1.0+3.0*CCRANDOM_0_1()];
        [oj addVisibilityToParent:self];
        [updateArray addObject:oj];
      }break;
        
      case Behavior_Arrival:{
        Arrival *oj = [[Arrival alloc]initWithMainPosition:point mainRotation:360*CCRANDOM_0_1() maxSpeed:1.0+3.0*CCRANDOM_0_1() targetPosition:ccp(winSize.width/2, winSize.height/2)];
        [oj addVisibilityToParent:self];
        [updateArray addObject:oj];
      }break;
        
      case Behavior_Waypoint:{
        WaypointSingleton *singleton = [WaypointSingleton sharedInstance];
        [singleton addNewWayPoint:point];
        [singleton addVisibilityToParent:self];
      }break;
        
      case Behavior_ObstacleAvoidance:{
        ObstacleMainSingleton *omSingleton = [ObstacleMainSingleton sharedInstance];
        omSingleton.targetSprite.position = point;
      }break;
        
      case Behavior_UnalignedCollisionAvoidance:{
        UnalignedCollisionAvoidanceSingleton *singleton = [UnalignedCollisionAvoidanceSingleton sharedInstance];
        [singleton addNewMainWithPosition:point];
        [singleton addVisibilityToParent:self];
      }break;
        
      case Behavior_Flocking:{
        FlockingSingleton *singleton = [FlockingSingleton sharedInstance];
        [singleton addNewMainWithPosition:point];
        [singleton addVisibilityToParent:self];
      }break;
        
      case Behavior_FlowFieldFollowing:{
        FlowFieldFollowingSingleton *singleton = [FlowFieldFollowingSingleton sharedInstance];
        [singleton addNewWithPosition:point];
        [singleton addVisibilityToParent:self];
      }break;
        
      default:
        break;
    }
    
  }
}

#pragma mark - Behavior

-(void)Wander {
  [self removeAllUpdateArray];
  self.behaviorStatus = Behavior_Wander;
  
  Wander *oj = [[Wander alloc]initStandardWithMainPosition:ccp(100, [CCDirector sharedDirector].winSize.height/2)];
  [oj addVisibilityToParent:self];
  [updateArray addObject:oj];
}

-(void)Seek {
  [self removeAllUpdateArray];
  self.behaviorStatus = Behavior_Seek;
  
  Seek *oj = [[Seek alloc]initStandardWithMainPosition:ccp(100, [CCDirector sharedDirector].winSize.height/2)];
  [oj addVisibilityToParent:self];
  [updateArray addObject:oj];
}

-(void)Flee {
  [self removeAllUpdateArray];
  self.behaviorStatus = Behavior_Flee;
  
  Flee *oj = [[Flee alloc]initStandardWithMainPosition:ccp(100, [CCDirector sharedDirector].winSize.height/2)];
  [oj addVisibilityToParent:self];
  [updateArray addObject:oj];
}

-(void)Pursuit {
  [self removeAllUpdateArray];
  self.behaviorStatus = Behavior_Pursuit;
  
  Pursuit *oj = [[Pursuit alloc]initStandardWithMainPosition:ccp(100, [CCDirector sharedDirector].winSize.height/2)];
  [oj addVisibilityToParent:self];
  [updateArray addObject:oj];
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  TargetSingleton *singleton = [TargetSingleton sharedInstance];
  [singleton setStandardWithTargetPosition:ccp(winSize.width/2, winSize.height/2)];
  [singleton addVisibilityToParent:self];
  if ([updateArray containsObject:singleton] == NO) [updateArray addObject:singleton];
}

-(void)Evade {
  [self removeAllUpdateArray];
  self.behaviorStatus = Behavior_Evade;
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  Evade *oj = [[Evade alloc]initStandardWithMainPosition:ccp(100, winSize.height/2)];
  [oj addVisibilityToParent:self];
  [updateArray addObject:oj];
  
  TargetSingleton *singleton = [TargetSingleton sharedInstance];
  [singleton setStandardWithTargetPosition:ccp(winSize.width/2, winSize.height/2)];
  [singleton addVisibilityToParent:self];
  if ([updateArray containsObject:singleton] == NO) [updateArray addObject:singleton];
}

-(void)Arrival {
  [self removeAllUpdateArray];
  self.behaviorStatus = Behavior_Arrival;
  
  Arrival *oj = [[Arrival alloc]initStandardWithMainPosition:ccp(100, [CCDirector sharedDirector].winSize.height/2)];
  [oj addVisibilityToParent:self];
  [updateArray addObject:oj];
}

-(void)Waypoint {
  [self removeAllUpdateArray];
  self.behaviorStatus = Behavior_Waypoint;
  
  CCDelayTime *delay = [CCDelayTime actionWithDuration:1.0];
  CCCallFunc *callFunc = [CCCallFunc actionWithTarget:self selector:@selector(createWaypointMain)];
  CCSequence *sequence = [CCSequence actions:callFunc,delay, nil];
  [self runAction:[CCRepeat actionWithAction:sequence times:20]];
  
  WaypointSingleton *singleton = [WaypointSingleton sharedInstance];
  [singleton setStandardWaypoint];
  [singleton addVisibilityToParent:self];
  if ([updateArray containsObject:singleton] == NO) [updateArray addObject:singleton];
}

-(void)createWaypointMain {
  if (self.behaviorStatus != Behavior_Waypoint) return;
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  Waypoint *oj = [[Waypoint alloc]initStandardWithMainPosition:ccp(100,winSize.height/2)];
  [oj addVisibilityToParent:self];
  [updateArray addObject:oj];
}

-(void)ObstacleAvoidance {
  [self removeAllUpdateArray];
  self.behaviorStatus = Behavior_ObstacleAvoidance;
  
  ObstacleAvoidanceSingleton *oaSingleton = [ObstacleAvoidanceSingleton sharedInstance];
  [oaSingleton setStandard];
  [oaSingleton addVisibilityToParent:self];
  if ([updateArray containsObject:oaSingleton] == NO) [updateArray addObject:oaSingleton];
  
  ObstacleMainSingleton *omSingleton = [ObstacleMainSingleton sharedInstance];
  [omSingleton setStandard];
  [omSingleton addVisibilityToParent:self];
  if ([updateArray containsObject:omSingleton] == NO) [updateArray addObject:omSingleton];
}

-(void) UnalignedCollisionAvoidance {
  [self removeAllUpdateArray];
  self.behaviorStatus = Behavior_UnalignedCollisionAvoidance;
  
  UnalignedCollisionAvoidanceSingleton *singleton = [UnalignedCollisionAvoidanceSingleton sharedInstance];
  [singleton setStandard];
  [singleton addVisibilityToParent:self];
  if ([updateArray containsObject:singleton] == NO) [updateArray addObject:singleton];
}

-(void)Flocking {
  [self removeAllUpdateArray];
  self.behaviorStatus = Behavior_Flocking;
  
  FlockingSingleton *singleton = [FlockingSingleton sharedInstance];
  [singleton setStandard];
  [singleton addVisibilityToParent:self];
  if ([updateArray containsObject:singleton] == NO) [updateArray addObject:singleton];
}

-(void)FlowFieldFollowing {
  [self removeAllUpdateArray];
  self.behaviorStatus = Behavior_FlowFieldFollowing;
  
  FlowFieldFollowingSingleton *singleton = [FlowFieldFollowingSingleton sharedInstance];
  [singleton setStandard];
  [singleton addVisibilityToParent:self];
  if ([updateArray containsObject:singleton] == NO) [updateArray addObject:singleton];
}

-(void)removeAllUpdateArray {
  [self stopAllActions];
  
  for (id idOj in updateArray) {
    if ([idOj isKindOfClass:[Wander class]] == YES) {
      [(Wander*)idOj removeVisibilityFromParent:self];
      [idOj release];
    }
    else if ([idOj isKindOfClass:[Seek class]] == YES) {
      [(Seek*)idOj removeVisibilityFromParent:self];
      [idOj release];
    }
    else if ([idOj isKindOfClass:[Flee class]] == YES) {
      [(Flee*)idOj removeVisibilityFromParent:self];
      [idOj release];
    }
    else if ([idOj isKindOfClass:[Pursuit class]] == YES) {
      [(Pursuit*)idOj removeVisibilityFromParent:self];
      [idOj release];
    }
    else if ([idOj isKindOfClass:[Evade class]] == YES) {
      [(Evade*)idOj removeVisibilityFromParent:self];
    }
    else if ([idOj isKindOfClass:[TargetSingleton class]] == YES) {
      [(TargetSingleton*)idOj removeVisibilityFromParent:self];
    }
    else if ([idOj isKindOfClass:[Arrival class]] == YES) {
      [(Arrival*)idOj removeVisibilityFromParent:self];
      [idOj release];
    }
    else if ([idOj isKindOfClass:[WaypointSingleton class]] == YES) {
      [(WaypointSingleton*)idOj removeVisibilityFromParent:self];
    }
    else if ([idOj isKindOfClass:[Waypoint class]] == YES) {
      [(Waypoint*)idOj removeVisibilityFromParent:self];
    }
    else if ([idOj isKindOfClass:[ObstacleAvoidanceSingleton class]] == YES) {
      [(ObstacleAvoidanceSingleton*)idOj removeVisibilityFromParent:self];
    }
    else if ([idOj isKindOfClass:[ObstacleMainSingleton class]] == YES) {
      [(ObstacleMainSingleton*)idOj removeVisibilityFromParent:self];
    }
    else if ([idOj isKindOfClass:[UnalignedCollisionAvoidanceSingleton class]] == YES) {
      [(UnalignedCollisionAvoidanceSingleton*)idOj removeVisibilityFromParent:self];
    }
    else if ([idOj isKindOfClass:[FlockingSingleton class]] == YES) {
      [(FlockingSingleton*)idOj removeVisibilityFromParent:self];
    }
    else if ([idOj isKindOfClass:[FlowFieldFollowingSingleton class]] == YES) {
      [(FlowFieldFollowingSingleton*)idOj removeVisibilityFromParent:self];
    }
  }
  
  [updateArray removeAllObjects];
}

#pragma mark - Menu

-(void)setMenu {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  int fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 24:16;
  CGPoint position = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? CGPointMake(180, winSize.height/2-150):ccp(140, winSize.height/2);
  
  CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"Wander" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(Wander)];
  
  CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Seek" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(Seek)];
  
  CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"Flee" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel3 = [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(Flee)];
  
  CCLabelTTF *label4 = [CCLabelTTF labelWithString:@"Pursuit" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel4 = [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(Pursuit)];
  
  CCLabelTTF *label5 = [CCLabelTTF labelWithString:@"Evade" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel5 = [CCMenuItemLabel itemWithLabel:label5 target:self selector:@selector(Evade)];
  
  CCLabelTTF *label6 = [CCLabelTTF labelWithString:@"Arrival" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel6 = [CCMenuItemLabel itemWithLabel:label6 target:self selector:@selector(Arrival)];
  
  CCLabelTTF *label7 = [CCLabelTTF labelWithString:@"Waypoint" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel7 = [CCMenuItemLabel itemWithLabel:label7 target:self selector:@selector(Waypoint)];
  
  CCLabelTTF *label8 = [CCLabelTTF labelWithString:@"ObstacleAvoidance" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel8 = [CCMenuItemLabel itemWithLabel:label8 target:self selector:@selector(ObstacleAvoidance)];
  
  CCLabelTTF *label9 = [CCLabelTTF labelWithString:@"UnalignedCollisionAvoidance" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel9 = [CCMenuItemLabel itemWithLabel:label9 target:self selector:@selector(UnalignedCollisionAvoidance)];
  
  CCLabelTTF *label10 = [CCLabelTTF labelWithString:@"Flocking" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel10 = [CCMenuItemLabel itemWithLabel:label10 target:self selector:@selector(Flocking)];
  
  CCLabelTTF *label11 = [CCLabelTTF labelWithString:@"FlowFieldFollowing" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel11 = [CCMenuItemLabel itemWithLabel:label11 target:self selector:@selector(FlowFieldFollowing)];
  
  CCMenu *menu = [CCMenu menuWithItems:menuItemLabel1,menuItemLabel2,menuItemLabel3,menuItemLabel4,menuItemLabel5,menuItemLabel6,menuItemLabel7,menuItemLabel8,menuItemLabel9,menuItemLabel10,menuItemLabel11, nil];
  [menu alignItemsVertically];
  [menu setPosition:position];
  [self addChild:menu];
}

#pragma mark - Init

-(id) init {
	if((self = [super init])) {
    [self setMenu];
    updateArray = [[NSMutableArray alloc]init];
    [self Wander];
    
    [self schedule:@selector(update:)];
    
    self.touchEnabled = YES;
    [CCDirector sharedDirector].view.multipleTouchEnabled = YES;
	}
  
	return self;
}

- (void) dealloc {
  [self removeAllUpdateArray];
  [updateArray release];
  
	[super dealloc];
}

@end
