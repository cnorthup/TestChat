//
//  ViewController.m
//  Chats
//
//  Created by Charles Northup on 4/20/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    devicePeerID = [[MCPeerID alloc] initWithDisplayName:@"Chat Room"];
    mySession = [[MCSession alloc] initWithPeer:devicePeerID];
    mySession.delegate = self;
    serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:devicePeerID discoveryInfo:nil serviceType:@"hey"];
    serviceAdvertiser.delegate = self;
    nearbyServiceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:devicePeerID serviceType:@"browse"];
    nearbyServiceBrowser.delegate = self;
    [super viewDidLoad];
    
    
                         
}
- (IBAction)onStartButtonPressed:(id)sender {
    NSLog(@"start");
    [self start];

}

#pragma mark -- Browser
                         
-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"Session Manager found peer: %@", peerID);
    [nearbyServiceBrowser invitePeer:peerID toSession:mySession withContext:nil timeout:20];
    
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"Session Manager lost peer: %@", peerID);
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"Did not start browsing for peers: %@", error);
}

#pragma mark -- Advertiser


-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    NSLog(@"invitation received");
    invitationHandler(YES, mySession);
    
}

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"Did not start advertising error: %@", error);
}

#pragma mark -- Session

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    NSLog(@"Did receive certificate");
    certificateHandler(true);
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Did receive data.");
    
    /// Receive the string here.
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Message: %@",message);


}
-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
        
}
                         
 -(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
        
}
                         
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
        
}
                         
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateConnected: {
            
            NSLog(@"Connected to %@", peerID);
            NSError *error;
            [session sendData:[@"text" dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peerID] withMode:MCSessionSendDataReliable error:&error];
            
            break;
        } case MCSessionStateConnecting: {
            NSLog(@"Connecting to %@", peerID);
            
            break;
        } case MCSessionStateNotConnected: {
            break;
        }
    }
        
}

- (void)start {
    [serviceAdvertiser startAdvertisingPeer];
    [nearbyServiceBrowser startBrowsingForPeers];
}

- (void)stop {
    [serviceAdvertiser stopAdvertisingPeer];
    [nearbyServiceBrowser stopBrowsingForPeers];
}



@end
