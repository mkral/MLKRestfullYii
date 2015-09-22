//
//  MLKRestfullYii.m
//
//  Created by Michael Kral on 12/3/13.
//  Copyright (c) 2015 Michael Kral. All rights reserved.
//

#import "MLKRestfullYii.h"

@implementation RYiiFilter

+(RYiiFilter *)filterProperty:(NSString *)propertyName withValue:(id)value operator:(RYiiOperator)operatorType{
    return [self filterProperty:propertyName withValue:value operator:operatorType error:nil];
}

+(RYiiFilter *)filterProperty:(NSString *)propertyName withValue:(id)value operator:(RYiiOperator)operatorType error:(NSError *__autoreleasing *)error
{
    RYiiFilter * filter = [[self alloc] init];
    
    filter.properyName = propertyName;
    
    filter.value = [RestfullYii formattedValueFromValue:value error:error];
    
    filter.operatorType = operatorType;
    
    return filter;
    
}

+(NSDictionary *)dictionaryFilterProperty:(NSString *)propertyName withValue:(id)value operator:(RYiiOperator)operatorType
{
    return [self dictionaryFilterProperty:propertyName withValue:value operator:operatorType error:nil];
}

+(NSDictionary *)dictionaryFilterProperty:(NSString *)propertyName withValue:(id)value operator:(RYiiOperator)operatorType error:(NSError *__autoreleasing *)error{
    
    RYiiFilter * filter = [self filterProperty:propertyName withValue:value operator:operatorType error:error];
    
    return [filter dictionary];
    
}

+(NSString *)jsonFilterProperty:(NSString *)propertyName withValue:(id)value operator:(RYiiOperator)operatorType error:(NSError *__autoreleasing *)error {
    
    RYiiFilter * filter = [self filterProperty:propertyName withValue:value operator:operatorType error:error];
    
    return [filter jsonString];
    
}

+(NSString *)jsonFilterProperty:(NSString *)propertyName withValue:(id)value operator:(RYiiOperator)operatorType {
    
    return [self jsonFilterProperty:propertyName withValue:value operator:operatorType error:nil];
    
}

-(NSDictionary *)dictionary{
    
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    
    if(self.properyName)
        [dictionary setObject:self.properyName forKey:@"property"];
    
    if(self.value)
        [dictionary setObject:self.value forKey:@"value"];
    
    if(self.operatorString)
        [dictionary setObject:self.operatorString forKey:@"operator"];
    
    
    return dictionary;
    
}

-(NSString *)jsonString {
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionary] options:0 error:nil];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

-(void)setOperatorType:(RYiiOperator)operatorType{
    
    _operatorString = [RestfullYii operatorStringFromRYiiOperator:operatorType];
    
    _operatorType = operatorType;
}



@end

@implementation RestfullYii


+(id)formattedValueFromValue:(id)value error:(NSError *__autoreleasing *)error{
    
    id formattedValue = nil;
    
    // Use NSNull if the filtered value is suppose to be null
    if(value == nil || [value isEqual:[NSNull null]]){
        
        formattedValue = [NSNull null];
        
    }
    
    // Check if is an array
    
    else if([value isKindOfClass:[NSArray class]]){
        
        //ensure that the array only contains strings or nsnumbers
        
        NSMutableArray * valueArray = [(NSMutableArray*)value mutableCopy];
        
        
        Class arrayValueClass = nil;
        
        for(id arrayValue in valueArray){
            
            if(!arrayValueClass) arrayValueClass = [arrayValue class];
            
            if (![arrayValue isKindOfClass:[NSString class]] &&
                ![arrayValue isKindOfClass:[NSNumber class]]) {
                
                *error = [NSError errorWithDomain:@"com.michaelkral.restfullyii" code:5420 userInfo:@{@"description":@"If the value is an array, it must only contain NSStrings or NSNumbers."}];
                
                break;
                
            }
            
            if (![arrayValue isKindOfClass:arrayValueClass]) {
                *error = [NSError errorWithDomain:@"com.michaelkral.restfullyii" code:5430 userInfo:@{@"description":@"The array must contain an exclusive class of strings or numbers, not both"}];
                
                break;
            }
            
        }
        
        if(!error){
            
            formattedValue = valueArray;
            
        }
        
    }
    
    // Check if it's a NSString
    
    else if([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]){
        
        //any string formatting if needed
        
        formattedValue = value;
        
    }else if([value isKindOfClass:[NSNumber class]]){
        
        
        *error = [NSError errorWithDomain:@"com.michaelkral.restfullyii" code:5440 userInfo:@{@"description":@"The value is not a null, array (with nsnumbers or nsstrings)"}];
        
    }
    
    
    if(error){
        return nil;
    }
    
    return formattedValue;
}

+(NSString *)operatorStringFromRYiiOperator:(RYiiOperator)ryOperator{
    
    NSString * operator = nil;
    
    switch (ryOperator) {
        case RYiiOperatorIn:
            operator = @"in";
            break;
        case RYiiOperatorNotIn:
            operator = @"not in";
            break;
        case RYiiOperatorEqual:
            operator = @"=";
            break;
        case RYiiOperatorNotEqual:
            operator = @"!=";
            break;
        case RYiiOperatorGreater:
            operator = @">";
            break;
        case RYiiOperatorGreaterOrEqual:
            operator = @">=";
            break;
        case RYiiOperatorLess:
            operator = @"<";
            break;
        case RYiiOperatorLessOrEqual:
            operator = @"<=";
            break;
            
        case RYiiOperatorLike:
        default:
            
            //no operator (nil) is "LIKE" for sql operator
            operator = @"";
            
            break;
    }
    
    return operator;
}

+(NSString *)jsonStringForFilters:(NSArray *)filters{
    
    NSMutableArray * dictionaryArray = [NSMutableArray array];
    
    for(RYiiFilter * filter in filters){
        
        [dictionaryArray addObject:[filter dictionary]];
        
    }
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryArray options:0 error:nil];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
