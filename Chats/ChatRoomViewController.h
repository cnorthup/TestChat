//
//  ChatRoomViewController.h
//  Chats
//
//  Created by Charles Northup on 4/20/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ChatRoomViewController : MCBrowserViewController <MCAdvertiserAssistantDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate>
{
    MCPeerID* devicePeerID;
    MCSession* session;
    MCNearbyServiceAdvertiser* serviceAdvertiser;
    MCNearbyServiceBrowser* nearbyServiceBrowser;
}

@end
