//
//  ViewController.m
//  Gardr Host
//
//  Created by Sørensen, Johan on 02.10.14.
//  Copyright (c) 2014 FINN.no AS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.webView.delegate = self;
    self.webView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.webView.layer.borderWidth = 1.0f;
}

- (IBAction)loadTapped:(id)sender
{
    NSURL *url = [NSURL URLWithString:self.addressTextField.text];
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }

    return YES;
}

@end
