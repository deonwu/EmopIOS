//
//  AboutViewController.m
//  zaol
//
//  Created by hark2046 on 13-3-8.
//
//

#import "AboutViewController.h"
#import "CommonDef.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:rgba(246, 246, 246, 1)];
    
    [self.navigationItem setTitle:@"关于兜兜购"];
    
	// Do any additional setup after loading the view.
    UIImageView * img = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [img setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    
    [img setImage:[UIImage imageNamed:@"about.png"]];
    [img setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.view addSubview:img];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
