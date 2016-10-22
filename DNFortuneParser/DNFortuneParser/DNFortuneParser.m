//
//  DNFortuneParser.m
//  DNFortuneParser
//
//  Created by David Nedrow on 7/14/16.
//  Copyright © 2016 David Nedrow. All rights reserved.
//

#import "DNFortuneParser.h"
#import "DNFortuneParserErrors.h"
#import "Fortune.h"

@interface DNFortuneParser ()
@end

@implementation DNFortuneParser {
}

+ (NSArray *)parseFortunesFromFile:(NSString *)fileName error:(NSError **)outError {

    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];

    if (fileName == nil || [fileName isEqualToString:@""]) {

        NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey : NSLocalizedString(@"Operation was unsuccessful.", nil),
                NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"A filename is required", nil),
                NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Verify that you have provided a filename.", nil)};

        *outError = [NSError errorWithDomain:DNFortuneParserErrorDomain
                                        code:NoFileNameProvided
                                    userInfo:userInfo];
        return nil;
    }

    if (![fileManager fileExistsAtPath:fileName]) {

        NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey : NSLocalizedString(@"Operation was unsuccessful.", nil),
                NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"The file %@ was not found.", nil), fileName],
                NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Verify that you have the path correct.", nil)};

        *outError = [NSError errorWithDomain:DNFortuneParserErrorDomain
                                        code:FileNotFound
                                    userInfo:userInfo];
        return nil;
    }

    NSStringEncoding stringEncoding;
    NSString *fileContents = [NSString stringWithContentsOfFile:fileName usedEncoding:&stringEncoding error:nil];

    if (fileContents && (stringEncoding == kCFStringEncodingInvalidId)) {
        CFStringEncoding cfStringEncoding = CFStringConvertNSStringEncodingToEncoding(stringEncoding);
        NSString *encodingName = (NSString *) CFStringGetNameOfEncoding(cfStringEncoding);

        NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey : NSLocalizedString(@"Operation was unsuccessful.", nil),
                NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"The file encoding could not be determined: %@.", nil), encodingName],
                NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Verify that you have the file is saved with a valid encoding type, eg. UTF-8.", nil)};

        *outError = [NSError errorWithDomain:DNFortuneParserErrorDomain
                                        code:FileEncodingInvalid
                                    userInfo:userInfo];
        return nil;
    }

    NSArray *fileLines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    NSMutableArray *fortune = [NSMutableArray new];
    NSMutableArray *parsedFortunes = [NSMutableArray new];
    NSError *error;

    for (NSString *line in fileLines) {
        if (line.length > 1 && [[line substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"%%"]) {
            NSLog(@"%@", line); //Comment
        } else if (line.length > 0 && ![[line substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"%"]) {
            if([self checkForAttributionWithString:line error:&error] && !(error)) {
                NSLog(@">>>>> %@", line);
            }
            [fortune addObject:line]; //Text - Fortune body
        } else if (line.length == 0) {
            [fortune addObject:line]; //Empty line - Fortune body
        } else {
            [parsedFortunes addObject:[[Fortune alloc] initWithArray:[fortune copy] andString:@"Blah"]];
            [fortune removeAllObjects];
        }
    }

    for (Fortune *thisFortune in parsedFortunes) {
        NSLog(@"%@", thisFortune.text);
    }
    return nil;
}

+(bool)checkForAttributionWithString:(NSString *)line error:(NSError **)outError{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\\s|\\t]+-- (.*)$" options:0 error:&error];
    if (error) {
        NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey : NSLocalizedString(@"Operation was unsuccessful.", nil),
                NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"Couldn't create regex with given pattern and options.", nil)],
                NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Verify the pattern.", nil)};

        *outError = [NSError errorWithDomain:DNFortuneParserErrorDomain
                                        code:RegexCreationFailed
                                    userInfo:userInfo];
        return nil;
    }

    NSRange textRange = NSMakeRange(0, line.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:line options:NSMatchingReportProgress range:textRange];

    return (matchRange.location != NSNotFound);
}
@end
