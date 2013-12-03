MLKRestfullYii
==============

This is a helper class to easily create filters for the Yii extension restfullyii.


To use:

	// You can create NSDictionaries, JSON Strings, or RYiiFilter objects and convert them to dictionaries/json strings later.
	
	//Examples:
	//NSDictionary * genderFilter = [RYiiFilter dictionaryFilterProperty:@"gender" withValue:@"female"] operator:RYiiOperatorLike];
 	//NSString * ageFilter = [RYiiFilter jsonFilterProperty:@"age" withValue:@25 operator:RYiiOperatorGreaterOrEqual];
 	
 	RYiiFilter * roleFilter =  [RYiiFilter filterProperty:@"role" withValue:@[@"admin",@"manager"] operator:RYiiOperatorIn];
 	RYiiFilter * genderFilter = [RYiiFilter filterProperty:@"gender" withValue:@"female" operator:RYiiOperatorLike];
 	RYiiFilter * ageFilter = [RYiiFilter filterProperty:@"age" withValue:@25 operator:RYiiOperatorGreaterOrEqual];
 
 
 
 	//You can then create a nsdictionary with the json filters to use with your urlrequest (in this example I'm using RestKit "parameters")
 	NSDictionary * parameters = @{@"filter":[RestfullYii jsonStringForFilters:@[roleFilter, genderFilter, ageFilter]};
 
 
