//
//  Utilities.m
//  Essel World
//
//  Created by Karan Ram Pal on 14/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "Utilities.h"
#import "Reachability.h"

@implementation Utilities

+ (BOOL) isConnected {
    
    
    Reachability * reachability;
    if (!reachability) {
        reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
    }
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
        //DLog(@"No Network Reachability!");
        return NO;
    }
    else if (remoteHostStatus == ReachableViaWiFi) {
        //DLog(@"WiFi Network Reachability");
        return YES;
    }
    else if (remoteHostStatus == ReachableViaWWAN) {
        // DLog(@"Cellular Network Reachability");
        return YES;
    }
    return NO;
}

@end
