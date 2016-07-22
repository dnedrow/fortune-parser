//
//  Fortune.m
//  DNFortuneParser
//
//  Created by David Nedrow on 7/14/16.
//  Copyright © 2016 David Nedrow. All rights reserved.
//

#import "Fortune.h"

@interface Fortune ()
@end

@implementation Fortune

-(id)initWithArray:(NSArray *)textArray andString:(NSString *)attribution {
    self = [super init];
    if(self) {
        _text = [textArray copy];
        _attribution = [attribution copy];
    }
    return self;
}

@end
