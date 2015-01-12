//
//  TwitterOAuthViewController.m
//  Twitter-OAuth
//
//  Created by 杨建亚 on 15/1/12.
//  Copyright (c) 2015年 Dwarven. All rights reserved.
//

#import "TwitterOAuthViewController.h"
#import "OAuthConsumer.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

NSString *client_id = @"2sVEcZDhudTeScaMShpd3w";
NSString *secret = @"CVqonV4B8wDxSnwzzXCC2uhak8H22R1gXhbsCSF1400";
NSString *callback = @"http://codegerms.com/callback";

@interface TwitterOAuthViewController ()<UIWebViewDelegate>{
    OAConsumer * _consumer;
    OAToken * _requestToken;
    OAToken * _accessToken;
    void(^_completion)(BOOL, id);
}

@property(nonatomic, strong) UIWebView * webView;
@property(nonatomic, strong) NSString * isLogin;

@end

@implementation TwitterOAuthViewController

- (id)initWithCompletion:(void (^)(BOOL, id))completion{
    self = [super init];
    if (self) {
        _completion = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor grayColor]];
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
        [_webView setDelegate:self];
        [self.view addSubview: _webView];
    }
    _consumer = [[OAConsumer alloc] initWithKey:client_id secret:secret];
    NSURL* requestTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    OAMutableURLRequest* requestTokenRequest = [[OAMutableURLRequest alloc] initWithURL:requestTokenUrl
                                                                               consumer:_consumer
                                                                                  token:nil
                                                                                  realm:nil
                                                                      signatureProvider:nil];
    OARequestParameter* callbackParam = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:callback];
    [requestTokenRequest setHTTPMethod:@"POST"];
    [requestTokenRequest setParameters:[NSArray arrayWithObject:callbackParam]];
    OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
    [dataFetcher fetchDataWithRequest:requestTokenRequest
                             delegate:self
                    didFinishSelector:@selector(didReceiveRequestToken:data:)
                      didFailSelector:@selector(didFailOAuth:error:)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveRequestToken:(OAServiceTicket*)ticket data:(NSData*)data {
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    _requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
    NSURL* authorizeUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/authorize"];
    OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:authorizeUrl
                                                                            consumer:nil
                                                                               token:nil
                                                                               realm:nil
                                                                   signatureProvider:nil];
    NSString* oauthToken = _requestToken.key;
    OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken];
    [authorizeRequest setParameters:[NSArray arrayWithObject:oauthTokenParam]];
    
    [_webView loadRequest:authorizeRequest];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //  [indicator startAnimating];
    NSString *temp = [NSString stringWithFormat:@"%@",request];
    //  BOOL result = [[temp lowercaseString] hasPrefix:@"http://codegerms.com/callback"];
    // if (result) {
    NSRange textRange = [[temp lowercaseString] rangeOfString:[@"http://codegerms.com/callback" lowercaseString]];
    
    if(textRange.location != NSNotFound){
        
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"oauth_verifier"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        if (verifier) {
            NSURL* accessTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
            OAMutableURLRequest* accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:accessTokenUrl consumer:_consumer token:_requestToken realm:nil signatureProvider:nil];
            OARequestParameter* verifierParam = [[OARequestParameter alloc] initWithName:@"oauth_verifier" value:verifier];
            [accessTokenRequest setHTTPMethod:@"POST"];
            [accessTokenRequest setParameters:[NSArray arrayWithObject:verifierParam]];
            OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
            [dataFetcher fetchDataWithRequest:accessTokenRequest
                                     delegate:self
                            didFinishSelector:@selector(didReceiveAccessToken:data:)
                              didFailSelector:@selector(didFailOAuth:error:)];
        } else {
            // ERROR!
        }
        
        [webView removeFromSuperview];
        
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    // ERROR!
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // [indicator stopAnimating];
}

- (void)didReceiveAccessToken:(OAServiceTicket*)ticket data:(NSData*)data {
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    _accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    // WebServiceSocket *connection = [[WebServiceSocket alloc] init];
    //  connection.delegate = self;
    NSString *pdata = [NSString stringWithFormat:@"type=2&token=%@&secret=%@&login=%@", _accessToken.key, _accessToken.secret, self.isLogin];
    // [connection fetch:1 withPostdata:pdata withGetData:@"" isSilent:NO];
    NSLog(@"%@",_accessToken.secret);
    
    
    
    if (_accessToken) {
        NSURL* userdatarequestu = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
        OAMutableURLRequest* requestTokenRequest = [[OAMutableURLRequest alloc] initWithURL:userdatarequestu
                                                                                   consumer:_consumer
                                                                                      token:_accessToken
                                                                                      realm:nil
                                                                          signatureProvider:nil];
        
        [requestTokenRequest setHTTPMethod:@"GET"];
        OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
        [dataFetcher fetchDataWithRequest:requestTokenRequest
                                 delegate:self
                        didFinishSelector:@selector(didReceiveuserdata:data:)
                          didFailSelector:@selector(didFailOdatah:error:)];    } else {
            // ERROR!
        }
}

- (void)didReceiveuserdata:(OAServiceTicket*)ticket data:(NSData*)data {
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[httpBody dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    _completion(YES,dic);
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didFailOAuth:(OAServiceTicket*)ticket error:(NSError*)error {
    // ERROR!
}

- (void)didFailOdatah:(OAServiceTicket*)ticket error:(NSError*)error {
    // ERROR!
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
