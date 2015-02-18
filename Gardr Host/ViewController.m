//
//  ViewController.m
//  Gardr Host
//
//  Created by Sørensen, Johan on 02.10.14.
//  Copyright (c) 2014 FINN.no AS. All rights reserved.
//

#import "ViewController.h"

#define SUPPORT_LEGACY_LINK_FORMAT 1

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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
#if SUPPORT_LEGACY_LINK_FORMAT
    NSString *js = @"var open_ = window.open; \n"
    "window.open = function(url, name, properties)  \n"
    "{   \n"
    "if(name == 'new_window'){ \n"
    "    var prefix = 'openexternal:';\n"
    "    var address = url; \n"
    "    open_(prefix + address); \n"
    "} \n"
    "    return open_(address, name, properties); \n"
    "};";

    [webView stringByEvaluatingJavaScriptFromString:js];
#endif
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }

#if SUPPORT_LEGACY_LINK_FORMAT
    NSString *urlString = [[request URL] absoluteString];
    if ([urlString rangeOfString:@"openexternal:"].location != NSNotFound) {
        NSString *urlWithoutPrefix = [urlString stringByReplacingOccurrencesOfString:@"openexternal:" withString:@""];
        if (urlWithoutPrefix) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlWithoutPrefix]];
        }
        return NO;
    }
#endif

    return YES;
}

@end
