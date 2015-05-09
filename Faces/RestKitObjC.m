#import "RestKitObjC.h"
#import <RestKit.h>

@implementation RestKitObjC
+ (void)initLogging {
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
}

+ (void)setupTransformers {
    
    RKValueTransformer *nullToString = [RKBlockValueTransformer valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class sourceClass, __unsafe_unretained Class destinationClass) {
        return ([sourceClass isSubclassOfClass:[NSNull class]] && [destinationClass isSubclassOfClass:[NSString class]]);
    } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue, Class outputValueClass, NSError *__autoreleasing *error) {
        // Validate the input and output
        RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSNull class], error);
        RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputValueClass, [NSString class], error);
        
        // Perform the transformation
        *outputValue = @"";
        return YES;
    }];
    
    
    [[RKValueTransformer defaultValueTransformer] insertValueTransformer:nullToString atIndex:0];
}
@end
