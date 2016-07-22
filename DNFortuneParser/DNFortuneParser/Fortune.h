//
//  Fortune.h
//  DNFortuneParser
//
//  Created by David Nedrow on 7/14/16.
//  Copyright © 2016 David Nedrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fortune : NSObject

@property (strong, nonatomic) NSArray *text;
@property (strong, nonatomic) NSString *attribution;

-(id)initWithArray:(NSArray *)textArray andString:(NSString *)attribution;

@end
