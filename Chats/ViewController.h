//
//  ViewController.h
//  Chats
//
//  Created by Charles Northup on 4/20/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface ViewController : UIViewController <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCAdvertiserAssistantDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceBrowserDelegate>
{
    MCPeerID* devicePeerID;
    MCSession* mySession;
    MCAdvertiserAssistant* advertiserAssistant;
}

+(void)session:(MCSession*)session message:(NSString*)message peers:(NSArray*)peers
          mode:(MCSessionSendDataMode*)mode error:(NSError*)error completionBlock:(void(^)(void))completionBlock;

@end
