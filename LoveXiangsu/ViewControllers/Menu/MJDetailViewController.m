//
//  MJDetailViewController.m
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import "MJDetailViewController.h"

@implementation MJDetailViewController
@synthesize label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
       
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary * infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString * versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
    //        NSString * appName =[infoDict objectForKey:@"CFBundleDisplayName"];
    NSString * text =[NSString stringWithFormat:@"Version: %@",versionNum];
    
    label.text = text;
    
}

@end
