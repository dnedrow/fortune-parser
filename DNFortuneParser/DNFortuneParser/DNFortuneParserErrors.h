//
//  DNFortuneParserErrors.h
//  DNFortuneParser
//
//  Created by David Nedrow on 7/15/16.
//  Copyright (c) 2016 David Nedrow. All rights reserved.
//

@import Foundation;

#ifndef DNFortuneParserErrors_h
#define DNFortuneParserErrors_h

static NSString *const DNFortuneParserErrorDomain = @"DNFortuneParserErrorDomain";

typedef NS_ENUM(NSInteger, DNFortuneParserErrorCodes) {
    FileNotFound,
    NoFileNameProvided,
    FileEncodingInvalid
};

#endif /* DNFortuneParserErrors_h */
