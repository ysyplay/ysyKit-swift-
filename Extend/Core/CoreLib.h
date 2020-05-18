//
//  CoreLib.h
//  CoreLib
//
//

#import <Foundation/Foundation.h>

@interface CoreLib : NSObject
//赋予命名空间
+(id)compatible:(id)key Secret:(NSString *)secret;
@end
