//
//  MLKRestfullYii.h
//
//  Created by Michael Kral on 12/3/13.
//  Copyright (c) 2013 Michael Kral. All rights reserved.
//

typedef enum {
    
    RYiiOperatorLike = 0,
    RYiiOperatorIn,
    RYiiOperatorNotIn,
    RYiiOperatorEqual,
    RYiiOperatorNotEqual,
    RYiiOperatorGreater,
    RYiiOperatorGreaterOrEqual,
    RYiiOperatorLess,
    RYiiOperatorLessOrEqual
    
}RYiiOperator;

#import <Foundation/Foundation.h>

@interface RYiiFilter: NSObject

@property (nonatomic, strong) NSString * properyName;
@property (nonatomic, strong) id value;
@property (nonatomic, assign) RYiiOperator operatorType;
@property (nonatomic, strong, readonly) NSString * operatorString;

+(RYiiFilter *)filterProperty:(NSString *)propertyName withValue:(id)value operator:(RYiiOperator)operatorType error:(NSError **)error;

+(RYiiFilter *)filterProperty:(NSString *)propertyName withValue:(id)value operator:(RYiiOperator)operatorType;

+(NSDictionary *)dictionaryFilterProperty:(NSString *)propertyName withValue:(id)value operator:(RYiiOperator)operatorType;

+(NSDictionary *)dictionaryFilterProperty:(NSString *)propertyName withValue:(id)value operator:(RYiiOperator)operatorType error:(NSError **)error;

+(NSString *)jsonFilterProperty:(NSString *)propertyName withValue:(id)value operator:(RYiiOperator)operatorType error:(NSError **)error;

+(NSString *)jsonFilterProperty:(NSString *)propertyName withValue:(id)value operator:(RYiiOperator)operatorType;



-(NSString *)jsonString;

-(NSDictionary *)dictionary;

@end

@interface RestfullYii : NSObject

+(id)formattedValueFromValue:(id)value error:(NSError **)error;

+(NSString *)operatorStringFromRYiiOperator:(RYiiOperator)operatorType;

+(NSString *)jsonStringForFilters:(NSArray *)filters;


@end
