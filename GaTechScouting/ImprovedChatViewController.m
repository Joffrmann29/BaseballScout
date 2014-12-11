//  ImprovedChatViewController.m
//  BornTogether
//
//  Created by Stefan Brown on 11/6/14.
//  Copyright (c) 2014 Nutech Systems. All rights reserved.

#import "ImprovedChatViewController.h"
#import <JSQMessagesAvatarImageFactory.h>
#import <JSQMessagesBubbleImageFactory.h>
#import <JSQMessagesMediaViewBubbleImageMasker.h>
#import <JSQMessages.h>
#import <Parse/Parse.h>

@interface ImprovedChatViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) NSString *currentUserAlias;
@property (nonatomic, weak) NSString *currentUserObjectID;
@property (nonatomic, strong) JSQMessagesAvatarImage *matchedAvatar;
@property (nonatomic, strong) JSQMessagesAvatarImage *currentAvatar;
@property (nonatomic, strong) JSQMessagesBubbleImageFactory *bubbleFactory;

@property (nonatomic, strong) UIColor *matchedColor;
@property (nonatomic, strong) UIColor *currentColor;

@property (atomic, strong) PFQuery *query;

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSMutableArray *posts;
@property (atomic) BOOL running;
@property (nonatomic, strong) NSNotificationCenter *notification;

@end

@implementation ImprovedChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _running = YES;
    _className = @"Chat";
    NSLog(@"%@", self.player[@"username"]);
    self.navigationItem.title = self.player[@"username"];

    self.automaticallyScrollsToMostRecentMessage = YES;
    
    PFUser *currentUser = [PFUser currentUser];
    _currentUserAlias = [currentUser objectForKey:@"FirstName"];
    _currentUserObjectID = currentUser.objectId;
    
    if ([currentUser[@"UserType"] isEqualToString:@"Scout"]) {
        _currentColor = [UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
    } else {
        _currentColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];
    }
    
    if ([_player[@"UserType"] isEqualToString:@"Player"]) {
        _matchedColor = [UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
    } else {
        _matchedColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];
    }
    
//    _matchedUserAlias = _matchedUser[@"Alias"];
    
    NSLog(@"User matched with that has same birthday: %@", self.player);
    NSLog(@"Currently logged in user: %@", currentUser);
    _posts = [[NSMutableArray alloc]init];
    
    _matchedImage = [JSQMessagesAvatarImageFactory circularAvatarImage:_matchedImage withDiameter:_matchedImage.size.width];
    
    _matchedAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:_matchedImage diameter:_matchedImage.size.width];
    
    _currentImage = [JSQMessagesAvatarImageFactory circularAvatarImage:_currentImage withDiameter:_currentImage.size.width];
    
    _currentAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:_currentImage diameter:_currentImage.size.width];
    
    _bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
    NSString *userID = _currentUserObjectID;
    NSString *matchedID = _player.objectId;
    
    PFQuery *query1 = [PFQuery queryWithClassName:_className];
    PFQuery *query2 = [PFQuery queryWithClassName:_className];
    
    //find cases where sender is currentUser and matched user is receiver.
    [query1 whereKey:@"sender" equalTo:userID];
    [query1 whereKey:@"receiver" equalTo:matchedID];
    //find cases where receiver is currentUser and matched user is sending.
    [query2 whereKey:@"sender" equalTo:matchedID];
    [query2 whereKey:@"receiver" equalTo:userID];
    
    NSLog(@"Trying to retrieve from cache");
    _query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
    _query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [_query orderByDescending:@"createdAt"];
    _query.limit = 20;
    
    [self loadLocalChat];
}

#pragma mark - Overriden UIViewController methods
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePush:) name:@"ReceivePush" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLocalChat) name:@"BecameActive" object:nil];
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You tapped the avatar at: %lu", indexPath.row);
}


#pragma JSQMessagesViewDataSource
-(NSString *)senderDisplayName
{
    return _currentUserAlias;
}

-(NSString *)senderId
{
    return _currentUserObjectID;
}

-(void)viewWillDisappear:(BOOL)animated
{
    _running = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:YES];
}

-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *post = _posts[indexPath.row];
    PFUser *user = [PFUser currentUser];
    
    NSString *senderID = post[@"sender"];
    NSString *alias;
    BOOL outgoing;
    if ([user.objectId isEqualToString:senderID]) {
        alias = _currentUserAlias;
        outgoing = YES;
    } else {
        alias = _player[@"FirstName"];
        outgoing = NO;
    }
    PFFile *imageFile =post[@"imageContent"];
    

    if (imageFile) {
        NSData *imageData = [imageFile getData];
        UIImage *imageContent = [UIImage imageWithData:imageData];

        JSQPhotoMediaItem *media = [[JSQPhotoMediaItem alloc] initWithMaskAsOutgoing:outgoing];
        media.image = imageContent;
        JSQMessage *message = [JSQMessage messageWithSenderId:senderID displayName:alias media:media];

        return message;
    } else {
        NSString *content = post[@"content"];
        JSQMessage *message = [JSQMessage messageWithSenderId:senderID displayName:alias text:content];
        return message;
    }
}

-(id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *post = _posts[indexPath.row];
//    NSString *postID = post.objectId;
    NSString *senderID = post[@"sender"];
//    NSString *content =post[@"content"];
//    NSLog(@"%@", postID);
//    if (content.length <1) {
//        NSLog(@"image found");
//    }
//    content = nil;
    JSQMessagesBubbleImage *bubble;
    
    
    if ([senderID isEqualToString:_currentUserObjectID]) {
        bubble = [_bubbleFactory outgoingMessagesBubbleImageWithColor:_currentColor];
    } else {
        bubble = [_bubbleFactory incomingMessagesBubbleImageWithColor:_matchedColor];
    }
    return bubble;
}

-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *post = _posts[indexPath.row];
    NSString *userID = post[@"sender"];
    if ([_currentUserObjectID isEqualToString:userID]) {
        return _currentAvatar;
    } else {
        return _matchedAvatar;
    }
}
//#pragma JSQMessageMediaData
//
////-(NSUInteger)hash{
////    return
////}
//
//-(UIView *)mediaPlaceholderView{
//    JSQMessagesMediaPlaceholderView *view = [JSQMessagesMediaPlaceholderView viewWithActivityIndicator];
//    return view;
//}

#pragma JSQMessagesCollectionViewController
-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    if([text length] > 0)
    {
        PFObject *post = [[PFObject alloc]initWithClassName:_className];
        post[@"sender"] = _currentUserObjectID;
        post[@"receiver"] = _player.objectId;
        post[@"content"] = text;
        post[@"currentSenderName"] = _currentUserAlias;
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [_posts addObject:post];
            [self finishSendingMessage];
        }];
    }
    self.inputToolbar.contentView.textView.text = @"";
}

-(void)didPressAccessoryButton:(UIButton *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{}];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    PFObject *post = [[PFObject alloc]initWithClassName:_className];
    post[@"sender"] = _currentUserObjectID;
    post[@"receiver"] = _player.objectId;
    post[@"currentSenderName"] = _currentUserAlias;
    NSData *imageData = UIImageJPEGRepresentation(myImage, 0.05f);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            [post setObject:imageFile forKey:@"imageContent"];
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [_posts addObject:post];
                    [self finishSendingMessage];

                }
            }];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma CollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _posts.count;
}

-(void)receivePush:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSLog(@"%@", userInfo);
    
    NSString *content = userInfo[@"Content"];
    NSString *sender = userInfo[@"senderID"];
    NSString *chatID = userInfo[@"chatID"];
    PFObject *pushedChat = [PFObject objectWithClassName:@"chat"];
    pushedChat.objectId = chatID;
    if ([sender isEqualToString:_player.objectId]) {
        if (content.length == 0) {
            [pushedChat fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                [_posts addObject:pushedChat];
                [self.collectionView reloadData];
            }];
        } else {
            pushedChat[@"content"] = content;
            pushedChat[@"sender"] = sender;
            [_posts addObject:pushedChat];
            [self finishReceivingMessage];
        }
    }
}

#pragma mark - Parse
//handles the chat database querying. Polls database on a 5s interval.
- (void)loadLocalChat
{
    [_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu posts from cache.", (unsigned long)objects.count);
            [_posts removeAllObjects];
            if (objects.count != 0) {
                [_posts addObjectsFromArray:[[objects reverseObjectEnumerator] allObjects]];
            }
            [self finishReceivingMessage];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


@end