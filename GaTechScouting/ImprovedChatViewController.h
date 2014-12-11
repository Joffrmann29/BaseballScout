//
//  ImprovedChatViewController.h
//  BornTogether
//
//  Created by Stefan Brown on 11/6/14.
//  Copyright (c) 2014 Nutech Systems. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "AppDelegate.h"

@interface ImprovedChatViewController : JSQMessagesViewController

@property (strong, nonatomic) PFObject *player; //This is the user you are matched up with

@property (strong, nonatomic) UIImage *currentImage;
@property (weak, nonatomic) UIImage *matchedImage;
@end
