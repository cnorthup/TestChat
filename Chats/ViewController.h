//
//  ViewController.h
//  Chats
//
//  Created by Charles Northup on 4/20/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface ViewController : UIViewController <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate>
{
    MCPeerID* devicePeerID;
    MCSession* mySession;
    MCNearbyServiceAdvertiser* serviceAdvertiser;
    MCNearbyServiceBrowser* nearbyServiceBrowser;
}

@end
