//
//  SpotifyApi.cpp
//  SpotifyPlugin
//
//  Created by Junian on 12/29/15.
//  Copyright © 2015 Junian. All rights reserved.
//

#import "SpotifyApi.h"

@implementation SpotifyApi: NSObject

+ (NSString*) ExecuteAppleScriptWithPhrase:(NSString*) phrase
{
    NSString* output = @"";
    NSString* command = [NSString stringWithFormat:@"%@ %@", @"tell application \"Spotify\" to", phrase];
    NSAppleScript* script = [[NSAppleScript alloc]initWithSource:command];
    
    NSDictionary* errorInfo = nil;
    NSAppleEventDescriptor* descriptor = [script executeAndReturnError:&errorInfo];
    if(descriptor.stringValue != nil){
        output = descriptor.stringValue;
    }
    return output;
}

@end

extern "C" {
    const char* ExecuteAppleScript(const char* command){
        NSString* cmd = [[NSString alloc] initWithUTF8String:command];
        return (char*)[[SpotifyApi ExecuteAppleScriptWithPhrase:cmd] UTF8String];
    }
}


