//
//  FlockingSingleton.h
//  BasicCocos2D
//
//  Created by Ian Fan on 19/10/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FlockingSingleton : NSObject

@property (nonatomic,retain) NSMutableArray *visibilityArray;
@property float mainMaxSpeed;
@property float checkLength;

+(id)sharedInstance;

-(void)setStandard;

-(void)addNewMainWithPosition:(CGPoint)pos;

-(void)update;

-(void)addVisibilityToParent:(CCLayer*)parentLay;
-(void)removeVisibilityFromParent:(CCLayer*)parentLay;

@end
