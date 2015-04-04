//
//  SettingsViewController.m
//  Todo
//
//  Created by ltebean on 14/11/10.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "SettingsViewController.h"
#import "LTPopButton.h"
#import "Settings.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

@interface SettingsViewController ()<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *fontLabel;
@property (weak, nonatomic) IBOutlet LTPopButton *backButton;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.backButton.lineColor = [UIColor whiteColor];
    [self.backButton animateToType:closeType];
    NSString *fontFamily = [Settings fontFamily];
    self.fontLabel.text = fontFamily;
    self.fontLabel.font = [UIFont fontWithName:fontFamily size:15];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1 && indexPath.row==0) {
        [self goRating];
    } else if (indexPath.section==1 && indexPath.row==1) {
        [self sendMail];
    }
}

- (void)sendMail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.navigationBar.tintColor=[UIColor whiteColor];
        picker.mailComposeDelegate = self;
        [picker setSubject:@"Feedback for Todotrix"];
        [picker setToRecipients:[NSArray arrayWithObjects:@"yucong1118@gmail.com", nil]];
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please set up an account for sending mail on your device" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"confirm", nil];
        [alert show];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    NSString* message=nil;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            message=@"draft has been saved";
            break;
        case MFMailComposeResultSent:
            message=@"mail has been scheduled to be sent";
            break;
        case MFMailComposeResultFailed:
            message=@"failed to send";
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    if (message) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }
}


- (void)goRating
{
    NSString *REVIEW_URL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=939523047&onlyLatestVersion=true&type=Purple+Software";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REVIEW_URL]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
