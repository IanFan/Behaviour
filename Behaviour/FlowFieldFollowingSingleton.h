//
//  FlowFieldFollowingSingleton.h
//  BasicCocos2D
//
//  Created by Ian Fan on 19/10/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FlowFieldFollowingSingleton : NSObject

@property (nonatomic,retain) NSMutableArray *visibilityArray;
@property (nonatomic,retain) NSMutableArray *mainArray;

@property float mainMaxSpeed;
@property float checkLength;

+(id)sharedInstance;

-(void)setStandard;

-(void)addNewWithPosition:(CGPoint)pos;

-(void)update;

-(void)addVisibilityToParent:(CCLayer*)parentLay;
-(void)removeVisibilityFromParent:(CCLayer*)parentLay;


@end
