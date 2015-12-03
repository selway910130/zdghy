//
//  AppDelegate.m
//  test
//
//  Created by selway on 2013-05-29.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (NSDictionary*) connectToServer:(NSString *)post :(NSURL *)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSLog(@"%@", post);
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSHTTPURLResponse *response = nil;
    NSError *error = [[NSError alloc]init];
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    NSDictionary *searchResult;
    
    if ([response statusCode] >= 200 && [response statusCode] < 300){
        searchResult = [NSJSONSerialization JSONObjectWithData:urlData options:   NSJSONReadingMutableLeaves error:&error];
    }
    else{
        [SVProgressHUD show];
        [SVProgressHUD dismissWithError:@"网络连接错误"];
        searchResult = nil;
    }
    return searchResult;
}

@end
