//
//  SpotifyApi.cpp
//  SpotifyPlugin
//
//  Created by Junian on 12/29/15.
//  Copyright © 2015 Junian. All rights reserved.
//

#import "SpotifyApi.h"

@implementation SpotifyApi: NSObject

+ (NSString*) Play
{
    NSString* command = @"play";
    return [SpotifyApi ExecuteSpotifyAppleScriptWithPhrase:command];
}

+ (NSString*) PlayPause
{
    NSString* command = @"playpause";
    return [SpotifyApi ExecuteSpotifyAppleScriptWithPhrase:command];
}

+ (NSString*) Pause
{
    NSString* command = @"pause";
    return [SpotifyApi ExecuteSpotifyAppleScriptWithPhrase:command];
}

+ (NSString*) PlayTrack:(NSString*) trackUri
{
    NSString* command = [NSString stringWithFormat:@"play track \"%@\"", trackUri];
    return [SpotifyApi ExecuteSpotifyAppleScriptWithPhrase:command];
}

+ (NSString*) PlayLoop:(NSString*) trackUri
{
    NSString* command = [NSString stringWithFormat:@"tell application \"Spotify\"\n  set shuffling to false\n  set repeating to true\n  play track \"%@\"\nend tell\n", trackUri];
    return [SpotifyApi ExecuteAppleScriptWithPhrase:command];
}

+ (NSString*) PlayOnce:(NSString*) trackUri
{
    NSString* command = [NSString stringWithFormat:@"tell application \"Spotify\"\n  pause\n  set shuffling to false\n  set repeating to false\n  play track \"%@\"\nend tell\n", trackUri];
    return [SpotifyApi ExecuteAppleScriptWithPhrase:command];
}

+ (NSString*) SetShuffling:(BOOL*) isShuffling
{
    NSString* command = [NSString stringWithFormat:@"set shuffling to %@", isShuffling ? @"true" : @"false"];
    return [SpotifyApi ExecuteSpotifyAppleScriptWithPhrase:command];
}

+ (NSString*) SetRepeating:(BOOL*) isRepeating
{
    NSString* command = [NSString stringWithFormat:@"set repeating to %@", isRepeating ? @"true" : @"false"];
    return [SpotifyApi ExecuteSpotifyAppleScriptWithPhrase:command];
}

+ (NSString*) PlayerState
{
    NSString* command = [NSString stringWithFormat:@"player state as text"];
    return [SpotifyApi ExecuteSpotifyAppleScriptWithPhrase:command];
}

+ (NSString*) ExecuteAppleScriptWithPhrase:(NSString*) phrase
{
    NSString* output = @"";
    NSString* command = [NSString stringWithFormat:@"%@", phrase];
    NSAppleScript* script = [[NSAppleScript alloc]initWithSource:command];
    
    NSDictionary* errorInfo = nil;
    NSAppleEventDescriptor* descriptor = [script executeAndReturnError:&errorInfo];
    if(descriptor.stringValue != nil){
        output = descriptor.stringValue;
    }
    return output;
}

+ (NSString*) ExecuteSpotifyAppleScriptWithPhrase:(NSString*) phrase
{
    NSString* command = [NSString stringWithFormat:@"%@ %@", @"tell application \"Spotify\" to", phrase];
    return [SpotifyApi ExecuteAppleScriptWithPhrase:command];
}

@end

extern "C" {
    const char* _ExecuteSpotifyAppleScript(const char* command){
        NSString* cmd = [[NSString alloc] initWithUTF8String:command];
        return (char*)[[SpotifyApi ExecuteSpotifyAppleScriptWithPhrase:cmd] UTF8String];
    }
    
    const char* _ExecuteAppleScript(const char* command){
        NSString* cmd = [[NSString alloc] initWithUTF8String:command];
        return (char*)[[SpotifyApi ExecuteAppleScriptWithPhrase:cmd] UTF8String];
    }
}


